import 'package:device_calendar/device_calendar.dart';

import '../data/database.dart';
import '../data/schedule_repository.dart';

const _examKeywords = ['สอบ', 'exam', 'midterm', 'final'];

enum ProposedKind { classSession, exam, activity }

/// One calendar event, pre-classified for the review screen (section 2:
/// "แสดงรายการพร้อมช่องติ๊ก แอปเดาประเภทให้").
class ProposedImportItem {
  final Event event;
  ProposedKind kind;
  bool selected;

  ProposedImportItem({
    required this.event,
    required this.kind,
    required this.selected,
  });

  bool get isWeekly => kind == ProposedKind.classSession;
}

ProposedKind _guessKind(Event event) {
  final title = (event.title ?? '').toLowerCase();
  if (_examKeywords.any((k) => title.contains(k))) return ProposedKind.exam;
  if (event.recurrenceRule?.recurrenceFrequency == RecurrenceFrequency.Weekly) {
    return ProposedKind.classSession;
  }
  return ProposedKind.activity;
}

class CalendarImportService {
  final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();
  final ScheduleRepository scheduleRepo;

  CalendarImportService(this.scheduleRepo);

  Future<List<Calendar>> listCalendars() async {
    final result = await _plugin.retrieveCalendars();
    if (result.data == null) return [];
    return result.data!.whereType<Calendar>().toList();
  }

  Future<List<ProposedImportItem>> fetchProposedItems({
    required String calendarId,
    required DateTime start,
    required DateTime end,
  }) async {
    final result = await _plugin.retrieveEvents(
      calendarId,
      RetrieveEventsParams(startDate: start, endDate: end),
    );
    final events = result.data?.toList() ?? <Event>[];

    final proposals = <ProposedImportItem>[];
    for (final event in events) {
      if (event.eventId == null || event.start == null || event.end == null) {
        continue;
      }
      if (await scheduleRepo.hasImportedCalendarEvent(event.eventId!)) {
        continue;
      }
      final kind = _guessKind(event);
      proposals.add(
        ProposedImportItem(
          event: event,
          kind: kind,
          selected: event.allDay != true,
        ),
      );
    }
    return proposals;
  }

  Future<void> importSelected(List<ProposedImportItem> items) async {
    for (final item in items.where((i) => i.selected)) {
      final event = item.event;
      final start = event.start!;
      final end = event.end!;
      switch (item.kind) {
        case ProposedKind.classSession:
          await scheduleRepo.addWeeklyItem(
            title: event.title ?? 'ไม่มีชื่อ',
            dayOfWeek: start.weekday,
            startMinutes: start.hour * 60 + start.minute,
            endMinutes: end.hour * 60 + end.minute,
            type: WeeklyItemType.classSession,
            source: ItemSource.calendar,
            calendarEventId: event.eventId,
          );
        case ProposedKind.exam:
          await scheduleRepo.addOneTimeItem(
            title: event.title ?? 'ไม่มีชื่อ',
            date: DateTime(start.year, start.month, start.day),
            type: OneTimeItemType.exam,
            startMinutes: event.allDay == true ? null : start.hour * 60 + start.minute,
            endMinutes: event.allDay == true ? null : end.hour * 60 + end.minute,
            source: ItemSource.calendar,
            calendarEventId: event.eventId,
          );
        case ProposedKind.activity:
          await scheduleRepo.addOneTimeItem(
            title: event.title ?? 'ไม่มีชื่อ',
            date: DateTime(start.year, start.month, start.day),
            type: OneTimeItemType.activity,
            startMinutes: event.allDay == true ? null : start.hour * 60 + start.minute,
            endMinutes: event.allDay == true ? null : end.hour * 60 + end.minute,
            source: ItemSource.calendar,
            calendarEventId: event.eventId,
          );
      }
    }
  }
}
