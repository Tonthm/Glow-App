import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/bed_press.dart';
import '../data/database.dart';
import '../data/night_planning_repository.dart';
import '../data/schedule_repository.dart';
import '../data/settings_repository.dart';

/// "เข้านอนแล้ว" on the bedtime reminder.
const String inBedActionId = 'in_bed';

/// "เริ่มท่าก่อนนอน" on the put-the-phone-down reminder.
const String startRoutineActionId = 'start_routine';

/// Records the press for the night ending on [wakeDate], the same as the
/// button in the app. Returns false if the press window has closed (an old
/// reminder left in the tray) or it was already pressed.
Future<bool> pressInBedFromNotification(
  AppDatabase db,
  DateTime wakeDate,
  DateTime now,
) {
  final planning = NightPlanningRepository(
    db,
    ScheduleRepository(db),
    SettingsRepository(db),
  );
  return db.transaction(() async {
    if ((await planning.getPlanRow(wakeDate))?.inBedAt != null) return false;
    final plan = await planning.currentPlan(wakeDate);
    final allowed = canPressInBed(
      now: now,
      notifyTime: NightPlanningRepository.notifyTimeOf(plan),
      plannedWakeTime: plan.wakeTime,
    );
    if (!allowed) return false;
    await planning.markInBed(wakeDate, now);
    return true;
  });
}

/// Runs in its own isolate when an action is tapped, even with the app
/// closed.
@pragma('vm:entry-point')
Future<void> onBackgroundNotificationAction(
  NotificationResponse response,
) async {
  final wakeDate = DateTime.tryParse(response.payload ?? '');
  if (response.actionId != inBedActionId || wakeDate == null) return;
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final db = AppDatabase();
  try {
    await pressInBedFromNotification(db, wakeDate, DateTime.now());
  } finally {
    await db.close();
  }
}
