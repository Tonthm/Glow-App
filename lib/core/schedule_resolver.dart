import 'schedule_models.dart';

/// Resolves which concrete appointments fall on [date], applying CLAUDE.md
/// section 2 rules:
/// - a weekly item only applies within [termStart]..[termEnd] and on its
///   weekday
/// - a holiday on [date] cancels that date's weekly class sessions
/// - a one-time item that overlaps a weekly item's time range wins over it
///   (e.g. an exam replacing that week's class slot)
///
/// Holidays themselves are not returned as entries — they have no time and
/// are not appointments, only cancellation triggers.
List<ScheduleEntry> resolveScheduleForDate({
  required DateTime date,
  required List<WeeklyEntry> weeklyEntries,
  required List<OneTimeEntry> oneTimeEntries,
  DateTime? termStart,
  DateTime? termEnd,
}) {
  final day = DateTime(date.year, date.month, date.day);
  final weekday = day.weekday; // 1 = Monday .. 7 = Sunday, matches our schema

  final sameDayOneTime = oneTimeEntries.where((e) {
    final d = e.date;
    return d.year == day.year && d.month == day.month && d.day == day.day;
  }).toList();

  final isHoliday = sameDayOneTime.any((e) => e.kind == ItemKind.holiday);

  final activeWeekly = weeklyEntries.where((w) {
    if (w.dayOfWeek != weekday) return false;
    if (termStart != null && day.isBefore(_dateOnly(termStart))) return false;
    if (termEnd != null && day.isAfter(_dateOnly(termEnd))) return false;
    if (isHoliday && w.kind == ItemKind.classSession) return false;
    return true;
  }).toList();

  final weeklyAsEntries = activeWeekly
      .map(
        (w) => ScheduleEntry(
          title: w.title,
          kind: w.kind,
          start: _atMinutes(day, w.startMinutes),
          end: _atMinutes(day, w.endMinutes),
        ),
      )
      .toList();

  final result = <ScheduleEntry>[];
  for (final weekly in weeklyAsEntries) {
    final overridden = sameDayOneTime.any((oneTime) {
      if (oneTime.kind == ItemKind.holiday) return false;
      if (oneTime.startMinutes == null || oneTime.endMinutes == null) {
        return false;
      }
      final oneTimeStart = _atMinutes(day, oneTime.startMinutes!);
      final oneTimeEnd = _atMinutes(day, oneTime.endMinutes!);
      return weekly.start.isBefore(oneTimeEnd) &&
          oneTimeStart.isBefore(weekly.end);
    });
    if (!overridden) result.add(weekly);
  }

  for (final oneTime in sameDayOneTime) {
    if (oneTime.kind == ItemKind.holiday) continue;
    if (oneTime.startMinutes == null || oneTime.endMinutes == null) continue;
    result.add(
      ScheduleEntry(
        title: oneTime.title,
        kind: oneTime.kind,
        start: _atMinutes(day, oneTime.startMinutes!),
        end: _atMinutes(day, oneTime.endMinutes!),
      ),
    );
  }

  result.sort((a, b) => a.start.compareTo(b.start));
  return result;
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _atMinutes(DateTime day, int minutes) =>
    DateTime(day.year, day.month, day.day).add(Duration(minutes: minutes));
