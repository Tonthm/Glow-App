import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/birth_date.dart';
import '../../core/day_overrides.dart';
import '../../core/sleep_cycles.dart';
import '../../core/task_reminders.dart';
import '../../data/database.dart';
import '../../data/settings_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../ai/ai_providers.dart';
import '../ai/ai_settings_screen.dart';
import '../card/card_details_sheet.dart';
import '../web/web_reminder_bars.dart';
import '../demo/demo_button.dart';
import '../../theme/theme_gallery_screen.dart';
import '../../theme/tokens.dart';
import '../../theme/glow_colors.dart';
import '../shared/minutes_stepper.dart';
import '../shared/time_of_day_field.dart';
import 'evening_settings_rows.dart';
import 'hidden_poses_sheet.dart';
import 'setting_row.dart';
import 'travel_by_day_sheet.dart';
import 'battery_optimization_sheet.dart';
import 'data_settings.dart';

/// The few settings most people need. Everything else is one tap further
/// (CLAUDE.md section 1).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = ref.watch(platformCapabilitiesProvider);
    return _SettingsPage(
      title: 'ตั้งค่า',
      rows: (context, settings) {
        final repo = ref.read(settingsRepositoryProvider);
        return [
          // No more than five here.
          SettingRow(
            title: 'โปรไฟล์และบัตร',
            icon: Icons.badge_outlined,
            onTap: () => showCardDetailsSheet(context),
          ),
          _durationRow(
            context,
            title: 'เวลาเดินทาง',
            icon: Icons.schedule_outlined,
            minutes: settings.defaultTravelMinutes,
            step: 5,
            min: 0,
            max: 4 * 60,
            onSave: (v) => repo.updatePrepAndTravel(travelMinutes: v),
          ),
          _durationRow(
            context,
            title: 'เวลาเตรียมตัว',
            icon: Icons.timelapse_outlined,
            minutes: settings.prepMinutes,
            step: 5,
            min: 0,
            max: 4 * 60,
            onSave: (v) => repo.updatePrepAndTravel(prepMinutes: v),
          ),
          SettingRow(
            icon: Icons.calendar_today_outlined,
            title: platform.calendarReminders
                ? 'เตือนในปฏิทิน'
                : 'การแจ้งเตือน',
            onTap: () => _open(context, const NotificationSettingsScreen()),
          ),
          SettingRow(
            title: 'โหมดสี',
            icon: Icons.nightlight_outlined,
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
          const SizedBox(height: 16),
          ListTile(
            tileColor: context.glowColors.pastel(GlowPastel.lilac),
            leading: const Icon(Icons.tune),
            title: const Text('ตั้งค่าขั้นสูง'),
            subtitle: const Text(
              'การนอนแบบละเอียด ตารางเย็น ผู้ช่วย AI สำรองข้อมูล และอื่น ๆ',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const AdvancedSettingsScreen()),
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
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Glow',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Fredoka',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ];
      },
    );
  }
}

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = ref.watch(platformCapabilitiesProvider);
    return _SettingsPage(
      title: platform.calendarReminders ? 'เตือนในปฏิทิน' : 'การแจ้งเตือน',
      rows: (context, settings) {
        final repo = ref.read(settingsRepositoryProvider);
        return [
          SwitchListTile(
            title: const Text('เตือนวางมือถือ'),
            value: settings.notifyPutPhoneDown,
            onChanged: (v) => repo.updateNotificationToggles(putPhoneDown: v),
          ),
          const SizedBox(height: GlowSpacing.sm),
          SwitchListTile(
            title: const Text('เตือนถึงเวลานอน'),
            value: settings.notifyBedtime,
            onChanged: (v) => repo.updateNotificationToggles(bedtime: v),
          ),
          const SizedBox(height: GlowSpacing.sm),
          SwitchListTile(
            title: const Text('เตือนคืนแดงข้างหน้า'),
            value: settings.notifyBusyNight,
            onChanged: (v) => repo.updateNotificationToggles(busyNight: v),
          ),
          const SizedBox(height: GlowSpacing.sm),
          SwitchListTile(
            title: const Text('เตือนเช็กอิน'),
            value: settings.notifyCheckIn,
            onChanged: (v) => repo.updateNotificationToggles(checkIn: v),
          ),
          const SizedBox(height: GlowSpacing.sm),
          SwitchListTile(
            title: const Text('เตือนเดดไลน์'),
            subtitle: const Text('เย็นก่อนวันส่ง ไม่เลยเวลาเข้านอน'),
            value: settings.notifyDeadline,
            onChanged: (v) => repo.updateTaskReminders(deadline: v),
          ),
          const SizedBox(height: GlowSpacing.sm),
          SwitchListTile(
            title: const Text('เตือนก่อนคาบเรียน'),
            subtitle: const Text('ไม่ปลุกตอนนอน'),
            value: settings.notifyBeforeClass,
            onChanged: (v) => repo.updateTaskReminders(beforeClass: v),
          ),
          if (settings.notifyBeforeClass)
            const SizedBox(height: GlowSpacing.sm),
          if (settings.notifyBeforeClass)
            SettingRow(
              title: 'เตือนก่อนคาบกี่นาที',
              value: '${settings.beforeClassMinutes} นาที',
              onTap: () async {
                final minutes = await showChoiceSheet<int>(
                  context,
                  title: 'เตือนก่อนคาบ',
                  selected: settings.beforeClassMinutes,
                  choices: {for (final m in beforeClassChoices) m: '$m นาที'},
                );
                if (minutes != null) {
                  await repo.updateTaskReminders(beforeClassMinutes: minutes);
                }
              },
            ),
          const SizedBox(height: GlowSpacing.sm),
          if (platform.calendarReminders)
            SettingRow(
              title: 'เพิ่มเตือนลงปฏิทิน (7 วัน)',
              onTap: () => addCalendarReminders(context, ref),
            ),
          if (platform.deviceSetupHelp) const _ExactAlarmRow(),
          if (platform.localNotifications)
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
          if (platform.deviceSetupHelp)
            SettingRow(
              title: 'ปิดการประหยัดแบตให้ Glow',
              onTap: () => showBatteryOptimizationSheet(context),
            ),
          const SizedBox(height: 24),
        ];
      },
    );
  }
}

