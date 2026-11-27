/// Debug-only floating button for moving through time during a demo.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/night_date.dart';
import '../../core/schedule_load.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../ai/ai_providers.dart';
import '../share/story_gallery_screen.dart';
import 'demo_data.dart';

final demoButtonVisibleProvider = StateProvider<bool>((ref) => true);

class DemoButton extends ConsumerWidget {
  const DemoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(demoButtonVisibleProvider)) return const SizedBox.shrink();
    final offset = ref.watch(clockOffsetProvider);
    final now = ref.watch(clockProvider)();
    final label = offset == Duration.zero
        ? 'เดโม'
        : '${now.day}/${now.month} '
              '${now.hour.toString().padLeft(2, '0')}:'
              '${now.minute.toString().padLeft(2, '0')}';
    return ActionChip(
      avatar: const Icon(Icons.fast_forward_outlined, size: 16),
      label: Text(label),
      onPressed: () => _openMenu(context, ref),
    );
  }

  Future<void> _openMenu(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final action = await showGlowBottomSheet<Future<String?> Function()>(
      context: context,
      builder: (context) {
        Widget item(String title, Future<String?> Function() run) => ListTile(
          dense: true,
          title: Text(title),
          onTap: () => Navigator.of(context).pop(run),
        );
        final clock = ref.read(clockOffsetProvider.notifier);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('โหมดเดโม', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: GlowSpacing.sm),
            item('รีเซ็ตเดโม', () async {
              final today = DateTime.now();
              await clock.travelTo(
                DateTime(
                  today.year,
                  today.month,
                  today.day,
                  demoStartHour,
                  demoStartMinute,
                ),
              );
              await resetDemoData(ref.read(databaseProvider), today);
              return 'ข้อมูลเดโมพร้อมแล้ว';
            }),
            item('ไปตอนเย็น 20:00', () async {
              final now = ref.read(clockProvider)();
              await clock.travelTo(DateTime(now.year, now.month, now.day, 20));
              return null;
            }),
            item('ไปเวลาวางมือถือ', () => _jumpToPlan(ref, notify: true)),
            item('ไปเวลาเข้านอน', () => _jumpToPlan(ref, notify: false)),
            item('ไปพรุ่งนี้เช้าเวลาตื่น', () => _jumpToWake(ref)),
            item('ไปวันตารางแน่น', () => _jumpToRedNight(ref)),
            item(
              ref.read(aiDemoModeProvider) ? 'ปิด AI จำลอง' : 'ใช้ AI จำลอง',
              () async {
                final demo = ref.read(aiDemoModeProvider.notifier);
                demo.state = !demo.state;
                return demo.state
                    ? 'ใช้ AI จำลองแล้ว ไม่ต้องใช้ key'
                    : 'ปิด AI จำลองแล้ว';
              },
            ),
            item('ตรวจรอบการนอน (ล้างข้อมูล)', () => _cycleDemo(context, ref)),
            item('ตรวจภาพแชร์', () async {
              unawaited(
                navigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => const StoryGalleryScreen(),
                  ),
                ),
              );
              return null;
            }),
            item('กลับเวลาจริง', () async {
              await clock.reset();
              return null;
            }),
            item('ซ่อนปุ่มนี้ (เปิดใหม่ได้ในตั้งค่า)', () async {
              ref.read(demoButtonVisibleProvider.notifier).state = false;
              return null;
            }),
          ],
        );
      },
    );
    if (action == null) return;
    final message = await action();
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Asks which cycle bar case to set up, at 19:00 so nothing has locked.
  Future<String?> _cycleDemo(BuildContext context, WidgetRef ref) async {
    final host = ref.context;
    final db = ref.read(databaseProvider);
    final clock = ref.read(clockOffsetProvider.notifier);
    final demo = await showGlowBottomSheet<CycleDemo>(
      context: host,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ตรวจรอบการนอน ตื่น 06:30',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          for (final demo in CycleDemo.values)
            ListTile(
              dense: true,
              title: Text(demo.label),
              onTap: () => Navigator.of(context).pop(demo),
            ),
        ],
      ),
    );
    if (demo == null) return null;
    final today = DateTime.now();
    await clock.travelTo(DateTime(today.year, today.month, today.day, 19));
    await resetCycleDemo(db, today, demo);
    return demo.label;
  }

  Future<String?> _jumpToPlan(WidgetRef ref, {required bool notify}) async {
    final repo = ref.read(nightPlanningRepositoryProvider);
    final plan = await repo.currentPlan(
      resolveTonightWakeDate(ref.read(clockProvider)()),
    );
    final minutes = plan.isPreExamNight ? 90 : 60;
    await ref
        .read(clockOffsetProvider.notifier)
        .travelTo(
          notify
              ? plan.bedtime.subtract(Duration(minutes: minutes))
              : plan.bedtime,
        );
    return null;
  }

  /// The morning that ends the night in progress (or tonight's).
  Future<String?> _jumpToWake(WidgetRef ref) async {
    final repo = ref.read(nightPlanningRepositoryProvider);
    final now = ref.read(clockProvider)();
    var plan = await repo.currentPlan(resolveTonightWakeDate(now));
    if (!plan.wakeTime.isAfter(now)) {
      plan = await repo.currentPlan(
        DateTime(
          plan.wakeDate.year,
          plan.wakeDate.month,
          plan.wakeDate.day + 1,
        ),
      );
    }
    // Lock the night as it would have locked at the reminder time.
    await repo.getOrLockPlan(plan.wakeDate, now: plan.wakeTime);
    await ref
        .read(clockOffsetProvider.notifier)
        .travelTo(plan.wakeTime.add(const Duration(minutes: 1)));
    return null;
  }

  /// The late afternoon before the next night the schedule makes red.
  Future<String?> _jumpToRedNight(WidgetRef ref) async {
    final repo = ref.read(nightPlanningRepositoryProvider);
    final today = ref.read(clockProvider)();
    for (var ahead = 1; ahead <= 7; ahead++) {
      final wakeDate = DateTime(today.year, today.month, today.day + ahead);
      final plan = await repo.computeDraftForWakeDate(wakeDate);
      final load = await repo.computeEveningLoad(plan);
      if (load.level != EveningLoadLevel.red) continue;
      await ref
          .read(clockOffsetProvider.notifier)
          .travelTo(
            DateTime(wakeDate.year, wakeDate.month, wakeDate.day - 1, 17),
          );
      return null;
    }
    return 'ไม่มีวันตารางแน่นใน 7 วันข้างหน้า ลองรีเซ็ตเดโม';
  }
}
