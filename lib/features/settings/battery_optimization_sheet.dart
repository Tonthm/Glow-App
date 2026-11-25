import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../services/permissions_service.dart';

Future<void> showBatteryOptimizationSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _BatteryOptimizationSheet(),
  );
}

class _BatteryOptimizationSheet extends ConsumerWidget {
  const _BatteryOptimizationSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'ปิดการประหยัดแบตให้ Glow',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'มือถือหลายยี่ห้อปิดแอปเบื้องหลังเองเพื่อประหยัดแบต ทำให้แจ้งเตือนไม่เด้ง '
              'เลือกยี่ห้อเครื่องของคุณแล้วทำตามขั้นตอน:',
            ),
            const SizedBox(height: 16),
            for (final brand in PhoneBrand.values)
              ExpansionTile(
                title: Text(BatteryOptimizationGuide.labels[brand]!),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(BatteryOptimizationGuide.steps[brand]!),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  ref.read(permissionsServiceProvider).openSystemAppSettings(),
              child: const Text('ไปที่ตั้งค่าแอป'),
            ),
          ],
        );
      },
    );
  }
}
