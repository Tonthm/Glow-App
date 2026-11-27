import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/birth_date.dart';
import '../../core/calendar_view.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../ai/ai_providers.dart';
import 'one_time_item_form.dart';
import 'weekly_item_form.dart';

enum AddMethod { type, voice, calendar, photo }

Future<AddMethod?> showAddMethodSheet(BuildContext context) {
  return showGlowBottomSheet<AddMethod>(
    context: context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final platform = ref.watch(platformCapabilitiesProvider);
        final mic = ref.watch(micAvailableProvider);
        // Never shown to a birth date under 18. With AI off it leads to the
        // AI settings instead.
        final age = platform.aiAssistant
            ? ref.watch(aiAgeProvider).value
            : null;
        final photo = age != null && age != AiAgeState.hidden;
        final aiReady = ref.watch(aiReadyProvider).value ?? false;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('เพิ่มตาราง', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: GlowSpacing.sm),
            Text(
              'เลือกวิธีที่สะดวกสำหรับคุณ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: GlowSpacing.xl),
            Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .secondaryContainer,
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: GlowSpacing.xl),
            ListTile(
              leading: const Icon(Icons.keyboard_outlined),
              title: const Text('พิมพ์'),
              onTap: () => Navigator.of(context).pop(AddMethod.type),
            ),
            const SizedBox(height: GlowSpacing.sm),
            // Without a mic this page still takes a whole sentence, which
            // the phone's own keyboard can dictate.
            ListTile(
              leading: Icon(
                mic ? Icons.mic_none_outlined : Icons.notes_outlined,
              ),
              title: Text(mic ? 'พูด' : 'ใส่หลายคาบเป็นประโยค'),
              subtitle: mic ? null : const Text('พิมพ์ หรือใช้ไมค์บนคีย์บอร์ด'),
              onTap: () => Navigator.of(context).pop(AddMethod.voice),
            ),
            if (photo) ...[
              const SizedBox(height: GlowSpacing.sm),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('นำเข้าจากรูป'),
                subtitle: aiReady
                    ? null
                    : const Text(
                        'ต้องเปิดผู้ช่วย AI ก่อน (Google กำหนดอายุ 18 ปีขึ้นไป)',
                      ),
                onTap: () => Navigator.of(context).pop(AddMethod.photo),
              ),
            ],
            if (platform.calendarImport) ...[
              const SizedBox(height: GlowSpacing.sm),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('นำเข้าจากปฏิทิน'),
                onTap: () => Navigator.of(context).pop(AddMethod.calendar),
              ),
            ],
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
        Text('พิมพ์ตาราง', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: GlowSpacing.lg),
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
