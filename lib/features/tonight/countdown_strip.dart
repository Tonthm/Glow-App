import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/countdown.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import '../tasks/task_list_screen.dart';

/// Exams and deadlines coming up, in a few lines, with one reminder to sleep
/// on plan. Nothing at all when none are near.
class CountdownStrip extends ConsumerWidget {
  const CountdownStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final now = ref.watch(clockProvider)();
    final exams = ref.watch(oneTimeItemsStreamProvider).value ?? const [];
    final tasks = ref.watch(taskEntriesProvider) ?? const [];

    final soon = countdowns([
      for (final item in exams)
        if (item.type == OneTimeItemType.exam)
          CountdownSource(
            kind: CountdownKind.exam,
            title: item.title.startsWith('สอบ')
                ? item.title
                : 'สอบ ${item.title}',
            date: item.date,
            endsAt: item.endMinutes == null
                ? null
                : DateTime(
                    item.date.year,
                    item.date.month,
                    item.date.day,
                    0,
                    item.endMinutes!,
                  ),
          ),
      for (final entry in tasks)
        if (!entry.done && entry.task.dueDate != null)
          CountdownSource(
            kind: CountdownKind.deadline,
            title: 'ส่ง ${entry.task.title}',
            date: entry.task.dueDate!,
          ),
    ], now: now);
    if (soon.isEmpty) return const SizedBox.shrink();

    final first = soon.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: GlowSpacing.md),
      child: GlowCard(
        pastel: GlowPastel.sky,
        padding: const EdgeInsets.all(GlowSpacing.md),
        onTap: () => openTaskList(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in soon)
              Row(
                children: [
                  Icon(
                    item.kind == CountdownKind.exam
                        ? Icons.school_outlined
                        : Icons.assignment_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: GlowSpacing.sm),
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(width: GlowSpacing.sm),
                  Text(
                    daysLeftLabel(item.daysLeft),
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            const SizedBox(height: GlowSpacing.xs),
            Text(
              sleepReminder(first.kind, first.daysLeft),
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
