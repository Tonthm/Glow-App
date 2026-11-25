/// Pure rules for importing phone-calendar events (CLAUDE.md section 2).
library;

const _examKeywords = ['สอบ', 'exam', 'midterm', 'final'];

enum ImportKind { classSession, exam, activity }

/// One occurrence of a calendar event, with local date-times.
class CalendarEvent {
  final String eventId;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool allDay;
  final bool repeatsWeekly;

  const CalendarEvent({
    required this.eventId,
    required this.title,
    required this.start,
    required this.end,
    required this.allDay,
    required this.repeatsWeekly,
  });
}

ImportKind guessEventKind(CalendarEvent event) {
  final title = event.title.toLowerCase();
  if (_examKeywords.any(title.contains)) return ImportKind.exam;
  return event.repeatsWeekly ? ImportKind.classSession : ImportKind.activity;
}

/// The phone reports every occurrence of a repeating event separately. A
/// weekly series becomes one row per weekday and time slot, so importing a
/// term doesn't create the same class dozens of times.
List<CalendarEvent> collapseWeeklyRepeats(List<CalendarEvent> events) {
  final seen = <String>{};
  return [
    for (final e in events)
      if (!e.repeatsWeekly ||
          seen.add(
            '${e.eventId}|${e.start.weekday}|${e.start.hour}:${e.start.minute}',
          ))
        e,
  ];
}

/// Start and end as minutes since midnight of the start date. Schedule items
/// live within one day, so anything running past midnight stops at 23:59.
({int start, int end}) importMinutes(CalendarEvent event) {
  final start = event.start.hour * 60 + event.start.minute;
  final sameDay =
      event.end.year == event.start.year &&
      event.end.month == event.start.month &&
      event.end.day == event.start.day;
  final end = sameDay ? event.end.hour * 60 + event.end.minute : 23 * 60 + 59;
  return (start: start, end: end);
}
