import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../shared/minutes_stepper.dart';

/// A settings row on a rounded surface; tapping opens its editor.
class SettingRow extends StatelessWidget {
  final String title;
  final String? value;
  final VoidCallback onTap;

  const SettingRow({
    super.key,
    required this.title,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: value == null
              ? const Icon(Icons.chevron_right)
              : Text(value!, style: Theme.of(context).textTheme.bodyMedium),
          onTap: onTap,
        ),
        const SizedBox(height: GlowSpacing.sm),
      ],
    );
  }
}

Future<T?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required T selected,
  required Map<T, String> choices,
}) {
  return showGlowBottomSheet<T>(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        for (final entry in choices.entries)
          ListTile(
            title: Text(entry.value),
            trailing: entry.key == selected ? const Icon(Icons.check) : null,
            onTap: () => Navigator.of(context).pop(entry.key),
          ),
      ],
    ),
  );
}

/// Edits a length of time with -/+ buttons kept within [min]..[max].
Future<int?> showDurationSheet(
  BuildContext context, {
  required String title,
  required int initial,
  required int step,
  required int min,
  required int max,
}) {
  var minutes = initial;
  return showGlowBottomSheet<int>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: GlowSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: 'ลด',
                onPressed: minutes - step >= min
                    ? () => setState(() => minutes -= step)
                    : null,
              ),
              Text(
                formatMinutesAsHours(minutes),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'เพิ่ม',
                onPressed: minutes + step <= max
                    ? () => setState(() => minutes += step)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: GlowSpacing.lg),
          GlowPrimaryButton(
            label: 'บันทึก',
            onPressed: () => Navigator.of(context).pop(minutes),
          ),
        ],
      ),
    ),
  );
}
