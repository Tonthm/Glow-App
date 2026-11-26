import 'dart:typed_data';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'data/card_repository.dart';
import 'data/check_in_repository.dart';
import 'data/database.dart';
import 'data/evening_repository.dart';
import 'data/fire_repository.dart';
import 'data/night_planning_repository.dart';
import 'data/quest_repository.dart';
import 'data/routine_repository.dart';
import 'data/schedule_repository.dart';
import 'data/settings_repository.dart';
import 'data/shop_repository.dart';
import 'data/stats_repository.dart';
import 'data/subject_color_repository.dart';
import 'data/task_list_repository.dart';
import 'data/wallet_repository.dart';
import 'services/backup_service.dart';
import 'services/calendar_import_service.dart';
import 'services/debug_sample_data_service.dart';
import 'services/notification_service.dart';
import 'services/permissions_service.dart';
import 'services/photo_picker.dart';
import 'services/platform/platform_capabilities.dart';
import 'services/screen_service.dart';
import 'services/speech_service.dart';
import 'services/speech_support.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(ref.watch(databaseProvider));
});

final nightPlanningRepositoryProvider = Provider<NightPlanningRepository>((
  ref,
) {
  return NightPlanningRepository(
    ref.watch(databaseProvider),
    ref.watch(scheduleRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
  );
});

final fireRepositoryProvider = Provider<FireRepository>((ref) {
  return FireRepository(ref.watch(databaseProvider));
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(ref.watch(databaseProvider));
});

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(
    ref.watch(databaseProvider),
    ref.watch(nightPlanningRepositoryProvider),
    ref.watch(fireRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(walletRepositoryProvider),
  );
});

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository(
    ref.watch(databaseProvider),
    ref.watch(walletRepositoryProvider),
    ref.watch(scheduleRepositoryProvider),
  );
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(
    ref.watch(databaseProvider),
    ref.watch(walletRepositoryProvider),
  );
});

final eveningRepositoryProvider = Provider<EveningRepository>((ref) {
  return EveningRepository(
    ref.watch(databaseProvider),
    ref.watch(nightPlanningRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
  );
});

final eveningChangesProvider = StreamProvider<void>((ref) {
  final db = ref.watch(databaseProvider);
  return db.tableUpdates(
    TableUpdateQuery.onAllTables([
      db.eveningTasks,
      db.weeklyItems,
      db.oneTimeItems,
      db.settings,
      db.nightPlans,
    ]),
  );
});

/// Task names typed before, newest first, for suggestions.
final taskTitlesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  ref.watch(eveningChangesProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.select(db.eveningTasks).get();
  return <String>{for (final row in rows.reversed) row.title}.toList();
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepository(
    ref.watch(databaseProvider),
    ref.watch(walletRepositoryProvider),
  );
});

final cardProfileStreamProvider = StreamProvider<CardProfileRow>((ref) {
  return ref.watch(cardRepositoryProvider).watch();
});

final taskListRepositoryProvider = Provider<TaskListRepository>((ref) {
  return TaskListRepository(ref.watch(databaseProvider));
});

final taskStepsStreamProvider = StreamProvider<List<TaskStepRow>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.taskSteps).watch();
});

/// Every task, a split one as one entry; null while loading.
final taskEntriesProvider = Provider<List<TaskEntry>?>((ref) {
  final tasks = ref.watch(eveningTasksStreamProvider).value;
  final steps = ref.watch(taskStepsStreamProvider).value;
  return tasks == null || steps == null ? null : taskEntries(tasks, steps);
});

final subjectColorRepositoryProvider = Provider<SubjectColorRepository>((ref) {
  return SubjectColorRepository(ref.watch(databaseProvider));
});

/// Subject colors by subjectKey.
final subjectColorsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(subjectColorRepositoryProvider).watch();
});

final eveningTasksStreamProvider = StreamProvider<List<EveningTask>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.eveningTasks).watch();
});

/// The photo on the card, or null.
final cardPhotoProvider = StreamProvider<Uint8List?>((ref) {
  return ref.watch(cardRepositoryProvider).watchPhoto();
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository(
    ref.watch(walletRepositoryProvider),
    ref.watch(fireRepositoryProvider),
  );
});

final fireStateStreamProvider = StreamProvider<FireStateRow>((ref) {
  return ref.watch(fireRepositoryProvider).watch();
});

final walletStreamProvider = StreamProvider<WalletRow>((ref) {
  return ref.watch(walletRepositoryProvider).watch();
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(databaseProvider));
});

final debugSampleDataServiceProvider = Provider<DebugSampleDataService>((ref) {
  return DebugSampleDataService(ref.watch(databaseProvider));
});

/// Emits whenever a night's check-in or plan changes, so screens that read
/// history (stats, room) know to reload.
final nightHistoryChangesProvider = StreamProvider<void>((ref) {
  final db = ref.watch(databaseProvider);
  return db.tableUpdates(
    TableUpdateQuery.onAllTables([db.checkIns, db.nightPlans]),
  );
});

final settingsStreamProvider = StreamProvider<SettingsRow>((ref) {
  return ref.watch(settingsRepositoryProvider).watch();
});

final weeklyItemsStreamProvider = StreamProvider<List<WeeklyItem>>((ref) {
  return ref.watch(scheduleRepositoryProvider).watchWeeklyItems();
});

final oneTimeItemsStreamProvider = StreamProvider<List<OneTimeItem>>((ref) {
  return ref.watch(scheduleRepositoryProvider).watchOneTimeItems();
});

final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return createPermissionsService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return createNotificationService(ref.watch(permissionsServiceProvider));
});

/// Overridable, so tests can show the web version's screens.
final platformCapabilitiesProvider = Provider<PlatformCapabilities>((ref) {
  return PlatformCapabilities.current;
});

final photoPickerProvider = Provider<PhotoPicker>((ref) {
  return DevicePhotoPicker();
});

final screenServiceProvider = Provider<ScreenService>((ref) {
  return ScreenService();
});

/// Whether this browser or phone has a speech recogniser at all.
final deviceHasSpeechProvider = Provider<bool>((ref) => deviceHasSpeech());

/// Set once the mic has shown it cannot work here.
final micBrokenProvider = StateProvider<bool>((ref) => false);

/// Whether to show a mic button: never one that is known not to work.
final micAvailableProvider = Provider<bool>(
  (ref) =>
      ref.watch(platformCapabilitiesProvider).voiceInput &&
      ref.watch(deviceHasSpeechProvider) &&
      !ref.watch(micBrokenProvider),
);

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechService();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

final calendarImportServiceProvider = Provider<CalendarImportService>((ref) {
  return CalendarImportService(ref.watch(scheduleRepositoryProvider));
});

/// Which bottom-nav tab is showing, so e.g. the empty-schedule prompt on the
/// Tonight tab can jump straight to the Schedule tab.
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
