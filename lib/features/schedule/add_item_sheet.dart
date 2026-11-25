import 'package:material_ui/material_ui.dart';

import '../../theme/widgets/glow_bottom_sheet.dart';
import 'one_time_item_form.dart';
import 'weekly_item_form.dart';

enum AddMethod { type, calendar }

Future<AddMethod?> showAddMethodSheet(BuildContext context) {
  return showGlowBottomSheet<AddMethod>(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.keyboard_outlined),
          title: const Text('พิมพ์'),
          onTap: () => Navigator.of(context).pop(AddMethod.type),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month_outlined),
          title: const Text('นำเข้าจากปฏิทิน'),
          onTap: () => Navigator.of(context).pop(AddMethod.calendar),
        ),
      ],
    ),
  );
}

/// Typing must be reachable from every way of adding (CLAUDE.md section 2:
/// "ช่องพิมพ์ต้องใช้ได้เสมอ"), so this is shared.
Future<void> showTypedEntryChooser(BuildContext context) async {
  final weekly = await showGlowBottomSheet<bool>(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.repeat),
          title: const Text('คาบเรียน/กิจกรรมรายสัปดาห์'),
          onTap: () => Navigator.of(context).pop(true),
        ),
        ListTile(
          leading: const Icon(Icons.event_outlined),
          title: const Text('สอบ/กิจกรรม/วันหยุด (ครั้งเดียว)'),
          onTap: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
  if (weekly == null || !context.mounted) return;
  if (weekly) {
    await showWeeklyItemForm(context);
  } else {
    await showOneTimeItemForm(context);
  }
}
