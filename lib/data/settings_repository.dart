import 'package:drift/drift.dart';

import '../core/sleep_calculator.dart';
import 'database.dart';

/// Default target hours per CLAUDE.md section 3.
const _under18TargetMin = 8 * 60;
const _under18TargetMax = 10 * 60;
const _adultTargetMin = 7 * 60;
const _adultTargetMax = 9 * 60;

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
    final isAdult = group == AgeGroup.adult;
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(
        ageGroup: Value(group),
        targetMinMinutes: Value(isAdult ? _adultTargetMin : _under18TargetMin),
        targetMaxMinutes: Value(isAdult ? _adultTargetMax : _under18TargetMax),
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

  Future<void> updateThemeMode(AppThemeMode mode) async {
    await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
      SettingsCompanion(themeMode: Value(mode)),
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
