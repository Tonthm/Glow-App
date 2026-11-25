import 'package:drift/drift.dart';

import '../core/check_in.dart';
import '../core/economy_config.dart';
import '../core/night_date.dart';
import '../core/quests.dart';
import 'database.dart';
import 'schedule_repository.dart';
import 'wallet_repository.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

CheckInResult _fromDbResult(CheckInResultDb result) => switch (result) {
  CheckInResultDb.enough => CheckInResult.enough,
  CheckInResultDb.almostEnough => CheckInResult.almostEnough,
  CheckInResultDb.notEnough => CheckInResult.notEnough,
  CheckInResultDb.over => CheckInResult.over,
};

QuestNightInput _toQuestInput(CheckInRow row) => QuestNightInput(
  wakeDate: _dateOnly(row.wakeDate),
  result: row.usedShield ? null : _fromDbResult(row.result),
  onTime: row.onTime,
  usedShield: row.usedShield,
);

/// Claims the two aggregate quest rewards from CLAUDE.md section 8 that
/// can't be granted the moment a single check-in happens (the per-night
/// daily/exam-night coins already are, inline in CheckInRepository): the
/// weekly "ตรงเวลา 5 ใน 7" coin reward, and the exam-period "ครบทุกคืน
/// ก่อนสอบ" blanket. Call on app open, same spirit as the fire sweep.
class QuestRepository {
  final AppDatabase db;
  final WalletRepository walletRepo;
  final ScheduleRepository scheduleRepo;

  QuestRepository(this.db, this.walletRepo, this.scheduleRepo);

  Future<List<QuestNightInput>> _weekNights(DateTime monday) async {
    final sunday = monday.add(const Duration(days: 6));
    final rows =
        await (db.select(db.checkIns)..where(
              (t) =>
                  t.wakeDate.isBiggerOrEqualValue(monday) &
                  t.wakeDate.isSmallerOrEqualValue(sunday),
            ))
            .get();
    return rows.map(_toQuestInput).toList();
  }

  /// Progress toward this week's "ตรงเวลา 5 ใน 7" quest, for the dots on
  /// the Tonight screen (●●●○○).
  Future<int> currentWeekOnTimeCount(DateTime now) async {
    final monday = mondayOfWeek(now);
    return weeklyOnTimeCount(await _weekNights(monday));
  }

  /// Checks last week too: Sunday's night can still be checked in until
  /// Monday 14:00, after the week has already rolled over.
  Future<void> claimWeeklyRewardIfComplete(DateTime now) async {
    final monday = mondayOfWeek(now);
    await _claimWeek(DateTime(monday.year, monday.month, monday.day - 7));
    await _claimWeek(monday);
  }

  Future<void> _claimWeek(DateTime monday) async {
    final existing = await (db.select(
      db.weeklyQuestProgresses,
    )..where((t) => t.weekStart.equals(monday))).getSingleOrNull();
    if (existing?.rewardClaimed == true) return;

    final complete = weeklyOnTimeQuestComplete(await _weekNights(monday));
    if (!complete) return;

    await db
        .into(db.weeklyQuestProgresses)
        .insertOnConflictUpdate(
          WeeklyQuestProgressesCompanion.insert(
            weekStart: monday,
            rewardClaimed: const Value(true),
          ),
        );
    await walletRepo.addCoins(EconomyConfig.weeklyOnTimeQuestCoins);
  }

  Future<void> claimExamPeriodRewardsIfComplete(DateTime now) async {
    final examDates =
        (await scheduleRepo.getOneTimeItems())
            .where((i) => i.type == OneTimeItemType.exam)
            .map((i) => _dateOnly(i.date))
            .toSet()
            .toList()
          ..sort();
    if (examDates.isEmpty) return;

    final periods = groupExamPeriods(examDates);
    final rangeStart = periods.first.first;
    final rangeEnd = periods.last.last;
    final checkIns =
        await (db.select(db.checkIns)..where(
              (t) =>
                  t.wakeDate.isBiggerOrEqualValue(rangeStart) &
                  t.wakeDate.isSmallerOrEqualValue(rangeEnd),
            ))
            .get();
    final completeByDate = {
      for (final row in checkIns) _dateOnly(row.wakeDate): nightPassesDaily(_toQuestInput(row)),
    };
    bool isComplete(DateTime wakeDate) => completeByDate[wakeDate] ?? false;

    for (final period in periods) {
      final periodKey = period.first;
      final claimed = await (db.select(
        db.examPeriodClaims,
      )..where((t) => t.periodStartDate.equals(periodKey))).getSingleOrNull();
      if (claimed != null) continue;

      final allComplete = examPeriodAllNightsComplete(
        examDatesInPeriod: period,
        isNightComplete: isComplete,
      );
      if (!allComplete) continue;

      await db
          .into(db.examPeriodClaims)
          .insertOnConflictUpdate(
            ExamPeriodClaimsCompanion.insert(periodStartDate: periodKey),
          );
      await walletRepo.grantItem(
        EconomyConfig.examPeriodRewardBlanket.id,
        now,
      );
    }
  }
}
