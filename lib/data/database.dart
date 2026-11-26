import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/card_config.dart';
import '../core/ai_config.dart';

part 'database.g.dart';

enum AgeGroup { under18, adult }

enum WeeklyItemType { classSession, activity }

enum OneTimeItemType { exam, activity, holiday }

enum ItemSource { typed, voice, calendar, ai }

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
  /// The earliest class time given at the start, used only while the
  /// timetable has no classes (core/first_class). Added in schema 17.
  IntColumn get earliestClassMinutes => integer().nullable()();
  /// The first column of the calendar, 7 = Sunday, 1 = Monday. Only how it
  /// is drawn: quests and stats keep Monday. Added in schema 18.
  IntColumn get calendarFirstWeekday =>
      integer().withDefault(const Constant(DateTime.sunday))();
  /// Deadline and before-class reminders, off until asked for. Added in
  /// schema 20.
  BoolColumn get notifyDeadline =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get notifyBeforeClass =>
      boolean().withDefault(const Constant(false))();
  IntColumn get beforeClassMinutes =>
      integer().withDefault(const Constant(15))();
  IntColumn get latestWakeMinutes =>
      integer().withDefault(const Constant(480))();
  IntColumn get latestBedtimeMinutes =>
      integer().withDefault(const Constant(1410))();
  DateTimeColumn get termStart => dateTime().nullable()();
  DateTimeColumn get termEnd => dateTime().nullable()();
  BoolColumn get notifyPutPhoneDown =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notifyBedtime => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyBusyNight =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notifyCheckIn => boolean().withDefault(const Constant(true))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  IntColumn get themeMode =>
      intEnum<AppThemeMode>().withDefault(const Constant(0))();

  /// When onboarding finished. Nights that started before this are never
  /// counted as missed check-ins.
  DateTimeColumn get onboardedAt => dateTime().nullable()();

  /// Travel time that differs by weekday, e.g. "1:60,5:0".
  TextColumn get travelOverrides => text().withDefault(const Constant(''))();
  // Evening planner values (section 14).
  BoolColumn get eveningEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get restMinutes => integer().withDefault(const Constant(30))();
  IntColumn get dinnerMinutes => integer().withDefault(const Constant(45))();
  IntColumn get dinnerStartMinutes =>
      integer().withDefault(const Constant(1110))();
  IntColumn get showerMinutes => integer().withDefault(const Constant(20))();
  BoolColumn get showerOnArrival =>
      boolean().withDefault(const Constant(false))();
  IntColumn get maxFocusMinutes => integer().withDefault(const Constant(50))();
  IntColumn get breakMinutes => integer().withDefault(const Constant(10))();
  IntColumn get bufferBeforeNotifyMinutes =>
      integer().withDefault(const Constant(15))();
  BoolColumn get routineEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Comma-separated pose ids the user doesn't want.
  TextColumn get hiddenPoseIds => text().withDefault(const Constant(''))();

  /// The "your voice may be sent to Google" notice, shown before the first
  /// recording only.
  BoolColumn get voiceNoticeAccepted =>
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

  /// When this night's fire/streak effect (section 7) was applied — from a
  /// real check-in or the no-check-in-past-window sweep — so it's applied
  /// exactly once.
  DateTimeColumn get fireAppliedAt => dateTime().nullable()();

  /// When "เข้านอนแล้ว" was pressed, so the reminders stay cancelled and the
  /// button stays pressed after an app restart.
  DateTimeColumn get inBedAt => dateTime().nullable()();

  /// A night from before "เข้านอนแล้ว" counted for anything: treated as
  /// pressed, so old fire is never held against the user.
  BoolColumn get legacyBedPress =>
      boolean().withDefault(const Constant(false))();

  /// QuestMode index, fixed when the plan locks. Null on older nights.
  IntColumn get questMode => integer().nullable()();

  /// "วันนี้หมดแรง" was chosen for this night.
  BoolColumn get lowEnergy => boolean().withDefault(const Constant(false))();

  /// Prep time shortened for this one morning.
  IntColumn get prepOverrideMinutes => integer().nullable()();

  /// Evening tasks are laid out no earlier than this (after "เสร็จ" or
  /// "จัดใหม่").
  DateTimeColumn get eveningFrom => dateTime().nullable()();

  /// "เริ่มตอนนี้" on a day with no classes.
  DateTimeColumn get eveningStartedAt => dateTime().nullable()();

  /// A shield absorbed this night's miss. Kept on the plan because a missed
  /// night has no check-in row to mark.
  BoolColumn get usedShield => boolean().withDefault(const Constant(false))();

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
  BoolColumn get usedShield => boolean().withDefault(const Constant(false))();
  DateTimeColumn get checkedInAt => dateTime()();

  /// Whether "เข้านอนแล้ว" was pressed. Rows from before this existed count
  /// as pressed.
  BoolColumn get pressedInBed => boolean().withDefault(const Constant(true))();

  /// LightsOffSource index. Null on older rows.
  IntColumn get lightsOffSource => integer().nullable()();

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

