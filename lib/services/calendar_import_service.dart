import 'package:flutter/services.dart';

import '../core/calendar_events.dart';
import '../data/database.dart';
import '../data/schedule_repository.dart';

class DeviceCalendar {
  final String id;
  final String name;
  final String account;

  const DeviceCalendar({
    required this.id,
    required this.name,
    required this.account,
  });
}

/// One calendar event, pre-classified for the review screen (section 2:
/// "แสดงรายการพร้อมช่องติ๊ก แอปเดาประเภทให้").
class ProposedImportItem {
  final CalendarEvent event;
  ImportKind kind;
  bool selected;

  ProposedImportItem({
    required this.event,
    required this.kind,
    required this.selected,
  });
}

/// Reads the phone calendar through the app's own read-only platform channel
/// (see MainActivity.kt). iOS would implement the same three methods.
class CalendarImportService {
  static const _channel = MethodChannel('glow/calendar');

  final ScheduleRepository scheduleRepo;

  CalendarImportService(this.scheduleRepo);

  Future<bool> requestPermission() async =>
      await _channel.invokeMethod<bool>('requestPermission') ?? false;

  Future<List<DeviceCalendar>> listCalendars() async {
    final rows = await _channel.invokeListMethod<Map>('listCalendars') ?? [];
    return [
      for (final row in rows)
        DeviceCalendar(
          id: row['id'] as String,
          name: row['name'] as String? ?? 'ไม่มีชื่อ',
          account: row['account'] as String? ?? '',
        ),
    ];
  }

  /// Events from [start] through the whole of [end]'s day that haven't been
  /// imported before.
  Future<List<ProposedImportItem>> fetchProposedItems({
    required String calendarId,
    required DateTime start,
    required DateTime end,
  }) async {
    final rows =
        await _channel.invokeListMethod<Map>('listEvents', {
          'calendarId': calendarId,
          'start': DateTime(
            start.year,
            start.month,
            start.day,
          ).millisecondsSinceEpoch,
          'end': DateTime(
            end.year,
            end.month,
            end.day + 1,
          ).millisecondsSinceEpoch,
        }) ??
        [];

    final events = <CalendarEvent>[];
    for (final row in rows) {
      final eventId = row['eventId'] as String?;
      if (eventId == null) continue;
      if (await scheduleRepo.hasImportedCalendarEvent(eventId)) continue;
      final allDay = row['allDay'] as bool;
      DateTime local(int millis) {
        final utc = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
        // All-day events are stored as UTC midnight; keep the same date.
        return allDay ? DateTime(utc.year, utc.month, utc.day) : utc.toLocal();
      }

      events.add(
        CalendarEvent(
          eventId: eventId,
          title: (row['title'] as String?)?.trim().isNotEmpty == true
              ? row['title'] as String
              : 'ไม่มีชื่อ',
          start: local(row['begin'] as int),
          end: local(row['end'] as int),
          allDay: allDay,
          repeatsWeekly:
              (row['rrule'] as String?)?.contains('FREQ=WEEKLY') ?? false,
        ),
      );
    }

    return [
      for (final event in collapseWeeklyRepeats(events))
        ProposedImportItem(
          event: event,
          kind: guessEventKind(event),
          selected: !event.allDay,
        ),
    ];
  }

  Future<void> importSelected(List<ProposedImportItem> items) async {
    final weeklySlots = <String>{};
    for (final item in items.where((i) => i.selected)) {
      final event = item.event;
      final minutes = importMinutes(event);
      switch (item.kind) {
        case ImportKind.classSession:
          // Someone may mark several one-off copies as the same class.
          final slot =
              '${event.title}|${event.start.weekday}|${minutes.start}|${minutes.end}';
          if (!weeklySlots.add(slot)) continue;
          await scheduleRepo.addWeeklyItem(
            title: event.title,
            dayOfWeek: event.start.weekday,
            // An all-day entry has no class time to copy.
            startMinutes: event.allDay ? 8 * 60 : minutes.start,
            endMinutes: event.allDay ? 9 * 60 : minutes.end,
            type: WeeklyItemType.classSession,
            source: ItemSource.calendar,
            calendarEventId: event.eventId,
          );
        case ImportKind.exam:
        case ImportKind.activity:
          await scheduleRepo.addOneTimeItem(
            title: event.title,
            date: DateTime(
              event.start.year,
              event.start.month,
              event.start.day,
            ),
            type: item.kind == ImportKind.exam
                ? OneTimeItemType.exam
                : OneTimeItemType.activity,
            startMinutes: event.allDay ? null : minutes.start,
            endMinutes: event.allDay ? null : minutes.end,
            source: ItemSource.calendar,
            calendarEventId: event.eventId,
          );
      }
    }
  }
}
