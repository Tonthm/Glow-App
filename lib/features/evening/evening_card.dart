import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/evening_planner.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../shared/subject_colors.dart';
import '../tasks/task_list_screen.dart';
import '../../theme/tokens.dart';
import 'evening_providers.dart';
import 'evening_screen.dart';
import 'task_form_sheet.dart';

/// The evening at a glance on the Tonight screen: the current and next block,
/// and the button to add a task.
class EveningCard extends ConsumerWidget {
  final VoidCallback onOpen;

  const EveningCard({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(eveningViewProvider).value;
    if (view == null) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final now = ref.read(clockProvider)();
    final upcoming = view.plan.blocks
        .where((b) => b.end.isAfter(now))
        .take(2)
        .toList();

    String describe(EveningBlock b) =>
        '${b.start.isAfter(now) ? 'ถัดไป ${formatClock(b.start)}' : 'ตอนนี้'}: '
        '${b.title} ถึง ${formatClock(b.end)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (view.tasks.isEmpty)
          Text('ยังไม่มีงานคืนนี้', style: textTheme.bodyMedium)
        else ...[
          for (final block in upcoming)
            Row(
              children: [
                SubjectDot(
                  ref.watch(subjectColorsProvider).value ?? const {},
                  block.title,
                ),
                Expanded(
                  child: Text(describe(block), style: textTheme.bodyMedium),
                ),
              ],
            ),
          if (view.plan.overflow.isNotEmpty)
            Text(
              'งานเกินไป ${view.plan.overflowMinutes} นาที',
              style: textTheme.bodyLarge,
            ),
        ],
        Wrap(
          spacing: GlowSpacing.sm,
          children: [
            TextButton(onPressed: onOpen, child: const Text('ดูตารางเย็น')),
            TextButton(
              onPressed: () async {
                await openTaskList(context);
                ref.invalidate(eveningViewProvider);
              },
              child: const Text('งานทั้งหมด'),
            ),
            TextButton(
              onPressed: () async {
                await showTaskForm(context, planDate: view.eveningDate);
                ref.invalidate(eveningViewProvider);
              },
              child: const Text('เพิ่มงาน'),
            ),
          ],
        ),
      ],
    );
  }
}