/// Single row (id 0): what the student card says and wears. Added in schema
/// 16. Everything stays on the phone.
@DataClassName('CardProfileRow')
class CardProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  TextColumn get school => text().withDefault(const Constant(''))();
  TextColumn get classYear => text().withDefault(const Constant(''))();
  TextColumn get avatarId =>
      text().withDefault(const Constant(defaultAvatarId))();
  TextColumn get logoId => text().withDefault(const Constant(defaultLogoId))();
  TextColumn get frameId =>
      text().withDefault(const Constant(defaultFrameId))();

  /// Comma-separated sticker ids, see core/card_config.dart.
  TextColumn get stickerIds => text().withDefault(const Constant(''))();

  /// Optional. Added in schema 17.
  DateTimeColumn get birthDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single row (id 0): the photo on the card, already cut and compressed.
/// Kept apart from [CardProfiles] so reading the profile never loads it.
/// Added in schema 17. It is never sent anywhere.
@DataClassName('CardPhotoRow')
class CardPhotos extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BlobColumn get jpeg => blob()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A step of a task that the user added to tick off. Parts of a split task
/// are tasks of their own. Added in schema 20.
@DataClassName('TaskStepRow')
class TaskSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer()();
  TextColumn get title => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
}

/// The color the user gave a subject, by name (core/subject_color). Added in
/// schema 19.
@DataClassName('SubjectColorRow')
class SubjectColors extends Table {
  TextColumn get subject => text()();
  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {subject};
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

/// What the user did that day (section 13), keyed by the night's wake date.
class DayActivities extends Table {
  DateTimeColumn get wakeDate => dateTime()();

  /// Comma-separated DayActivityKind names.
  TextColumn get activities => text()();

  /// False when it is only the app's guess.
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {wakeDate};
}

/// One night's stretching routine.
class RoutineLogs extends Table {
  DateTimeColumn get wakeDate => dateTime()();

  /// Comma-separated pose ids.
  TextColumn get poseIds => text()();
  TextColumn get skippedPoseIds => text().withDefault(const Constant(''))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  /// Coins already given, so repeating the routine can't earn them twice.
  IntColumn get coinsAwarded => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {wakeDate};
}

/// One of tonight's tasks (section 14). Postponing moves [planDate].
class EveningTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  /// The estimate for the whole task.
  IntColumn get minutes => integer()();
  IntColumn get doneMinutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueDate => dateTime().nullable()();

  /// EveningTaskKind index.
  IntColumn get kind => integer()();

  /// The exam this revision is for.
  DateTimeColumn get examDate => dateTime().nullable()();

  /// The evening it is to be done.
  DateTimeColumn get planDate => dateTime()();

