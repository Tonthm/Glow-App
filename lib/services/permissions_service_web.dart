import 'permissions_service.dart';

PermissionsService createPermissionsService() => _NoPermissionsService();

/// The web version asks for none of these. "Granted" keeps the warnings about
/// them from showing.
class _NoPermissionsService implements PermissionsService {
  @override
  Future<bool> requestNotifications() async => true;

  @override
  Future<bool> hasNotificationsPermission() async => true;

  @override
  Future<bool> requestExactAlarms() async => true;

  @override
  Future<bool> hasExactAlarmPermission() async => true;

  @override
  Future<void> openSystemAppSettings() async {}
}
