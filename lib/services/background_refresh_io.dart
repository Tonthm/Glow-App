import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../data/check_in_repository.dart';
import '../data/database.dart';
import '../data/fire_repository.dart';
import '../data/night_planning_repository.dart';
import '../data/schedule_repository.dart';
import '../data/settings_repository.dart';
import '../data/wallet_repository.dart';
import 'app_clock.dart';
import 'home_widget_service.dart';
import 'notification_service.dart';
import 'permissions_service.dart';

/// Runs without the app open when the phone's clock or timezone changes
/// (see TimeChangeReceiver.kt): reminders are set again for the new local
/// time and the widgets redrawn.
@pragma('vm:entry-point')
Future<void> onBackgroundRefresh(Uri? uri) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  // Demo time travel schedules nothing.
  if (await loadClockOffset() != Duration.zero) return;
  final db = AppDatabase();
  try {
    final settings = SettingsRepository(db);
    final planning = NightPlanningRepository(
      db,
      ScheduleRepository(db),
      settings,
    );
    final now = DateTime.now();
    await createNotificationService(createPermissionsService()).rescheduleAll(
      repo: planning,
      checkInRepo: CheckInRepository(
        db,
        planning,
        FireRepository(db),
        settings,
        WalletRepository(db),
      ),
      now: now,
    );
    await updateHomeWidgets(db, now);
  } finally {
    await db.close();
  }
}

/// Tells Android which function to run for that. Safe to call on every start.
Future<void> registerBackgroundRefresh() async {
  try {
    await HomeWidget.registerInteractivityCallback(onBackgroundRefresh);
  } catch (_) {
    // Not available here; reminders are still reset when the app opens.
  }
}
