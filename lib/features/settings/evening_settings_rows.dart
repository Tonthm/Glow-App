import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/settings_repository.dart';
import '../../providers.dart';
import '../shared/time_of_day_field.dart';
import 'setting_row.dart';

/// The evening planner's values (CLAUDE.md section 14).
class EveningSettingsRows extends ConsumerWidget {
  final SettingsRow settings;

  const EveningSettingsRows({super.key, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(settingsRepositoryProvider);

    Widget minutes(
      String title,
      int value,
      SettingsCompanion Function(int) change, {
      int min = 0,
      int max = 180,
    }) => SettingRow(
      title: title,
      value: '$value นาที',
      onTap: () async {
        final picked = await showDurationSheet(
          context,
          title: title,
          initial: value,
          step: 5,
          min: min,
          max: max,
        );
        if (picked != null) await repo.updateEvening(change(picked));
      },
    );

    final dinner = TimeOfDay(
      hour: settings.dinnerStartMinutes ~/ 60,
      minute: settings.dinnerStartMinutes % 60,
    );

    return Column(
      children: [
        SwitchListTile(
          title: const Text('ตารางเย็น'),
          value: settings.eveningEnabled,
          onChanged: (v) =>
              repo.updateEvening(SettingsCompanion(eveningEnabled: Value(v))),
        ),
        const Divider(),
        if (settings.eveningEnabled) ...[
          minutes(
            'พักหลังถึงบ้าน',
            settings.restMinutes,
            (v) => SettingsCompanion(restMinutes: Value(v)),
          ),
          minutes(
            'ข้าวเย็น',
            settings.dinnerMinutes,
            (v) => SettingsCompanion(dinnerMinutes: Value(v)),
          ),
          SettingRow(
            title: 'ข้าวเย็นเริ่มประมาณ',
            value: formatTimeOfDay(dinner),
            onTap: () async {
              final picked = await showTimeWheel(
                context,
                title: 'ข้าวเย็นเริ่มประมาณ',
                initial: dinner,
              );
              if (picked == null) return;
              await repo.updateEvening(
                SettingsCompanion(
                  dinnerStartMinutes: Value(picked.hour * 60 + picked.minute),
                ),
              );
            },
          ),
          minutes(
            'อาบน้ำ',
            settings.showerMinutes,
            (v) => SettingsCompanion(showerMinutes: Value(v)),
          ),
          SwitchListTile(
            title: const Text('อาบน้ำตอนถึงบ้าน'),
            value: settings.showerOnArrival,
            onChanged: (v) => repo.updateEvening(
              SettingsCompanion(showerOnArrival: Value(v)),
            ),
          ),
          const Divider(),
          minutes(
            'ทำงานติดกันนานสุด',
            settings.maxFocusMinutes,
            (v) => SettingsCompanion(maxFocusMinutes: Value(v)),
            min: 15,
          ),
          minutes(
            'พักระหว่างงาน',
            settings.breakMinutes,
            (v) => SettingsCompanion(breakMinutes: Value(v)),
            min: 5,
          ),
          minutes(
            'เผื่อก่อนวางมือถือ',
            settings.bufferBeforeNotifyMinutes,
            (v) => SettingsCompanion(bufferBeforeNotifyMinutes: Value(v)),
          ),
        ],
      ],
    );
  }
}
