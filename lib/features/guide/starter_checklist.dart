import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/guide.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_fold.dart';
import 'guide_entries.dart';
import 'guide_providers.dart';
import 'navigation.dart';

/// "เริ่มต้นใช้งาน" on the sleep tab: one folded card that ticks itself and
/// goes away when finished or closed (CLAUDE.md section 21).
class StarterChecklist extends ConsumerWidget {
  const StarterChecklist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(checklistProvider).value;
    final steps = checklistSteps(ref.watch(guideAccessProvider));
    if (view == null ||
        !showsChecklist(
          steps: steps,
          done: view.done,
          dismissed: view.dismissed,
        )) {
      return const SizedBox.shrink();
    }
    final textTheme = Theme.of(context).textTheme;
    final count = steps.where(view.done.contains).length;
    return Padding(
      padding: const EdgeInsets.only(top: GlowSpacing.md),
      child: GlowFold(
        icon: Icons.flag_outlined,
        title: 'เริ่มต้นใช้งาน',
        summary: 'ทำแล้ว $count จาก ${steps.length} ขั้น',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final step in steps)
              _row(context, step, view.done.contains(step), textTheme),
            TextButton(
              onPressed: () =>
                  ref.read(guideRepositoryProvider).dismissChecklist(),
              child: const Text('ปิดรายการนี้'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    ChecklistStep step,
    bool done,
    TextTheme textTheme,
  ) {
    final (label, destination) = checklistText[step]!;
    return Semantics(
      checked: done,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(label, style: textTheme.bodyLarge),
        trailing: done ? null : const Icon(Icons.chevron_right),
        onTap: done ? null : () => navigateTo(context, destination),
      ),
    );
  }
}
