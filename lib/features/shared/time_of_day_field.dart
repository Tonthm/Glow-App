import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';

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

/// 24-hour wheel picker in 5-minute steps (CLAUDE.md section 2). Returns null
/// if dismissed.
Future<TimeOfDay?> showTimeWheel(
  BuildContext context, {
  required String title,
  required TimeOfDay initial,
}) {
  // The wheel requires a starting value that sits on one of its steps.
  var picked = TimeOfDay(
    hour: initial.hour,
    minute: initial.minute - initial.minute % 5,
  );
  return showGlowBottomSheet<TimeOfDay>(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(
          height: 180,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            minuteInterval: 5,
            initialDateTime: DateTime(2000, 1, 1, picked.hour, picked.minute),
            onDateTimeChanged: (v) =>
                picked = TimeOfDay(hour: v.hour, minute: v.minute),
          ),
        ),
        const SizedBox(height: GlowSpacing.lg),
        GlowPrimaryButton(
          label: 'ตกลง',
          onPressed: () => Navigator.of(context).pop(picked),
        ),
      ],
    ),
  );
}

/// A time row: tap the time to pick it on a wheel, or nudge it by 5 minutes.
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
      contentPadding: const EdgeInsets.symmetric(horizontal: GlowSpacing.lg),
      title: Text(label),
      subtitle: Text(
        formatTimeOfDay(time),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onTap: () async {
        final picked = await showTimeWheel(
          context,
          title: label,
          initial: time,
        );
        if (picked != null) onChanged(picked);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: 'เร็วขึ้น 5 นาที',
            onPressed: () => onChanged(stepTimeOfDay(time, -5)),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'ช้าลง 5 นาที',
            onPressed: () => onChanged(stepTimeOfDay(time, 5)),
          ),
        ],
      ),
    );
  }
}
