import 'package:permission_handler/permission_handler.dart';

import 'permissions_service.dart';

PermissionsService createPermissionsService() => _AndroidPermissionsService();

class _AndroidPermissionsService implements PermissionsService {
  @override
  Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Future<bool> hasNotificationsPermission() async {
    return Permission.notification.isGranted;
  }

  @override
  Future<bool> requestExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.request();
    return status.isGranted;
  }

  @override
  Future<bool> hasExactAlarmPermission() async {
    return Permission.scheduleExactAlarm.isGranted;
  }

  @override
  Future<void> openSystemAppSettings() => openAppSettings();
}
