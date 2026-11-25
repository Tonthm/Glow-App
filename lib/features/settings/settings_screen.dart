import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/theme_gallery_screen.dart';
import '../shared/minutes_stepper.dart';
import '../shared/time_of_day_field.dart';
import 'setting_row.dart';
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
              const _SectionHeader('การนอน'),
              SettingRow(
                title: 'ช่วงอายุ',
                value: settings.ageGroup == AgeGroup.adult
                    ? '18 ปีขึ้นไป'
                    : 'ต่ำกว่า 18 ปี',
                onTap: () async {
                  final group = await showChoiceSheet<AgeGroup>(
                    context,
                    title: 'ช่วงอายุ (เป้าชั่วโมงจะกลับเป็นค่าแนะนำ)',
                    selected: settings.ageGroup,
                    choices: const {
                      AgeGroup.under18: 'ต่ำกว่า 18 ปี',
                      AgeGroup.adult: '18 ปีขึ้นไป',
                    },
                  );
                  if (group != null && group != settings.ageGroup) {
                    await repo.applyAgeGroupDefaults(group);
                  }
                },
              ),
              _durationRow(
                context,
                title: 'เป้าต่ำสุด',
                minutes: settings.targetMinMinutes,
                step: 15,
                min: 4 * 60,
                max: settings.targetMaxMinutes,
                onSave: (v) => repo.updateTargetHours(minMinutes: v),
              ),
              _durationRow(
                context,
                title: 'เป้าสูงสุด',
                minutes: settings.targetMaxMinutes,
                step: 15,
                min: settings.targetMinMinutes,
                max: 12 * 60,
                onSave: (v) => repo.updateTargetHours(maxMinutes: v),
              ),
              _durationRow(
                context,
                title: 'เวลาเตรียมตัว',
                minutes: settings.prepMinutes,
                step: 5,
                min: 0,
                max: 4 * 60,
                onSave: (v) => repo.updatePrepAndTravel(prepMinutes: v),
              ),
              _durationRow(
                context,
                title: 'เวลาเดินทาง',
                minutes: settings.defaultTravelMinutes,
                step: 5,
                min: 0,
                max: 4 * 60,
                onSave: (v) => repo.updatePrepAndTravel(travelMinutes: v),
              ),
              SettingRow(
                title: 'เวลาตื่นวันว่าง',
                value: formatTimeOfDay(
                  TimeOfDay(
                    hour: settings.freeDayWakeMinutes ~/ 60,
                    minute: settings.freeDayWakeMinutes % 60,
                  ),
                ),
                onTap: () async {
                  final picked = await showTimeWheel(
                    context,
                    title: 'เวลาตื่นวันว่าง',
                    initial: TimeOfDay(
                      hour: settings.freeDayWakeMinutes ~/ 60,
                      minute: settings.freeDayWakeMinutes % 60,
                    ),
                  );
                  if (picked != null) {
                    await repo.updateFreeDayWakeMinutes(
                      picked.hour * 60 + picked.minute,
                    );
                  }
                },
              ),
              const _SectionHeader('การแจ้งเตือน'),
              SwitchListTile(
                title: const Text('เตือนวางมือถือ'),
                value: settings.notifyPutPhoneDown,
                onChanged: (v) =>
                    repo.updateNotificationToggles(putPhoneDown: v),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('เตือนถึงเวลานอน'),
                value: settings.notifyBedtime,
                onChanged: (v) => repo.updateNotificationToggles(bedtime: v),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('เตือนคืนแดงข้างหน้า'),
                value: settings.notifyBusyNight,
                onChanged: (v) => repo.updateNotificationToggles(busyNight: v),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('เตือนเช็กอิน'),
                value: settings.notifyCheckIn,
                onChanged: (v) => repo.updateNotificationToggles(checkIn: v),
              ),
              const Divider(),
              const _ExactAlarmRow(),
              SettingRow(
                title: 'ทดสอบแจ้งเตือน',
                value: 'อีก 1 นาที',
                onTap: () async {
                  await ref
                      .read(notificationServiceProvider)
                      .showTestNotification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ตั้งการแจ้งเตือนทดสอบแล้ว รออีก 1 นาที'),
                      ),
                    );
                  }
                },
              ),
              SettingRow(
                title: 'ปิดการประหยัดแบตให้ Glow',
                onTap: () => showBatteryOptimizationSheet(context),
              ),
              const _SectionHeader('ลักษณะที่ปรากฏ'),
              SettingRow(
                title: 'โหมดสี',
                value: _themeLabels[settings.themeMode]!,
                onTap: () async {
                  final mode = await showChoiceSheet<AppThemeMode>(
                    context,
                    title: 'โหมดสี',
                    selected: settings.themeMode,
                    choices: _themeLabels,
                  );
                  if (mode != null) await repo.updateThemeMode(mode);
                },
              ),
              const _SectionHeader('ข้อมูล'),
              ListTile(
                title: const Text('สำรองข้อมูลเป็นไฟล์'),
                trailing: const Icon(Icons.upload_file_outlined),
                onTap: () async {
                  final ok = await ref
                      .read(backupServiceProvider)
                      .exportToFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok ? 'สำรองข้อมูลแล้ว' : 'ยกเลิกการสำรองข้อมูล',
                        ),
                      ),
                    );
                  }
                },
              ),
              const Divider(),
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
                    final ok = await ref
                        .read(backupServiceProvider)
                        .importFromFile();
                    message = ok ? 'นำเข้าข้อมูลแล้ว' : 'ยกเลิกการนำเข้า';
                  } catch (_) {
                    message = 'อ่านไฟล์นี้ไม่ได้ ข้อมูลเดิมยังอยู่ครบ';
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  }
                },
              ),
              const Divider(),
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
                  await notifications.cancelAll();
                },
              ),
              const _SectionHeader('เกี่ยวกับแอป'),
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
                    MaterialPageRoute(
                      builder: (_) => const ThemeGalleryScreen(),
                    ),
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
                        const SnackBar(
                          content: Text('สร้างข้อมูลตัวอย่างแล้ว'),
                        ),
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