class AdvancedSettingsScreen extends ConsumerWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = ref.watch(platformCapabilitiesProvider);
    final birthDate = ref.watch(cardProfileStreamProvider).value?.birthDate;
    // Nothing about AI shows to someone whose birth date is under 18.
    final showAi =
        platform.aiAssistant &&
        switch (ref.watch(aiAgeProvider).value) {
          null || AiAgeState.hidden => false,
          _ => true,
        };
    final aiOn = ref.watch(aiSettingsProvider).value?.enabled == true;
    return _SettingsPage(
      title: 'ตั้งค่าขั้นสูง',
      rows: (context, settings) {
        final repo = ref.read(settingsRepositoryProvider);
        final isAdult = birthDate == null
            ? settings.ageGroup == AgeGroup.adult
            : isAdultOn(birthDate, DateTime.now());
        return [
          const _SectionHeader('การนอน'),
          SettingRow(
            title: 'ช่วงอายุ',
            value:
                (isAdult ? '18 ปีขึ้นไป' : 'ต่ำกว่า 18 ปี') +
                (birthDate == null ? '' : ' (จากวันเกิด)'),
            onTap: () async {
              // A birth date decides the age; change it there.
              if (birthDate != null) {
                await showCardDetailsSheet(context);
                return;
              }
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
          SettingRow(
            title: 'เรียนเช้าสุด (ตอนยังไม่มีตาราง)',
            value: settings.earliestClassMinutes == null
                ? 'ไม่ได้ใส่'
                : formatTimeOfDay(_timeOf(settings.earliestClassMinutes!)),
            onTap: () async {
              final picked = await showTimeWheel(
                context,
                title: 'เรียนเช้าสุดกี่โมง',
                initial: _timeOf(settings.earliestClassMinutes ?? 8 * 60),
              );
              if (picked != null) {
                await repo.updateEarliestClass(
                  picked.hour * 60 + picked.minute,
                );
              }
            },
          ),
          SettingRow(
            title: 'เวลาเดินทางแยกรายวัน',
            value: switch (parseTravelOverrides(settings.travelOverrides)
                .length) {
              0 => 'ไม่มี',
              final n => '$n วัน',
            },
            onTap: () => showTravelByDaySheet(context),
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
          const SizedBox(height: GlowSpacing.sm),
          SwitchListTile(
            title: const Text('จัดเวลานอนให้ครบรอบ'),
            subtitle: const Text(
              'เข้านอนเร็วขึ้นได้ ไม่ช้าลง และไม่เกินเป้าสูงสุด (ค่าประมาณ)',
            ),
            value: settings.cycleAlignEnabled,
            onChanged: (v) => repo.updateCycles(align: v),
          ),
          const SizedBox(height: GlowSpacing.sm),
          SettingRow(
            title: 'ความยาวรอบการนอน (ประมาณ)',
            value: '${settings.cycleMinutes} นาที',
            onTap: () async {
              final minutes = await showDurationSheet(
                context,
                title: 'ความยาวรอบการนอน ต่างกันตามคนและวัย',
                initial: settings.cycleMinutes,
                step: 5,
                min: minCycleMinutes,
                max: maxCycleMinutes,
              );
              if (minutes != null) await repo.updateCycles(minutes: minutes);
            },
          ),
          const _SectionHeader('ท่าก่อนนอน'),
          SwitchListTile(
            title: const Text('ท่าก่อนนอน'),
            subtitle: const Text('ปิดแล้วการ์ดกิจกรรมและเควสท่าจะหายไป'),
            value: settings.routineEnabled,
            onChanged: repo.updateRoutineEnabled,
          ),
          const SizedBox(height: GlowSpacing.sm),
          SettingRow(
            title: 'ท่าที่ซ่อนไว้',
            value: '${hiddenPoseSet(settings).length} ท่า',
            onTap: () => showHiddenPosesSheet(context),
          ),
          const _SectionHeader('ตารางเย็น'),
          EveningSettingsRows(settings: settings),
          if (showAi) const _SectionHeader('ผู้ช่วย AI'),
          if (showAi)
            SettingRow(
              title: 'ผู้ช่วย AI',
              value: aiOn ? 'เปิด' : 'ปิด',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AiSettingsScreen()),
              ),
            ),
          const _SectionHeader('ปฏิทิน'),
          SettingRow(
            title: 'ปฏิทินเริ่มสัปดาห์วัน',
            value: _weekStartLabels[settings.calendarFirstWeekday] ?? '',
            onTap: () async {
              final day = await showChoiceSheet<int>(
                context,
                title: 'ปฏิทินเริ่มสัปดาห์วัน (เควสยังเริ่มวันจันทร์)',
                selected: settings.calendarFirstWeekday,
                choices: _weekStartLabels,
              );
              if (day != null) await repo.updateCalendarFirstWeekday(day);
            },
          ),
          const _SectionHeader('ข้อมูล'),
          const DataSettingsRows(),
          if (kDebugMode) ...[
            const _SectionHeader('Debug'),
            ListTile(
              title: const Text('แสดงปุ่มเดโม'),
              onTap: () {
                ref.read(demoButtonVisibleProvider.notifier).state = true;
                Navigator.of(context).pop();
              },
            ),
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
                    .generateSampleNights(ref.read(clockProvider)());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('สร้างข้อมูลตัวอย่างแล้ว')),
                  );
                }
              },
            ),
          ],
          const SizedBox(height: 24),
        ];
      },
    );
  }
}

void _open(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

/// A settings list that waits for the saved values.
class _SettingsPage extends ConsumerWidget {
  final String title;
  final List<Widget> Function(BuildContext context, SettingsRow settings) rows;

  const _SettingsPage({required this.title, required this.rows});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ref
          .watch(settingsStreamProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
            data: (settings) => ListView(
              padding: const EdgeInsets.all(GlowSpacing.pageMargin),
              children: rows(context, settings),
            ),
          ),
    );
  }
}

TimeOfDay _timeOf(int minutes) =>
    TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

const _weekStartLabels = {
  DateTime.sunday: 'อาทิตย์',
  DateTime.monday: 'จันทร์',
};

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
  IconData? icon,
}) {
  return SettingRow(
    title: title,
    icon: icon,
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
        const SizedBox(height: GlowSpacing.sm),
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
