import 'package:drift/drift.dart';

import '../core/birth_date.dart';
import '../core/day_overrides.dart';
import '../core/evening_planner.dart';
import '../core/sleep_calculator.dart';
import '../core/sleep_cycles.dart';
import 'database.dart';

class SettingsRepository {
  final AppDatabase db;

  SettingsRepository(this.db);

  Stream<SettingsRow> watch() {
    return (db.select(
      db.settings,
    )..where((t) => t.id.equals(0))).watchSingleOrNull().asyncMap((row) async {
      return row ?? await ensureRowExists();
    });
  }

  Future<SettingsRow> get() async {
    final row = await (db.select(
      db.settings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    return row ?? await ensureRowExists();
  }

  Future<SettingsRow> ensureRowExists() async {
    await db
        .into(db.settings)
        .insert(
          const SettingsCompanion(id: Value(0)),
          mode: InsertMode.insertOrIgnore,
        );
    return await (db.select(
      db.settings,
    )..where((t) => t.id.equals(0))).getSingle();
  }

  Future<void> applyAgeGroupDefaults(AgeGroup group) async {
    await ensureRowExists();
    final target = defaultSleepTarget(isAdult: group == AgeGroup.adult);
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        ageGroup: Value(group),
        targetMinMinutes: Value(target.min),
        targetMaxMinutes: Value(target.max),
      ),
    );
  }

  Future<void> updateTargetHours({int? minMinutes, int? maxMinutes}) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        targetMinMinutes: minMinutes == null
            ? const Value.absent()
            : Value(minMinutes),
        targetMaxMinutes: maxMinutes == null
            ? const Value.absent()
            : Value(maxMinutes),
      ),
    );
  }

  Future<void> updatePrepAndTravel({
    int? prepMinutes,
    int? travelMinutes,
  }) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        prepMinutes: prepMinutes == null
            ? const Value.absent()
            : Value(prepMinutes),
        defaultTravelMinutes: travelMinutes == null
            ? const Value.absent()
            : Value(travelMinutes),
      ),
    );
  }

  Future<void> updateEarliestClass(int? minutes) async {
    await ensureRowExists();
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(earliestClassMinutes: Value(minutes)),
    );
  }

  Future<void> updateCalendarFirstWeekday(int weekday) async {
    await ensureRowExists();
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(calendarFirstWeekday: Value(weekday)),
    );
  }

  Future<void> updateFreeDayWakeMinutes(int minutes) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(freeDayWakeMinutes: Value(minutes)),
    );
  }

  Future<void> updateTermDates({DateTime? start, DateTime? end}) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        termStart: start == null ? const Value.absent() : Value(start),
        termEnd: end == null ? const Value.absent() : Value(end),
      ),
    );
  }

  Future<void> updateNotificationToggles({
    bool? putPhoneDown,
    bool? bedtime,
    bool? busyNight,
    bool? checkIn,
  }) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        notifyPutPhoneDown: putPhoneDown == null
            ? const Value.absent()
            : Value(putPhoneDown),
        notifyBedtime: bedtime == null ? const Value.absent() : Value(bedtime),
        notifyBusyNight: busyNight == null
            ? const Value.absent()
            : Value(busyNight),
        notifyCheckIn: checkIn == null ? const Value.absent() : Value(checkIn),
      ),
    );
  }

  Future<void> updateTaskReminders({
    bool? deadline,
    bool? beforeClass,
    int? beforeClassMinutes,
  }) async {
    await ensureRowExists();
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        notifyDeadline: deadline == null
            ? const Value.absent()
            : Value(deadline),
        notifyBeforeClass: beforeClass == null
            ? const Value.absent()
            : Value(beforeClass),
        beforeClassMinutes: beforeClassMinutes == null
            ? const Value.absent()
            : Value(beforeClassMinutes),
      ),
    );
  }

  Future<void> updateThemeMode(AppThemeMode mode) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(themeMode: Value(mode)),
    );
  }

  /// Travel time for one weekday; null goes back to the usual time.
  Future<void> setTravelOverride(int weekday, int? minutes) {
    return db.transaction(() async {
      final overrides = parseTravelOverrides((await get()).travelOverrides);
      minutes == null
          ? overrides.remove(weekday)
          : overrides[weekday] = minutes;
      await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
        SettingsCompanion(
          travelOverrides: Value(encodeTravelOverrides(overrides)),
        ),
      );
    });
  }

  /// Sleep cycle choices; the length is kept within 70–100 minutes.
  Future<void> updateCycles({bool? align, int? minutes}) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        cycleAlignEnabled: Value.absentIfNull(align),
        cycleMinutes: Value.absentIfNull(
          minutes == null ? null : clampCycleMinutes(minutes),
        ),
      ),
    );
  }

  Future<void> updateRoutineEnabled(bool enabled) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(routineEnabled: Value(enabled)),
    );
  }

  /// A hidden pose is never picked again until unhidden (section 13).
  Future<void> setPoseHidden(String poseId, bool hidden) {
    return db.transaction(() async {
      final ids = hiddenPoseSet(await get());
      hidden ? ids.add(poseId) : ids.remove(poseId);
      await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
        SettingsCompanion(hiddenPoseIds: Value(ids.join(','))),
      );
    });
  }

  Future<void> markVoiceNoticeAccepted() async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      const SettingsCompanion(voiceNoticeAccepted: Value(true)),
    );
  }

  Future<void> markOnboardingCompleted(DateTime now) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        onboardingCompleted: const Value(true),
        onboardedAt: Value(now),
      ),
    );
  }
}

EveningSettings toEveningSettings(SettingsRow row) => EveningSettings(
  restMinutes: row.restMinutes,
  dinnerMinutes: row.dinnerMinutes,
  dinnerStartMinutes: row.dinnerStartMinutes,
  showerMinutes: row.showerMinutes,
  showerOnArrival: row.showerOnArrival,
  maxFocusMinutes: row.maxFocusMinutes,
  breakMinutes: row.breakMinutes,
  bufferBeforeNotifyMinutes: row.bufferBeforeNotifyMinutes,
);

/// Saves any of the evening planner values.
extension EveningSettingsWriter on SettingsRepository {
  Future<void> updateEvening(SettingsCompanion changes) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(changes);
  }
}

Set<String> hiddenPoseSet(SettingsRow row) =>
    row.hiddenPoseIds.split(',').where((id) => id.isNotEmpty).toSet();

SleepSettings toSleepSettings(SettingsRow row) => SleepSettings(
  targetMinMinutes: row.targetMinMinutes,
  targetMaxMinutes: row.targetMaxMinutes,
  prepMinutes: row.prepMinutes,
  travelMinutes: row.defaultTravelMinutes,
  bufferBeforeMinutes: row.bufferBeforeMinutes,
  fallAsleepMinutes: row.fallAsleepMinutes,
  freeDayWakeMinutes: row.freeDayWakeMinutes,
  latestWakeMinutes: row.latestWakeMinutes,
  latestBedtimeMinutes: row.latestBedtimeMinutes,
);
