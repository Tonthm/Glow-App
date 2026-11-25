/// Travel time by weekday and a one-night prep time (CLAUDE.md sections 3
/// and 4).
library;

import 'sleep_calculator.dart';

/// "1:60,5:0" → Monday 60 minutes, Friday none. Bad entries are dropped.
Map<int, int> parseTravelOverrides(String text) {
  final result = <int, int>{};
  for (final part in text.split(',')) {
    final pieces = part.split(':');
    if (pieces.length != 2) continue;
    final weekday = int.tryParse(pieces[0]);
    final minutes = int.tryParse(pieces[1]);
    if (weekday == null || minutes == null) continue;
    if (weekday < 1 || weekday > 7 || minutes < 0) continue;
    result[weekday] = minutes;
  }
  return result;
}

String encodeTravelOverrides(Map<int, int> overrides) =>
    overrides.entries.map((e) => '${e.key}:${e.value}').join(',');

/// The settings that apply on [date].
SleepSettings settingsFor(
  SleepSettings base,
  DateTime date,
  Map<int, int> travelByWeekday, {
  int? prepOverride,
}) => SleepSettings(
  targetMinMinutes: base.targetMinMinutes,
  targetMaxMinutes: base.targetMaxMinutes,
  prepMinutes: prepOverride ?? base.prepMinutes,
  travelMinutes: travelByWeekday[date.weekday] ?? base.travelMinutes,
  bufferBeforeMinutes: base.bufferBeforeMinutes,
  fallAsleepMinutes: base.fallAsleepMinutes,
  freeDayWakeMinutes: base.freeDayWakeMinutes,
  latestWakeMinutes: base.latestWakeMinutes,
  latestBedtimeMinutes: base.latestBedtimeMinutes,
);
