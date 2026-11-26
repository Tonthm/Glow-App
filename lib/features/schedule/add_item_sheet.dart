import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/calendar_view.dart';
import '../../providers.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import 'one_time_item_form.dart';
import 'weekly_item_form.dart';

enum AddMethod { type, voice, calendar }

Future<AddMethod?> showAddMethodSheet(BuildContext context) {
  return showGlowBottomSheet<AddMethod>(
    context: context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final platform = ref.watch(platformCapabilitiesProvider);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.keyboard_outlined),
              title: const Text('พิมพ์'),
              onTap: () => Navigator.of(context).pop(AddMethod.type),
            ),
            if (platform.voiceInput)
              ListTile(
                leading: const Icon(Icons.mic_none_outlined),
                title: const Text('พูด'),
                onTap: () => Navigator.of(context).pop(AddMethod.voice),
              ),
            if (platform.calendarImport)
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('นำเข้าจากปฏิทิน'),
                onTap: () => Navigator.of(context).pop(AddMethod.calendar),
              ),
          ],
        );
      },
    ),
  );
}

/// Typing must be reachable from every way of adding (CLAUDE.md section 2:
/// "ช่องพิมพ์ต้องใช้ได้เสมอ"), so this is shared. With a [date], the form
/// that opens already has that day filled in.
Future<void> showTypedEntryChooser(
  BuildContext context, {
  DateTime? date,
  TimeOfDay? start,
  bool outsideTerm = false,
}) async {
  final weekly = await showGlowBottomSheet<bool>(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (date != null)
          Text(dayTitle(date), style: Theme.of(context).textTheme.titleMedium),
        ListTile(
          leading: const Icon(Icons.repeat),
          title: Text(
            date == null ? 'คาบเรียน/กิจกรรมรายสัปดาห์' : 'ประจำสัปดาห์',
          ),
          subtitle: date == null
              ? null
              : Text(
                  'คาบเรียนหรือกิจกรรมทุกวัน${weekdayName(date.weekday)}'
                  '${outsideTerm ? ' (วันนี้อยู่นอกช่วงเทอม จะไม่แสดง)' : ''}',
                ),
          onTap: () => Navigator.of(context).pop(true),
        ),
        ListTile(
          leading: const Icon(Icons.event_outlined),
          title: Text(
            date == null ? 'สอบ/กิจกรรม/วันหยุด (ครั้งเดียว)' : 'ครั้งเดียว',
          ),
          subtitle: date == null
              ? null
              : const Text('สอบ กิจกรรม หรือวันหยุด เฉพาะวันนี้'),
          onTap: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
  if (weekly == null || !context.mounted) return;
  if (weekly) {
    await showWeeklyItemForm(
      context,
      initialDayOfWeek: date?.weekday,
      initialStart: start,
    );
  } else {
    await showOneTimeItemForm(context, initialDate: date, initialStart: start);
  }
}
