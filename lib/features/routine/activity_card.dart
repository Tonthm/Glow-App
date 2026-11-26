import 'package:material_ui/material_ui.dart';

import '../../core/routine_config.dart';
import '../../theme/tokens.dart';

/// "วันนี้ทำอะไรมาบ้าง": guessed chips, one tap to confirm, and the button
/// into the routine.
class ActivityCard extends StatefulWidget {
  final Set<DayActivityKind> selected;

  /// True once the user has confirmed or changed the guess.
  final bool confirmed;
  final ValueChanged<Set<DayActivityKind>> onChanged;
  final VoidCallback onConfirm;
  final VoidCallback onStart;

  /// Length of the routine that would start, in minutes.
  final int minutes;
  final bool done;

  const ActivityCard({
    super.key,
    required this.selected,
    required this.confirmed,
    required this.onChanged,
    required this.onConfirm,
    required this.onStart,
    required this.minutes,
    required this.done,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = widget.selected;
    final showChips = !widget.confirmed || _editing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('วันนี้ทำอะไรมาบ้าง', style: textTheme.titleMedium),
        const SizedBox(height: GlowSpacing.sm),
        if (showChips) ...[
          Wrap(
            spacing: GlowSpacing.sm,
            children: [
              for (final kind in DayActivityKind.values)
                FilterChip(
                  label: Text(activityLabels[kind]!),
                  selected: selected.contains(kind),
                  onSelected: (on) {
                    setState(() => _editing = true);
                    widget.onChanged(
                      on ? {...selected, kind} : ({...selected}..remove(kind)),
                    );
                  },
                ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() => _editing = false);
              widget.onConfirm();
            },
            child: const Text('ใช่ ตามนี้'),
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: Text(
                  selected.isEmpty
                      ? 'ใช้ชุดท่าทั่วไป'
                      : selected.map((k) => activityLabels[k]!).join(', '),
                  style: textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _editing = true),
                child: const Text('แก้'),
              ),
            ],
          ),
        const SizedBox(height: GlowSpacing.sm),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: widget.onStart,
          icon: Icon(widget.done ? Icons.check : Icons.self_improvement),
          label: Text(
            widget.done
                ? 'ทำท่าก่อนนอนแล้ว · ทำอีกครั้ง'
                : 'เริ่มท่าก่อนนอน ประมาณ ${widget.minutes} นาที',
          ),
        ),
      ],
    );
  }
}
