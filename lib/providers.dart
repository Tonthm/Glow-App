import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'data/check_in_repository.dart';
import 'data/database.dart';
import 'data/fire_repository.dart';
import 'data/night_planning_repository.dart';
import 'data/quest_repository.dart';
import 'data/routine_repository.dart';
import 'data/schedule_repository.dart';
import 'data/settings_repository.dart';
import 'data/shop_repository.dart';
import 'data/stats_repository.dart';
import 'data/wallet_repository.dart';
import 'services/backup_service.dart';
import 'services/calendar_import_service.dart';
import 'services/debug_sample_data_service.dart';
import 'services/notification_service.dart';
import 'services/permissions_service.dart';
import 'services/speech_service.dart';

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
  return PermissionsService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(permissionsServiceProvider));
});

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
