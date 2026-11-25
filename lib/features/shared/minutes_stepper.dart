import 'package:material_ui/material_ui.dart';

String formatMinutesAsHours(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$h ชม.' : '$h ชม. $m นาที';
}

/// +/- stepper for a minutes-duration value (prep time, travel time, target
/// hours), shown as "H ชม. M นาที".
class MinutesStepper extends StatelessWidget {
  final String label;
  final int minutes;
  final int step;
  final ValueChanged<int> onChanged;

  const MinutesStepper({
    super.key,
    required this.label,
    required this.minutes,
    required this.onChanged,
    this.step = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(formatMinutesAsHours(minutes)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: minutes - step >= 0
                ? () => onChanged(minutes - step)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => onChanged(minutes + step),
          ),
        ],
      ),
    );
  }
}
