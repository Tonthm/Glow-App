/// Pure Dart models shared by core/ logic. No Flutter or drift imports here —
/// the data layer maps drift rows onto these before calling into core/.
library;

enum ItemKind { classSession, exam, activity, holiday }

/// A recurring weekly item, active only within [termStart]..[termEnd].
class WeeklyEntry {
  final String title;
  final int dayOfWeek; // 1 = Monday .. 7 = Sunday
  final int startMinutes;
  final int endMinutes;
  final ItemKind kind; // classSession or activity

  const WeeklyEntry({
    required this.title,
    required this.dayOfWeek,
    required this.startMinutes,
    required this.endMinutes,
    required this.kind,
  });
}

/// A one-off item on a specific date. [startMinutes]/[endMinutes] are null
/// for holidays, which only cancel that day's classes.
class OneTimeEntry {
  final String title;
  final DateTime date;
  final int? startMinutes;
  final int? endMinutes;
  final ItemKind kind; // exam, activity, or holiday

  const OneTimeEntry({
    required this.title,
    required this.date,
    required this.kind,
    this.startMinutes,
    this.endMinutes,
  });
}

/// A resolved, concrete appointment on one calendar date, with absolute
/// start/end times. Produced by resolveScheduleForDate.
class ScheduleEntry {
  final String title;
  final ItemKind kind;
  final DateTime start;
  final DateTime end;

  const ScheduleEntry({
    required this.title,
    required this.kind,
    required this.start,
    required this.end,
  });
}
