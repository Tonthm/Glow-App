import 'package:material_ui/material_ui.dart';

import '../../core/routine_config.dart';
import '../../theme/tokens.dart';

/// "วันนี้ทำอะไรมาบ้าง": activity chips and the button into the routine.
class ActivityCard extends StatelessWidget {
  final Set<DayActivityKind> selected;
  final ValueChanged<Set<DayActivityKind>> onChanged;
  final VoidCallback onStart;

  /// Length of the routine that would start, in minutes.
  final int minutes;
  final bool done;

  const ActivityCard({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.onStart,
    required this.minutes,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('วันนี้ทำอะไรมาบ้าง', style: textTheme.titleLarge),
        const SizedBox(height: GlowSpacing.sm),
        Wrap(
          spacing: GlowSpacing.sm,
          children: [
            for (final kind in DayActivityKind.values)
              FilterChip(
                label: Text(activityLabels[kind]!),
                selected: selected.contains(kind),
                onSelected: (on) => onChanged(
                  on ? {...selected, kind} : ({...selected}..remove(kind)),
                ),
              ),
          ],
        ),
        const SizedBox(height: GlowSpacing.sm),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: onStart,
          icon: Icon(done ? Icons.check : Icons.self_improvement),
          label: Text(
            done
                ? 'ทำท่าก่อนนอนแล้ว · ทำอีกครั้ง'
                : 'เริ่มท่าก่อนนอน ประมาณ $minutes นาที',
          ),
        ),
      ],
    );
  }
}
