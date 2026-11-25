import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/theme_gallery_screen.dart';
import '../shared/minutes_stepper.dart';
import 'battery_optimization_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ตั้งค่า')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
        data: (settings) {
          final repo = ref.read(settingsRepositoryProvider);
          return ListView(
            children: [
              const _SectionHeader('เป้าชั่วโมงนอน'),
              MinutesStepper(
                label: 'ต่ำสุด',
                minutes: settings.targetMinMinutes,
                step: 15,
                onChanged: (v) => repo.updateTargetHours(minMinutes: v),
              ),
              MinutesStepper(
                label: 'สูงสุด',
                minutes: settings.targetMaxMinutes,
                step: 15,
                onChanged: (v) => repo.updateTargetHours(maxMinutes: v),
              ),
              const _SectionHeader('เวลาเตรียมตัวและเดินทาง'),
              MinutesStepper(
                label: 'เวลาเตรียมตัว',
                minutes: settings.prepMinutes,
                step: 5,
                onChanged: (v) => repo.updatePrepAndTravel(prepMinutes: v),
              ),
              MinutesStepper(
                label: 'เวลาเดินทาง',
                minutes: settings.defaultTravelMinutes,
                step: 5,
                onChanged: (v) => repo.updatePrepAndTravel(travelMinutes: v),
              ),
              const _SectionHeader('การแจ้งเตือน'),
              SwitchListTile(
                title: const Text('เตือนวางมือถือ'),
                value: settings.notifyPutPhoneDown,
                onChanged: (v) => repo.updateNotificationToggles(putPhoneDown: v),
              ),
              SwitchListTile(
                title: const Text('เตือนถึงเวลานอน'),
                value: settings.notifyBedtime,
                onChanged: (v) => repo.updateNotificationToggles(bedtime: v),
              ),
              SwitchListTile(
                title: const Text('เตือนคืนแดงข้างหน้า'),
                value: settings.notifyBusyNight,
                onChanged: (v) => repo.updateNotificationToggles(busyNight: v),
              ),
              SwitchListTile(
                title: const Text('เตือนเช็กอิน'),
                value: settings.notifyCheckIn,
                onChanged: (v) => repo.updateNotificationToggles(checkIn: v),
              ),
              ListTile(
                title: const Text('ทดสอบแจ้งเตือน'),
                subtitle: const Text('ตั้งเตือนในอีก 1 นาที'),
                trailing: const Icon(Icons.notifications_active_outlined),
                onTap: () async {
                  await ref.read(notificationServiceProvider).showTestNotification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ตั้งการแจ้งเตือนทดสอบแล้ว รออีก 1 นาที')),
                    );
                  }
                },
              ),
              ListTile(
                title: const Text('ปิดการประหยัดแบตให้ Glow'),
                trailing: const Icon(Icons.battery_charging_full_outlined),
                onTap: () => showBatteryOptimizationSheet(context),
              ),
              const _SectionHeader('ลักษณะที่ปรากฏ'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<AppThemeMode>(
                  segments: const [
                    ButtonSegment(value: AppThemeMode.system, label: Text('ตามระบบ')),
                    ButtonSegment(value: AppThemeMode.light, label: Text('สว่าง')),
                    ButtonSegment(value: AppThemeMode.dark, label: Text('มืด')),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selection) =>
                      repo.updateThemeMode(selection.first),
                ),
              ),
              const _SectionHeader('ข้อมูล'),
              ListTile(
                title: const Text('สำรองข้อมูลเป็นไฟล์'),
                trailing: const Icon(Icons.upload_file_outlined),
                onTap: () async {
                  final ok = await ref.read(backupServiceProvider).exportToFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ok ? 'สำรองข้อมูลแล้ว' : 'ยกเลิกการสำรองข้อมูล')),
                    );
                  }
                },
              ),
              ListTile(
                title: const Text('นำเข้าข้อมูลจากไฟล์สำรอง'),
                trailing: const Icon(Icons.download_outlined),
                onTap: () async {
                  final confirmed = await _confirm(
                    context,
                    title: 'นำเข้าข้อมูล',
                    message: 'ข้อมูลปัจจุบันทั้งหมดจะถูกแทนที่ด้วยไฟล์ที่เลือก ต้องการดำเนินการต่อไหม',
                  );
                  if (!confirmed || !context.mounted) return;
                  String message;
                  try {
                    final ok = await ref.read(backupServiceProvider).importFromFile();
                    message = ok ? 'นำเข้าข้อมูลแล้ว' : 'ยกเลิกการนำเข้า';
                  } catch (_) {
                    message = 'อ่านไฟล์นี้ไม่ได้ ข้อมูลเดิมยังอยู่ครบ';
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                },
              ),
              ListTile(
                title: Text(
                  'ลบข้อมูลทั้งหมด',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                trailing: Icon(
                  Icons.delete_forever_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                onTap: () async {
                  final confirmed = await _confirm(
                    context,
                    title: 'ลบข้อมูลทั้งหมด',
                    message: 'ข้อมูลทุกอย่างในแอปจะถูกลบและไม่สามารถกู้คืนได้ ต้องการดำเนินการต่อไหม',
                  );
                  if (!confirmed || !context.mounted) return;
                  final notifications = ref.read(notificationServiceProvider);
                  final backup = ref.read(backupServiceProvider);
                  // Back to the first screen, which becomes onboarding again.
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  await backup.deleteAllData();
                  await notifications.init();
                  await notifications.cancelAll();
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'แอปนี้ไม่ใช่คำแนะนำทางการแพทย์ ถ้านอนไม่หลับหรือง่วงมากต่อเนื่อง'
                  'หลายสัปดาห์ ควรปรึกษาแพทย์',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (kDebugMode) ...[
                const _SectionHeader('Debug'),
                ListTile(
                  title: const Text('Theme gallery'),
                  trailing: const Icon(Icons.palette_outlined),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ThemeGalleryScreen()),
                  ),
                ),
                ListTile(
                  title: const Text('สร้างข้อมูลตัวอย่าง 60 คืน'),
                  subtitle: const Text('สำหรับทดสอบ heatmap เท่านั้น'),
                  trailing: const Icon(Icons.dataset_outlined),
                  onTap: () async {
                    await ref
                        .read(debugSampleDataServiceProvider)
                        .generateSampleNights(DateTime.now());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('สร้างข้อมูลตัวอย่างแล้ว')),
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
