import 'package:permission_handler/permission_handler.dart';

/// Thin wrapper around permission_handler for the permissions Glow needs.
/// Never requests battery-optimization exemption via a popup (Play policy +
/// CLAUDE.md section 5) — that one is always a manual trip to system
/// Settings, guided by [BatteryOptimizationGuide].
class PermissionsService {
  Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> hasNotificationsPermission() async {
    return Permission.notification.isGranted;
  }

  /// Android 12+: exact alarms. If denied, callers should fall back to
  /// inexact scheduling and warn the user it may drift by a few minutes.
  Future<bool> requestExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.request();
    return status.isGranted;
  }

  Future<bool> hasExactAlarmPermission() async {
    return Permission.scheduleExactAlarm.isGranted;
  }

  Future<void> openSystemAppSettings() => openAppSettings();
}

enum PhoneBrand { xiaomi, oppo, vivo, samsung, other }

/// Static per-brand guidance for disabling battery optimization, shown at
/// onboarding and in settings. CLAUDE.md section 5 forbids requesting the
/// ignoreBatteryOptimizations popup — this is manual guidance only.
class BatteryOptimizationGuide {
  static const Map<PhoneBrand, String> steps = {
    PhoneBrand.xiaomi:
        'ตั้งค่า > แอป > จัดการแอป > Glow > ประหยัดแบตเตอรี่ > เลือก "ไม่จำกัด" '
        'แล้วไปที่ตั้งค่า > แอปที่เริ่มทำงานอัตโนมัติ > เปิดให้ Glow เริ่มทำงานอัตโนมัติ',
    PhoneBrand.oppo:
        'ตั้งค่า > แบตเตอรี่ > การใช้พลังงานของแอป > Glow > เลือก "อนุญาต" '
        'การทำงานในพื้นหลัง และปิดการเพิ่มประสิทธิภาพแบตเตอรี่สำหรับแอปนี้',
    PhoneBrand.vivo:
        'ตั้งค่า > แบตเตอรี่ > การใช้พลังงานสูง > Glow > ปิดการจำกัดพื้นหลัง '
        'และเปิดอนุญาตให้ทำงานในพื้นหลังเสมอ (High background power consumption)',
    PhoneBrand.samsung:
        'ตั้งค่า > การดูแลอุปกรณ์ > แบตเตอรี่ > การใช้พลังงานพื้นหลัง > Glow '
        '> เลือก "ไม่มีการจำกัด" (unrestricted)',
    PhoneBrand.other:
        'มองหาหัวข้อ "ประหยัดแบตเตอรี่" หรือ "Battery optimization" ในตั้งค่าเครื่อง '
        'แล้วเลือกยกเว้นแอป Glow ไม่ให้ถูกจำกัดการทำงานพื้นหลัง',
  };

  static const Map<PhoneBrand, String> labels = {
    PhoneBrand.xiaomi: 'Xiaomi / Redmi / POCO',
    PhoneBrand.oppo: 'Oppo',
    PhoneBrand.vivo: 'Vivo',
    PhoneBrand.samsung: 'Samsung',
    PhoneBrand.other: 'ยี่ห้ออื่น',
  };
}
