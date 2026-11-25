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

QuestNightInput _toQuestInput(CheckInRow row, QuestMode mode) =>
    QuestNightInput(
      wakeDate: _dateOnly(row.wakeDate),
      result: _fromDbResult(row.result),
      onTime: row.onTime,
      usedShield: row.usedShield,
      mode: mode,
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

  /// Check-ins in [start]..[end], each with the quest mode its night had.
  Future<List<QuestNightInput>> _nights(DateTime start, DateTime end) async {
    final rows =
        await (db.select(db.checkIns)..where(
              (t) =>
                  t.wakeDate.isBiggerOrEqualValue(start) &
                  t.wakeDate.isSmallerOrEqualValue(end),
            ))
            .get();
    final plans =
        await (db.select(db.nightPlans)..where(
              (t) =>
                  t.wakeDate.isBiggerOrEqualValue(start) &
                  t.wakeDate.isSmallerOrEqualValue(end),
            ))
            .get();
    final modes = {
      for (final p in plans)
        _dateOnly(p.wakeDate):
            QuestMode.values[p.questMode ?? QuestMode.normal.index],
    };
    return [
      for (final row in rows)
        _toQuestInput(row, modes[_dateOnly(row.wakeDate)] ?? QuestMode.normal),
    ];
  }

  Future<List<QuestNightInput>> _weekNights(DateTime monday) =>
      _nights(monday, DateTime(monday.year, monday.month, monday.day + 6));

  /// Nights passed this week, for the dots on the Tonight screen (●●●○○).
  Future<int> currentWeekPassCount(DateTime now) async =>
      weeklyPassCount(await _weekNights(mondayOfWeek(now)));

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

    final complete = weeklyQuestComplete(await _weekNights(monday));
    if (!complete) return;

    await db
        .into(db.weeklyQuestProgresses)
        .insertOnConflictUpdate(
          WeeklyQuestProgressesCompanion.insert(
            weekStart: monday,
            rewardClaimed: const Value(true),
          ),
        );
    await walletRepo.addCoins(EconomyConfig.weeklyQuestCoins);
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
    final completeByDate = {
      for (final night in await _nights(rangeStart, rangeEnd))
        night.wakeDate: nightPasses(night),
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
      await walletRepo.grantItem(EconomyConfig.examPeriodRewardBlanket.id, now);
    }
  }
}
