import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/day_overrides.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../shared/minutes_stepper.dart';
import 'setting_row.dart';

const _dayNames = [
  'จันทร์',
  'อังคาร',
  'พุธ',
  'พฤหัส',
  'ศุกร์',
  'เสาร์',
  'อาทิตย์',
];

Future<void> showTravelByDaySheet(BuildContext context) {
  return showGlowBottomSheet(
    context: context,
    builder: (_) => const _TravelByDay(),
  );
}

class _TravelByDay extends ConsumerWidget {
  const _TravelByDay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStreamProvider).value;
    if (settings == null) return const SizedBox.shrink();
    final overrides = parseTravelOverrides(settings.travelOverrides);
    final repo = ref.read(settingsRepositoryProvider);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'เวลาเดินทางแยกรายวัน',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: GlowSpacing.sm),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var day = 1; day <= 7; day++)
                  ListTile(
                    title: Text(_dayNames[day - 1]),
                    subtitle: Text(
                      overrides.containsKey(day)
                          ? formatMinutesAsHours(overrides[day]!)
                          : 'ตามปกติ',
                    ),
                    trailing: overrides.containsKey(day)
                        ? TextButton(
                            onPressed: () => repo.setTravelOverride(day, null),
                            child: const Text('ใช้ค่าปกติ'),
                          )
                        : null,
                    onTap: () async {
                      final picked = await showDurationSheet(
                        context,
                        title: 'เดินทางวัน${_dayNames[day - 1]}',
                        initial:
                            overrides[day] ?? settings.defaultTravelMinutes,
                        step: 5,
                        min: 0,
                        max: 4 * 60,
                      );
                      if (picked != null) {
                        await repo.setTravelOverride(day, picked);
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
