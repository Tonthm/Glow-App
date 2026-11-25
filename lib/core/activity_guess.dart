/// Pre-selects the "วันนี้ทำอะไรมาบ้าง" chips from the day's schedule
/// (CLAUDE.md section 13).
library;

import 'routine_config.dart';
import 'schedule_models.dart';

const int _sittingClassMinutes = 3 * 60;
const int _quietDayCardHour = 16;

Set<DayActivityKind> guessActivities(List<ScheduleEntry> day) {
  final result = <DayActivityKind>{};
  var classMinutes = 0;
  for (final entry in day) {
    if (entry.kind == ItemKind.classSession) {
      classMinutes += entry.end.difference(entry.start).inMinutes;
    }
    final title = entry.title.toLowerCase();
    for (final rule in activityKeywords.entries) {
      if (rule.value.any(title.contains)) result.add(rule.key);
    }
  }
  if (classMinutes >= _sittingClassMinutes) {
    result.add(DayActivityKind.sitting);
  }
  return result;
}

/// The card appears once the day's last appointment ends, or at 16:00 on a
/// day with nothing scheduled.
DateTime activityCardFrom(DateTime day, List<ScheduleEntry> entries) {
  if (entries.isEmpty) {
    return DateTime(day.year, day.month, day.day, _quietDayCardHour);
  }
  return entries.map((e) => e.end).reduce((a, b) => a.isAfter(b) ? a : b);
}
