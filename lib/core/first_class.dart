/// The earliest class time asked at the start (CLAUDE.md section 3). It stands
/// in for a timetable that has no classes yet; the sleep formula itself is
/// unchanged.
library;

import 'schedule_models.dart';

const String earliestClassTitle = 'เรียนเช้าสุด (ที่บอกไว้)';

/// [weekly] as it is, unless it has no class at all and [earliestMinutes] was
/// given: then Monday to Friday get a class starting at that time. Nothing is
/// saved to the timetable.
List<WeeklyEntry> withEarliestClass(
  List<WeeklyEntry> weekly,
  int? earliestMinutes,
) {
  if (earliestMinutes == null ||
      weekly.any((e) => e.kind == ItemKind.classSession)) {
    return weekly;
  }
  return [
    ...weekly,
    for (var day = DateTime.monday; day <= DateTime.friday; day++)
      WeeklyEntry(
        title: earliestClassTitle,
        dayOfWeek: day,
        startMinutes: earliestMinutes,
        endMinutes: earliestMinutes + 60,
        kind: ItemKind.classSession,
      ),
  ];
}
