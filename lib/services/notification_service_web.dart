import 'package:flutter/foundation.dart';

import '../data/check_in_repository.dart';
import '../data/night_planning_repository.dart';
import 'notification_service.dart';
import 'permissions_service.dart';

NotificationService createNotificationService(PermissionsService permissions) =>
    _NoNotificationService();

/// The web version reminds through the calendar instead.
class _NoNotificationService implements NotificationService {
  @override
  final ValueNotifier<bool> routineRequested = ValueNotifier(false);

  @override
  Future<void> cancelAll() async {}

  @override
  Future<void> cancelBedtimeNotification(DateTime wakeDate) async {}

  @override
  Future<void> cancelCheckInNotification(DateTime wakeDate) async {}

  @override
  Future<void> rescheduleAll({
    required NightPlanningRepository repo,
    required CheckInRepository checkInRepo,
    required DateTime now,
  }) async {}

  @override
  Future<void> maybeSendRedNightAheadAlert({
    required NightPlanningRepository repo,
    required bool enabled,
    required DateTime now,
  }) async {}

  @override
  Future<void> showTestNotification() async {}
}
