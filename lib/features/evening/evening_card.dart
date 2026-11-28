import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/evening_planner.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import '../shared/subject_colors.dart';
import 'evening_providers.dart';
import 'evening_screen.dart';
import 'task_form_sheet.dart';

/// "แผนช่วงเย็น" on the sleep tab: what is happening now or next. Tapping it
/// opens the whole evening, which also lists every task.
class EveningCard extends ConsumerWidget {
  final VoidCallback onOpen;
  final bool embedded;

  const EveningCard({super.key, required this.onOpen, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(eveningViewProvider).value;
    if (view == null) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final now = ref.read(clockProvider)();
    final next = view.plan.blocks.where((b) => b.end.isAfter(now)).firstOrNull;

    String describe(EveningBlock b) =>
        '${b.start.isAfter(now) ? 'ถัดไป ${formatClock(b.start)}' : 'ตอนนี้'}: '
        '${b.title} ถึง ${formatClock(b.end)}';

    final padding = embedded
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 3)
        : const EdgeInsets.fromLTRB(
            GlowSpacing.lg,
            GlowSpacing.md,
            GlowSpacing.sm,
            GlowSpacing.md,
          );
    final content = Row(
      children: [
        Icon(Icons.checklist, size: embedded ? 20 : 24),
        SizedBox(width: embedded ? 12 : GlowSpacing.lg),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'แผนช่วงเย็น',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: embedded ? 13 : null,
                ),
              ),
              if (view.tasks.isEmpty)
                Text(
                  'ยังไม่มีงานคืนนี้',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: embedded ? 11 : null,
                  ),
                )
              else if (next != null)
                Row(
                  children: [
                    SubjectDot(
                      ref.watch(subjectColorsProvider).value ?? const {},
                      next.title,
                    ),
                    Expanded(
                      child: Text(
                        describe(next),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: embedded ? 11 : null,
                        ),
                      ),
                    ),
                  ],
                ),
              if (view.plan.overflow.isNotEmpty)
                Text(
                  'งานเกินไป ${view.plan.overflowMinutes} นาที',
                  style: textTheme.bodyLarge,
                ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'เพิ่มงาน',
          icon: const Icon(Icons.add),
          onPressed: () async {
            await showTaskForm(context, planDate: view.eveningDate);
            ref.invalidate(eveningViewProvider);
          },
        ),
      ],
    );
    return embedded
        ? InkWell(
            onTap: onOpen,
            child: Padding(padding: padding, child: content),
          )
        : GlowCard(padding: padding, onTap: onOpen, child: content);
  }
}