const _themeLabels = {
  AppThemeMode.system: 'ตามระบบ',
  AppThemeMode.light: 'สว่าง',
  AppThemeMode.dark: 'มืด',
};

Widget _durationRow(
  BuildContext context, {
  required String title,
  required int minutes,
  required int step,
  required int min,
  required int max,
  required Future<void> Function(int) onSave,
}) {
  return SettingRow(
    title: title,
    value: formatMinutesAsHours(minutes),
    onTap: () async {
      final picked = await showDurationSheet(
        context,
        title: title,
        initial: minutes,
        step: step,
        min: min,
        max: max,
      );
      if (picked != null) await onSave(picked);
    },
  );
}

/// Shows whether exact alarms are allowed. Without them, section 5 says to
/// tell the user reminders can drift by a few minutes.
class _ExactAlarmRow extends ConsumerStatefulWidget {
  const _ExactAlarmRow();

  @override
  ConsumerState<_ExactAlarmRow> createState() => _ExactAlarmRowState();
}

class _ExactAlarmRowState extends ConsumerState<_ExactAlarmRow> {
  bool? _granted;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _check();
    _lifecycle = AppLifecycleListener(onResume: _check);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final granted = await ref
        .read(permissionsServiceProvider)
        .hasExactAlarmPermission();
    if (mounted) setState(() => _granted = granted);
  }

  @override
  Widget build(BuildContext context) {
    if (_granted != false) return const SizedBox.shrink();
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.schedule_outlined),
          title: const Text('อนุญาตการเตือนตรงเวลา'),
          subtitle: const Text(
            'ตอนนี้ยังไม่ได้อนุญาต แจ้งเตือนอาจคลาดได้หลายนาที',
          ),
          onTap: () async {
            await ref.read(permissionsServiceProvider).requestExactAlarms();
            await _check();
          },
        ),
        const Divider(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