  /// 0 to do, 1 done, 2 split into parts (hidden; the parts are shown).
  IntColumn get status => integer().withDefault(const Constant(0))();
  IntColumn get userOrder => integer().nullable()();
  BoolColumn get carried => boolean().withDefault(const Constant(false))();
  IntColumn get source =>
      intEnum<ItemSource>().withDefault(const Constant(0))();

  /// Accepted from a study suggestion.
  BoolColumn get suggested => boolean().withDefault(const Constant(false))();

  /// What the AI estimated, kept apart from [minutes], what the user used.
  IntColumn get aiEstimateMinutes => integer().nullable()();

  /// The task this is one part of.
  IntColumn get parentId => integer().nullable()();
}

/// Single-row table (id always 0) for the AI assistant. The API key is never
/// stored here: it is only in secure storage.
@DataClassName('AiSettingsRow')
class AiSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  TextColumn get provider => text().withDefault(const Constant(aiProviderId))();
  TextColumn get model => text().withDefault(const Constant(aiDefaultModel))();

  /// The version of the consent text the user agreed to; 0 for none.
  IntColumn get consentVersion => integer().withDefault(const Constant(0))();

  /// The separate agreement to send pictures. Added in schema 21.
  IntColumn get imageConsentVersion =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get callDay => dateTime().nullable()();
  IntColumn get callCount => integer().withDefault(const Constant(0))();
  IntColumn get dailyQuota =>
      integer().withDefault(const Constant(aiDefaultDailyQuota))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row table (id always 0) for the web version's calendar reminders
