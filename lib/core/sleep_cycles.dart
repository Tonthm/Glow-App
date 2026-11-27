/// Sleep cycles (CLAUDE.md section 20): a step after the sleep formula, which
/// it never changes. Everything here is an estimate from a model; nothing is
/// measured from the body.
library;

import 'dart:math';

import 'sleep_calculator.dart';

const int defaultCycleMinutes = 90;
const int minCycleMinutes = 70;
const int maxCycleMinutes = 100;

/// Goes wherever cycles are shown.
const String cycleDisclaimer =
    'เป็นค่าประมาณตามแบบจำลอง ไม่ใช่การวัดจากร่างกายคุณ';

int clampCycleMinutes(int minutes) =>
    minutes.clamp(minCycleMinutes, maxCycleMinutes);

double cyclesInSleep(int sleepMinutes, int cycleMinutes) =>
    max(0, sleepMinutes) / cycleMinutes;

/// Sleep the plan leaves, after the time it takes to drop off.
int plannedSleepMinutes({
  required DateTime wakeTime,
  required DateTime bedtime,
  required int fallAsleepMinutes,
}) => max(0, wakeTime.difference(bedtime).inMinutes - fallAsleepMinutes);

/// Rounds the sleep up to whole cycles by moving bedtime earlier, but only if
/// that stays within [targetMaxMinutes]; otherwise [bedtime] comes back
/// unchanged. Bedtime is never later and sleep never shorter.
DateTime alignToCycles({
  required DateTime wakeTime,
  required DateTime bedtime,
  required int fallAsleepMinutes,
  required int targetMaxMinutes,
  required int cycleMinutes,
}) {
  final sleep = plannedSleepMinutes(
    wakeTime: wakeTime,
    bedtime: bedtime,
    fallAsleepMinutes: fallAsleepMinutes,
  );
  if (sleep == 0) return bedtime;
  final whole = (sleep / cycleMinutes).ceil() * cycleMinutes;
  if (whole == sleep || whole > targetMaxMinutes) return bedtime;
  return bedtime.subtract(Duration(minutes: whole - sleep));
}

/// [alignToCycles] for each night of an already smoothed week, then the same
/// 60-minute smoothing again. That second pass only moves nights earlier and
/// stops at [targetMaxMinutes] of sleep, even if neighbors then differ by
/// more than an hour.
List<NightPlanDraft> alignWeekToCycles(
  List<NightPlanDraft> nights, {
  required int fallAsleepMinutes,
  required int targetMaxMinutes,
  required int cycleMinutes,
}) {
  final aligned = [
    for (final night in nights)
      night.copyWithBedtime(
        alignToCycles(
          wakeTime: night.wakeTime,
          bedtime: night.bedtime,
          fallAsleepMinutes: fallAsleepMinutes,
          targetMaxMinutes: targetMaxMinutes,
          cycleMinutes: cycleMinutes,
        ),
      ),
  ];
  final smoothed = smoothWeekNightPlans(aligned);
  return [
    for (var i = 0; i < aligned.length; i++)
      aligned[i].copyWithBedtime(
        _latest(
          smoothed[i].bedtime,
          _earliest(
            aligned[i].bedtime,
            aligned[i].wakeTime.subtract(
              Duration(minutes: targetMaxMinutes + fallAsleepMinutes),
            ),
          ),
        ),
      ),
  ];
}

DateTime _earliest(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

DateTime _latest(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

/// "6", or "5.7" when not whole.
String cycleCountLabel(double cycles) {
  final text = cycles.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// Why tonight starts earlier than the formula alone would say, or null.
String? cycleReason({
  required int shiftMinutes,
  required int sleepMinutes,
  required int cycleMinutes,
}) {
  if (shiftMinutes <= 0) return null;
  return sleepMinutes % cycleMinutes == 0
      ? 'เข้านอนเร็วขึ้น $shiftMinutes นาทีเพื่อให้ครบ '
            '${sleepMinutes ~/ cycleMinutes} รอบ'
      : 'เข้านอนเร็วขึ้น $shiftMinutes นาที ให้ใกล้เคียงคืนข้าง ๆ';
}

class CycleBarPart {
  final int minutes;
  final bool fallingAsleep;

  const CycleBarPart(this.minutes, {this.fallingAsleep = false});
}

/// From bedtime to wake: the time to drop off, then one part per cycle. The
/// last is shorter when the cycles don't come out whole.
List<CycleBarPart> cycleBarParts({
  required int fallAsleepMinutes,
  required int sleepMinutes,
  required int cycleMinutes,
}) => [
  if (fallAsleepMinutes > 0)
    CycleBarPart(fallAsleepMinutes, fallingAsleep: true),
  for (var left = sleepMinutes; left > 0; left -= cycleMinutes)
    CycleBarPart(min(left, cycleMinutes)),
];

/// Average cycles a night, or null with no nights.
double? averageCycles(List<int> sleepMinutes, int cycleMinutes) =>
    sleepMinutes.isEmpty
    ? null
    : cyclesInSleep(
            sleepMinutes.reduce((a, b) => a + b),
            cycleMinutes,
          ) /
          sleepMinutes.length;
