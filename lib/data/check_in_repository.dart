import 'package:drift/drift.dart';

import '../core/check_in.dart';
import '../core/fire.dart';
import 'database.dart';
import 'fire_repository.dart';
import 'night_planning_repository.dart';
import 'settings_repository.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

CheckInResultDb _toDbResult(CheckInResult result) => switch (result) {
  CheckInResult.enough => CheckInResultDb.enough,
  CheckInResult.almostEnough => CheckInResultDb.almostEnough,
  CheckInResult.notEnough => CheckInResultDb.notEnough,
  CheckInResult.over => CheckInResultDb.over,
};

CheckInResult _fromDbResult(CheckInResultDb result) => switch (result) {
  CheckInResultDb.enough => CheckInResult.enough,
  CheckInResultDb.almostEnough => CheckInResult.almostEnough,
  CheckInResultDb.notEnough => CheckInResult.notEnough,
  CheckInResultDb.over => CheckInResult.over,
};

/// How many past days [CheckInRepository.sweepMissedNights] looks back for
/// closed-but-unprocessed check-in windows. One week plus a little slack
/// covers any stretch the app was closed over.
const int _missedNightsLookbackDays = 10;

/// A locked night plan still waiting on a check-in, with the defaults the
/// check-in card pre-fills (CLAUDE.md section 6).
class PendingCheckIn {
  final DateTime wakeDate;
  final DateTime plannedBedtime;
  final DateTime plannedWakeTime;

  const PendingCheckIn({
    required this.wakeDate,
    required this.plannedBedtime,
    required this.plannedWakeTime,
  });
}

/// One night's worth of data for the 7-day bar chart / weekly summary.
class WeekCheckInSummary {
  final DateTime wakeDate;
  final CheckInRow? checkIn;

  const WeekCheckInSummary({required this.wakeDate, required this.checkIn});
}

/// Records morning check-ins and keeps fire in sync with them, per
/// CLAUDE.md sections 6-7.
class CheckInRepository {
  final AppDatabase db;
  final NightPlanningRepository nightPlanningRepo;
  final FireRepository fireRepo;
  final SettingsRepository settingsRepo;

  CheckInRepository(
    this.db,
    this.nightPlanningRepo,
    this.fireRepo,
    this.settingsRepo,
  );

