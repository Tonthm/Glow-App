import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'data/check_in_repository.dart';
import 'data/database.dart';
import 'data/fire_repository.dart';
import 'data/night_planning_repository.dart';
import 'data/schedule_repository.dart';
import 'data/settings_repository.dart';
import 'services/backup_service.dart';
import 'services/calendar_import_service.dart';
import 'services/notification_service.dart';
import 'services/permissions_service.dart';

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

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(
    ref.watch(databaseProvider),
    ref.watch(nightPlanningRepositoryProvider),
    ref.watch(fireRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
  );
});

final fireStateStreamProvider = StreamProvider<FireStateRow>((ref) {
  return ref.watch(fireRepositoryProvider).watch();
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

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

final calendarImportServiceProvider = Provider<CalendarImportService>((ref) {
  return CalendarImportService(ref.watch(scheduleRepositoryProvider));
});

/// Which bottom-nav tab is showing, so e.g. the empty-schedule prompt on the
/// Tonight tab can jump straight to the Schedule tab.
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
