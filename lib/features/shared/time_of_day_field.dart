import 'package:material_ui/material_ui.dart';

TimeOfDay stepTimeOfDay(TimeOfDay time, int deltaMinutes) {
  final total = (time.hour * 60 + time.minute + deltaMinutes) % (24 * 60);
  final wrapped = total < 0 ? total + 24 * 60 : total;
  return TimeOfDay(hour: wrapped ~/ 60, minute: wrapped % 60);
}

String formatTimeOfDay(TimeOfDay time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// Inline +/- time-of-day picker in 5-minute steps ("เลือกเวลาได้ทีละ 5
/// นาที" — CLAUDE.md section 2), faster for repeated entry than opening the
/// native time picker dialog every time.
class TimeOfDayField extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  const TimeOfDayField({
    super.key,
    required this.label,
    required this.time,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        formatTimeOfDay(time),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => onChanged(stepTimeOfDay(time, -5)),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => onChanged(stepTimeOfDay(time, 5)),
          ),
        ],
      ),
    );
  }
}