  Future<CheckInRow?> getForWakeDate(DateTime wakeDate) {
    final target = _dateOnly(wakeDate);
    return (db.select(
      db.checkIns,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();
  }

  Stream<CheckInRow?> watchForWakeDate(DateTime wakeDate) {
    final target = _dateOnly(wakeDate);
    return (db.select(
      db.checkIns,
    )..where((t) => t.wakeDate.equals(target))).watchSingleOrNull();
  }

  /// Records a check-in for [wakeDate] and applies its fire effect. The
  /// night's plan must already be locked (it will have been, by the time a
  /// user is checking in after waking up).
  Future<CheckInOutcome> recordCheckIn({
    required DateTime wakeDate,
    required DateTime lightsOffAt,
    required DateTime actualWakeAt,
    required DateTime now,
  }) async {
    final target = _dateOnly(wakeDate);
    final plan = await nightPlanningRepo.getOrLockPlan(target, now: now);
    final settings = toSleepSettings(await settingsRepo.get());

    final outcome = classifyCheckIn(
      lightsOffAt: lightsOffAt,
      actualWakeAt: actualWakeAt,
      plannedBedtime: plan.bedtime,
      settings: settings,
    );

    await db
        .into(db.checkIns)
        .insertOnConflictUpdate(
          CheckInsCompanion.insert(
            wakeDate: target,
            lightsOffAt: lightsOffAt,
            actualWakeAt: actualWakeAt,
            result: _toDbResult(outcome.result),
            onTime: outcome.onTime,
            checkedInAt: now,
          ),
        );

    final shieldConsumed = await _applyFireIfNotYetApplied(
      wakeDate: target,
      result: outcome.result,
      now: now,
    );
    if (shieldConsumed) {
      await (db.update(db.checkIns)..where((t) => t.wakeDate.equals(target)))
          .write(const CheckInsCompanion(usedShield: Value(true)));
    }

    return outcome;
  }

  /// The most recent locked night that's still waiting on a check-in and
  /// whose window is currently open, checking today's wake date then
  /// yesterday's (the two that could plausibly be "last night").
  Future<PendingCheckIn?> findPendingCheckIn(DateTime now) async {
    final today = _dateOnly(now);
    for (final wakeDate in [today, today.subtract(const Duration(days: 1))]) {
      final plan = await _getNightPlanRow(wakeDate);
      if (plan == null || !plan.isLocked) continue;
      if (!isCheckInWindowOpen(
        plannedWakeTime: plan.plannedWakeAt,
        now: now,
      )) {
        continue;
      }
      final existing = await getForWakeDate(wakeDate);
      if (existing != null) continue;
      return PendingCheckIn(
        wakeDate: wakeDate,
        plannedBedtime: plan.plannedBedtimeAt,
        plannedWakeTime: plan.plannedWakeAt,
      );
    }
    return null;
  }

  /// The 7 wake dates of the calendar week containing [wakeDate], each with
  /// its check-in if one exists — for the post-check-in weekly summary and
  /// 7-day bar chart (section 6).
  Future<List<WeekCheckInSummary>> weekSummary(DateTime wakeDate) async {
    final monday = _dateOnly(
      wakeDate,
    ).subtract(Duration(days: wakeDate.weekday - DateTime.monday));
    final result = <WeekCheckInSummary>[];
    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      result.add(
        WeekCheckInSummary(wakeDate: day, checkIn: await getForWakeDate(day)),
      );
    }
    return result;
  }

  /// Applies the "missed" fire effect to any locked night from the past
  /// whose check-in window has closed with no check-in, and marks it
  /// processed so it's never double-applied. Call on app open (section 6:
  /// "ไม่เช็กอินนับเหมือน 'ไม่ครบ' ในระบบไฟ").
  Future<void> sweepMissedNights(DateTime now) async {
    final today = _dateOnly(now);
    // Oldest to newest, so fire effects apply in chronological order — the
    // streak math in core/fire depends on that ordering when several
    // nights need sweeping at once (e.g. the app was unused for days).
    for (var i = _missedNightsLookbackDays; i >= 1; i--) {
      final wakeDate = today.subtract(Duration(days: i));
      final plan = await _getNightPlanRow(wakeDate);
      if (plan == null || !plan.isLocked || plan.fireAppliedAt != null) {
        continue;
      }
      if (now.isBefore(checkInWindowEnd(wakeDate))) continue;

      final checkIn = await getForWakeDate(wakeDate);
      final result = checkIn == null ? null : _fromDbResult(checkIn.result);
      await _applyFireIfNotYetApplied(
        wakeDate: wakeDate,
        result: result,
        now: now,
      );
    }
  }

  /// Applies this night's fire effect exactly once. Returns whether a
  /// shield absorbed the miss, so [recordCheckIn] can mark it on the
  /// check-in row for the heatmap's shield icon (section 10).
  Future<bool> _applyFireIfNotYetApplied({
    required DateTime wakeDate,
    required CheckInResult? result,
    required DateTime now,
  }) async {
    final plan = await _getNightPlanRow(wakeDate);
    if (plan == null || plan.fireAppliedAt != null) return false;

    final effect = determineFireEffect(
      isRedNightFromSchedule: plan.isRedNight,
      result: result,
    );
    final shieldsBefore = (await fireRepo.get()).shields;
    final after = await fireRepo.applyEffect(effect);
    await (db.update(
      db.nightPlans,
    )..where((t) => t.id.equals(plan.id))).write(
      NightPlansCompanion(fireAppliedAt: Value(now)),
    );
    return after.shields < shieldsBefore;
  }

  Future<NightPlan?> _getNightPlanRow(DateTime wakeDate) {
    return (db.select(
      db.nightPlans,
    )..where((t) => t.wakeDate.equals(wakeDate))).getSingleOrNull();
  }
}
