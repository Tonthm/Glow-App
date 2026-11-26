import 'dart:convert';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/web_reminders.dart';
import '../../data/calendar_reminder_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../services/file_saver.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/warning_bar.dart';

final calendarReminderRepositoryProvider = Provider<CalendarReminderRepository>(
  (ref) => CalendarReminderRepository(
    ref.watch(databaseProvider),
    ref.watch(nightPlanningRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
  ),
);

final _reminderChangesProvider = StreamProvider<void>((ref) {
  final db = ref.watch(databaseProvider);
  return db.tableUpdates(TableUpdateQuery.onTable(db.calendarReminderStates));
});

typedef _WebStatus = ({
  CalendarReminderStatus calendar,
  List<DateTime> redNights,
  bool showRedNights,
  bool backupOverdue,
});

final _webStatusProvider = FutureProvider.autoDispose<_WebStatus>((ref) async {
  // Recheck when the timetable, settings, plans, or backups change.
  ref.watch(eveningChangesProvider);
  ref.watch(_reminderChangesProvider);
  final now = ref.watch(clockProvider)();
  final repo = ref.watch(calendarReminderRepositoryProvider);
  final settings = await ref.watch(settingsRepositoryProvider).get();
  return (
    calendar: await repo.status(now),
    redNights: await repo.redNightsAhead(now),
    showRedNights: settings.notifyBusyNight,
    backupOverdue: await repo.backupOverdue(now),
  );
});

const _statusMessages = {
  CalendarReminderStatus.planChanged:
      'แผนเปลี่ยน เพิ่มเตือนใหม่เพื่ออัปเดตปฏิทิน',
  CalendarReminderStatus.runningOut: 'เตือนในปฏิทินจะหมดแล้ว เพิ่มรอบใหม่',
};

/// "เพิ่มเตือนลงปฏิทิน (7 วัน)": makes the .ics file and hands it over.
Future<void> addCalendarReminders(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  String message;
  try {
    final calendar = await ref
        .read(calendarReminderRepositoryProvider)
        .generate(ref.read(clockProvider)());
    if (calendar == null) {
      message = 'ยังไม่มีเตือนให้เพิ่ม ลองเปิดเตือนอย่างน้อยหนึ่งแบบในตั้งค่า';
    } else {
      await saveFile(
        'glow-reminders.ics',
        utf8.encode(calendar.text),
        'text/calendar;charset=utf-8',
      );
      message =
          'สร้างเตือน ${calendar.events.length} รายการแล้ว แนะนำให้เพิ่มลง'
          'ปฏิทินแยกชื่อ Glow จะลบทั้งชุดได้ง่าย';
    }
  } catch (_) {
    message = 'สร้างไฟล์ปฏิทินไม่สำเร็จ ลองอีกครั้ง';
  }
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

/// The web version's lines on the Tonight screen: red nights ahead (shown in
/// the app only), calendar reminders, and the backup nudge.
class WebReminderBars extends ConsumerWidget {
  const WebReminderBars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(_webStatusProvider).value;
    final message = _statusMessages[status?.calendar];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status != null &&
            status.showRedNights &&
            status.redNights.isNotEmpty) ...[
          WarningBar(
            severity: WarningBarSeverity.red,
            message:
                'ใน 7 วันข้างหน้ามีคืนที่ตารางชนกับเวลานอน: ตื่นวันที่ '
                '${status.redNights.map((d) => '${d.day}/${d.month}').join(', ')}',
          ),
          const SizedBox(height: GlowSpacing.sm),
        ],
        if (message != null) ...[
          WarningBar(severity: WarningBarSeverity.yellow, message: message),
          const SizedBox(height: GlowSpacing.sm),
        ],
        OutlinedButton.icon(
          icon: const Icon(Icons.event_available_outlined),
          label: const Text('เพิ่มเตือนลงปฏิทิน (7 วัน)'),
          onPressed: () => addCalendarReminders(context, ref),
        ),
        if (status?.backupOverdue == true) ...[
          const SizedBox(height: GlowSpacing.sm),
          Row(
            children: [
              const Expanded(child: Text('สำรองข้อมูลไว้ไหม')),
              TextButton(
                onPressed: () => ref.read(backupServiceProvider).exportToFile(),
                child: const Text('สำรองตอนนี้'),
              ),
            ],
          ),
        ],
        const SizedBox(height: GlowSpacing.lg),
      ],
    );
  }
}