/// and backup nudge (CLAUDE.md section 12).
@DataClassName('CalendarReminderRow')
class CalendarReminderStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAddedAt => dateTime().nullable()();

  /// The start of the last reminder added.
  DateTimeColumn get coveredUntil => dateTime().nullable()();

  /// JSON: event id to its last SEQUENCE.
  TextColumn get sequences => text().withDefault(const Constant('{}'))();

  /// JSON: event id to start time, as last added. Shows if the plan moved.
  TextColumn get events => text().withDefault(const Constant('{}'))();
  DateTimeColumn get lastBackupAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
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
    DayActivities,
    RoutineLogs,
    EveningTasks,
    AiSettings,
    CalendarReminderStates,
    CardProfiles,
    CardPhotos,
    SubjectColors,
    TaskSteps,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'glow',
          // Only used on the web; both files are in web/.
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 21;

  /// createTable() builds a table from the *latest* definition, so a column
  /// added in a later version may already be there. A migration that stopped
  /// halfway also leaves columns behind. Both make a plain addColumn throw.
  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo table,
    GeneratedColumn column,
  ) async {
    final columns = await customSelect(
      'PRAGMA table_info(${table.actualTableName})',
    ).get();
    final exists = columns.any((row) => row.data['name'] == column.name);
    if (!exists) await m.addColumn(table, column);
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _addColumnIfMissing(m, nightPlans, nightPlans.redAlertSentAt);
      }
      if (from < 3) {
        await _addColumnIfMissing(m, settings, settings.themeMode);
      }
      if (from < 4) {
        await m.createTable(checkIns);
        await m.createTable(fireStates);
      }
      if (from < 5) {
        await _addColumnIfMissing(m, nightPlans, nightPlans.fireAppliedAt);
      }
      if (from < 6) {
        await _addColumnIfMissing(m, settings, settings.notifyCheckIn);
      }
      if (from < 7) {
        await m.createTable(wallets);
        await m.createTable(ownedItems);
        await m.createTable(weeklyQuestProgresses);
        await m.createTable(examPeriodClaims);
      }
      if (from < 8) {
        await _addColumnIfMissing(
          m,
          fireStates,
          fireStates.lastShieldPurchaseMonday,
        );
      }
      if (from < 9) {
        await _addColumnIfMissing(m, settings, settings.onboardedAt);
        await _addColumnIfMissing(m, nightPlans, nightPlans.inBedAt);
        await _addColumnIfMissing(m, nightPlans, nightPlans.usedShield);
      }
      if (from < 10) {
        await _addColumnIfMissing(m, settings, settings.voiceNoticeAccepted);
      }
      if (from < 11) {
        await m.createTable(dayActivities);
        await m.createTable(routineLogs);
        await _addColumnIfMissing(m, settings, settings.routineEnabled);
        await _addColumnIfMissing(m, settings, settings.hiddenPoseIds);
        await _addColumnIfMissing(m, nightPlans, nightPlans.legacyBedPress);
        await _addColumnIfMissing(m, nightPlans, nightPlans.questMode);
        await _addColumnIfMissing(m, nightPlans, nightPlans.lowEnergy);
        // A check-in table created above already has these columns.
        await _addColumnIfMissing(m, checkIns, checkIns.pressedInBed);
        await _addColumnIfMissing(m, checkIns, checkIns.lightsOffSource);
        // Every night planned before this version counts as pressed, so no
        // fire or quest is judged by a button that didn't matter yet.
        await customStatement('UPDATE night_plans SET legacy_bed_press = 1');
      }
      if (from < 12) {
        await m.createTable(eveningTasks);
        await _addColumnIfMissing(m, settings, settings.eveningEnabled);
        await _addColumnIfMissing(m, settings, settings.restMinutes);
        await _addColumnIfMissing(m, settings, settings.dinnerMinutes);
        await _addColumnIfMissing(m, settings, settings.dinnerStartMinutes);
        await _addColumnIfMissing(m, settings, settings.showerMinutes);
        await _addColumnIfMissing(m, settings, settings.showerOnArrival);
        await _addColumnIfMissing(m, settings, settings.maxFocusMinutes);
        await _addColumnIfMissing(m, settings, settings.breakMinutes);
        await _addColumnIfMissing(
          m,
          settings,
          settings.bufferBeforeNotifyMinutes,
        );
        await _addColumnIfMissing(m, nightPlans, nightPlans.eveningFrom);
        await _addColumnIfMissing(m, nightPlans, nightPlans.eveningStartedAt);
      }
      if (from < 13) {
        await _addColumnIfMissing(m, settings, settings.travelOverrides);
        await _addColumnIfMissing(
          m,
          nightPlans,
          nightPlans.prepOverrideMinutes,
        );
      }
      if (from < 14) {
        await m.createTable(aiSettings);
        await _addColumnIfMissing(
          m,
          eveningTasks,
          eveningTasks.aiEstimateMinutes,
        );
        await _addColumnIfMissing(m, eveningTasks, eveningTasks.parentId);
      }
      if (from < 15) {
        await m.createTable(calendarReminderStates);
      }
      if (from < 16) {
        // Only adds a table: coins, owned colors and the equipped color are
        // left exactly as they were.
        await m.createTable(cardProfiles);
      }
      if (from < 17) {
        await _addColumnIfMissing(m, cardProfiles, cardProfiles.birthDate);
        await _addColumnIfMissing(m, settings, settings.earliestClassMinutes);
        await m.createTable(cardPhotos);
      }
      if (from < 18) {
        await _addColumnIfMissing(m, settings, settings.calendarFirstWeekday);
      }
      if (from < 19) {
        // A new table only: the timetable itself is untouched.
        await m.createTable(subjectColors);
      }
      if (from < 20) {
        await m.createTable(taskSteps);
        await _addColumnIfMissing(m, settings, settings.notifyDeadline);
        await _addColumnIfMissing(m, settings, settings.notifyBeforeClass);
        await _addColumnIfMissing(m, settings, settings.beforeClassMinutes);
      }
      // From 14 on the table exists without this column; older databases get
      // it from createTable above.
      if (from < 21) {
        await _addColumnIfMissing(
          m,
          aiSettings,
          aiSettings.imageConsentVersion,
        );
      }
    },
    // A removed photo or birth date is wiped from the file, not only
    // forgotten.
    beforeOpen: (_) => customStatement('PRAGMA secure_delete = ON'),
  );
}
