import 'package:flutter/foundation.dart';

import '../data/check_in_repository.dart';
import '../data/night_planning_repository.dart';
import 'notification_service_io.dart'
    if (dart.library.js_interop) 'notification_service_web.dart'
    as platform;
import 'permissions_service.dart';

/// Local reminders per CLAUDE.md section 5. Android has real notifications;
/// the web version uses calendar events instead (section 17), so there every
/// call does nothing.
abstract interface class NotificationService {
  /// Set when "เริ่มท่าก่อนนอน" is tapped on a reminder; the Tonight screen
  /// opens the routine and clears it.
  ValueNotifier<bool> get routineRequested;

  Future<void> cancelAll();

  /// Cancels just the bedtime reminder for one night, called when the user
  /// taps "เข้านอนแล้ว" before it would have fired.
  Future<void> cancelBedtimeNotification(DateTime wakeDate);

  /// Cancels the check-in reminder for one night, called once a check-in is
  /// recorded for it (section 5: "ไม่ส่งถ้าเช็กอินแล้ว").
  Future<void> cancelCheckInNotification(DateTime wakeDate);

  /// Clears and re-schedules the next 7 nights' reminders.
  Future<void> rescheduleAll({
    required NightPlanningRepository repo,
    required CheckInRepository checkInRepo,
    required DateTime now,
  });

  /// Section 5: the red-night-ahead alert, once per night.
  Future<void> maybeSendRedNightAheadAlert({
    required NightPlanningRepository repo,
    required bool enabled,
    required DateTime now,
  });

  Future<void> showTestNotification();
}

NotificationService createNotificationService(PermissionsService permissions) =>
    platform.createNotificationService(permissions);
