import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

enum AgeGroup { under18, adult }

enum WeeklyItemType { classSession, activity }

enum OneTimeItemType { exam, activity, holiday }

enum ItemSource { typed, voice, calendar }

/// Single-row table (id is always 0) holding all user-tunable values from
/// CLAUDE.md section 3. Only target hours, prep/travel time, and free-day
/// wake time have dedicated UI in phase 1 — the rest keep their spec
/// defaults until a later settings screen exposes them.
@DataClassName('SettingsRow')
class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get ageGroup =>
      intEnum<AgeGroup>().withDefault(const Constant(0))();
  IntColumn get targetMinMinutes =>
      integer().withDefault(const Constant(480))();
  IntColumn get targetMaxMinutes =>
      integer().withDefault(const Constant(600))();
  IntColumn get prepMinutes => integer().withDefault(const Constant(45))();
  IntColumn get defaultTravelMinutes =>
      integer().withDefault(const Constant(30))();
  IntColumn get bufferBeforeMinutes =>
      integer().withDefault(const Constant(10))();
  IntColumn get fallAsleepMinutes =>
      integer().withDefault(const Constant(15))();
  IntColumn get freeDayWakeMinutes =>
      integer().withDefault(const Constant(450))();
  IntColumn get latestWakeMinutes =>
      integer().withDefault(const Constant(480))();
  IntColumn get latestBedtimeMinutes =>
      integer().withDefault(const Constant(1410))();
  DateTimeColumn get termStart => dateTime().nullable()();
  DateTimeColumn get termEnd => dateTime().nullable()();
  BoolColumn get notifyPutPhoneDown =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notifyBedtime =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notifyBusyNight =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Recurring item within the term, per CLAUDE.md section 2.
class WeeklyItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  /// 1 = Monday .. 7 = Sunday.
  IntColumn get dayOfWeek => integer()();
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  IntColumn get type => intEnum<WeeklyItemType>()();
  IntColumn get source =>
      intEnum<ItemSource>().withDefault(const Constant(0))();
  TextColumn get calendarEventId => text().nullable()();
}

/// One-off exam / activity / holiday item, per CLAUDE.md section 2.
/// Holidays may omit start/end since they only cancel that day's classes.
class OneTimeItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get startMinutes => integer().nullable()();
  IntColumn get endMinutes => integer().nullable()();
  IntColumn get type => intEnum<OneTimeItemType>()();
  IntColumn get source =>
      intEnum<ItemSource>().withDefault(const Constant(0))();
  TextColumn get calendarEventId => text().nullable()();
}

/// One locked plan per wake date, per CLAUDE.md section 3 step 8.
class NightPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get wakeDate => dateTime()();
  DateTimeColumn get plannedWakeAt => dateTime()();
  DateTimeColumn get plannedBedtimeAt => dateTime()();
  BoolColumn get isRedNight => boolean().withDefault(const Constant(false))();
  BoolColumn get isYellowNight =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isPreExamNight =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lockedAt => dateTime().nullable()();
  /// When the once-per-night "คืนแดงข้างหน้า" alert was shown, so it isn't
  /// repeated (CLAUDE.md section 5).
  DateTimeColumn get redAlertSentAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {wakeDate},
  ];
}

@DriftDatabase(tables: [Settings, WeeklyItems, OneTimeItems, NightPlans])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'glow'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(nightPlans, nightPlans.redAlertSentAt);
      }
    },
  );
}
