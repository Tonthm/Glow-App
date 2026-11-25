import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

enum AgeGroup { under18, adult }

enum WeeklyItemType { classSession, activity }

enum OneTimeItemType { exam, activity, holiday }

enum ItemSource { typed, voice, calendar }

enum AppThemeMode { system, light, dark }

enum CheckInResultDb { enough, almostEnough, notEnough, over }

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
  BoolColumn get notifyCheckIn =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  IntColumn get themeMode =>
      intEnum<AppThemeMode>().withDefault(const Constant(0))();

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
  /// When this night's fire/streak effect (section 7) was applied — from a
  /// real check-in or the no-check-in-past-window sweep — so it's applied
  /// exactly once.
  DateTimeColumn get fireAppliedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {wakeDate},
  ];
}

/// One check-in per wake date, per CLAUDE.md section 6.
@DataClassName('CheckInRow')
class CheckIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get wakeDate => dateTime()();
  DateTimeColumn get lightsOffAt => dateTime()();
  DateTimeColumn get actualWakeAt => dateTime()();
  IntColumn get result => intEnum<CheckInResultDb>()();
  BoolColumn get onTime => boolean()();
  BoolColumn get usedShield =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get checkedInAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {wakeDate},
  ];
}

/// Single-row table (id always 0) holding the fire/streak/shield state from
/// CLAUDE.md section 7.
@DataClassName('FireStateRow')
class FireStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get points => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(0))();
  IntColumn get shields => integer().withDefault(const Constant(0))();
  IntColumn get maxLevelEverReached =>
      integer().withDefault(const Constant(0))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  /// Monday (date-only) the free weekly shield was last granted, so it's
  /// only granted once per week (section 7: "ได้ฟรี 1 อันทุกวันจันทร์").
  DateTimeColumn get lastFreeShieldMonday => dateTime().nullable()();
  /// Monday (date-only) a shield was last bought with coins, so the shop
  /// enforces "ซื้อเพิ่มด้วยเหรียญได้ 1 อันต่อสัปดาห์" (section 7).
  DateTimeColumn get lastShieldPurchaseMonday => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row table (id always 0) holding coins and the equipped blanket,
/// per CLAUDE.md section 12.
@DataClassName('WalletRow')
class Wallets extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  TextColumn get equippedBlanketId =>
      text().withDefault(const Constant('default'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per shop/reward item the player owns (section 9 blankets, plus
/// the non-sellable fire-level and exam-period reward blankets).
class OwnedItems extends Table {
  TextColumn get itemId => text()();
  DateTimeColumn get acquiredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {itemId};
}

/// Tracks the weekly "ตรงเวลา 5 ใน 7" quest so its 50-coin reward is
/// claimed at most once per week (section 8).
class WeeklyQuestProgresses extends Table {
  DateTimeColumn get weekStart => dateTime()();
  BoolColumn get rewardClaimed =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {weekStart};
}

/// Tracks the exam-period "ครบทุกคืนก่อนสอบ" reward so it's claimed at most
/// once per exam period, identified by that period's first exam date
/// (section 8) — independent of calendar weeks since a period can cross
/// one.
class ExamPeriodClaims extends Table {
  DateTimeColumn get periodStartDate => dateTime()();

  @override
  Set<Column> get primaryKey => {periodStartDate};
}

@DriftDatabase(
  tables: [
    Settings,
    WeeklyItems,
    OneTimeItems,
    NightPlans,
    CheckIns,
    FireStates,
    Wallets,
    OwnedItems,
    WeeklyQuestProgresses,
    ExamPeriodClaims,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'glow'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(nightPlans, nightPlans.redAlertSentAt);
      }
      if (from < 3) {
        await m.addColumn(settings, settings.themeMode);
      }
      if (from < 4) {
        await m.createTable(checkIns);
        await m.createTable(fireStates);
      }
      if (from < 5) {
        await m.addColumn(nightPlans, nightPlans.fireAppliedAt);
      }
      if (from < 6) {
        await m.addColumn(settings, settings.notifyCheckIn);
      }
      if (from < 7) {
        await m.createTable(wallets);
        await m.createTable(ownedItems);
        await m.createTable(weeklyQuestProgresses);
        await m.createTable(examPeriodClaims);
      }
      if (from < 8) {
        await m.addColumn(fireStates, fireStates.lastShieldPurchaseMonday);
      }
    },
  );
}
