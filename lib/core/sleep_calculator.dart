import 'schedule_models.dart';

/// Fixed buffer used instead of [SleepSettings.bufferBeforeMinutes] when the
/// day's first appointment is an exam (CLAUDE.md section 4: "เผื่อถึงห้องสอบ
/// ก่อน 30 นาที").
const int examBufferBeforeMinutes = 30;

/// All user-tunable values from CLAUDE.md section 3, as plain minutes
/// since midnight (or plain minute durations). Kept free of drift/Flutter
/// imports so this stays testable with fixed inputs.
class SleepSettings {
  final int targetMinMinutes;
  final int targetMaxMinutes;
  final int prepMinutes;
  final int travelMinutes;
  final int bufferBeforeMinutes;
  final int fallAsleepMinutes;
  final int freeDayWakeMinutes;
  final int latestWakeMinutes;
  final int latestBedtimeMinutes;

  const SleepSettings({
    required this.targetMinMinutes,
    required this.targetMaxMinutes,
    this.prepMinutes = 45,
    this.travelMinutes = 30,
    this.bufferBeforeMinutes = 10,
    this.fallAsleepMinutes = 15,
    this.freeDayWakeMinutes = 7 * 60 + 30,
    this.latestWakeMinutes = 8 * 60,
    this.latestBedtimeMinutes = 23 * 60 + 30,
  });

  int get midpointTargetMinutes => (targetMinMinutes + targetMaxMinutes) ~/ 2;
}

class WakeCalcResult {
  final DateTime wakeTime;
  final bool wasCapped;
  final bool isPreExamNight;

  const WakeCalcResult({
    required this.wakeTime,
    required this.wasCapped,
    required this.isPreExamNight,
  });
}

class BedtimeCalcResult {
  final DateTime bedtime;
  final bool wasCapped;

  const BedtimeCalcResult({required this.bedtime, required this.wasCapped});
}

/// One night's full plan: wake date, computed wake/bedtime, and the flags
/// needed to display/notify (steps 1-6, before weekly smoothing).
class NightPlanDraft {
  final DateTime wakeDate;
  final DateTime wakeTime;
  final DateTime bedtime;
  final bool wakeWasCapped;
  final bool bedtimeWasCapped;
  final bool isPreExamNight;

  const NightPlanDraft({
    required this.wakeDate,
    required this.wakeTime,
    required this.bedtime,
    required this.wakeWasCapped,
    required this.bedtimeWasCapped,
    required this.isPreExamNight,
  });

  NightPlanDraft copyWithBedtime(DateTime newBedtime) => NightPlanDraft(
    wakeDate: wakeDate,
    wakeTime: wakeTime,
    bedtime: newBedtime,
    wakeWasCapped: wakeWasCapped,
    bedtimeWasCapped: bedtimeWasCapped,
    isPreExamNight: isPreExamNight,
  );
}

/// Steps 1-4: find wake time for [wakeDate] given that date's resolved
/// appointments ([entriesForWakeDate], already holiday/override-resolved).
WakeCalcResult calculateWakeTime({
  required DateTime wakeDate,
  required SleepSettings settings,
  required List<ScheduleEntry> entriesForWakeDate,
}) {
  final appointments = entriesForWakeDate.toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  final firstAppointment = appointments.isEmpty ? null : appointments.first;
  final isPreExamNight = appointments.any((e) => e.kind == ItemKind.exam);

  DateTime wake;
  if (firstAppointment != null) {
    final buffer = firstAppointment.kind == ItemKind.exam
        ? examBufferBeforeMinutes
        : settings.bufferBeforeMinutes;
    final leaveHome = firstAppointment.start.subtract(
      Duration(minutes: buffer + settings.travelMinutes),
    );
    wake = leaveHome.subtract(Duration(minutes: settings.prepMinutes));
  } else {
    wake = _atMinutes(wakeDate, settings.freeDayWakeMinutes);
  }

  final latestWake = _atMinutes(wakeDate, settings.latestWakeMinutes);
  var wasCapped = false;
  if (wake.isAfter(latestWake)) {
    wake = latestWake;
    wasCapped = true;
  }

  return WakeCalcResult(
    wakeTime: wake,
    wasCapped: wasCapped,
    isPreExamNight: isPreExamNight,
  );
}

/// Steps 5-6: bedtime for the night that ends by waking at [wakeTime].
/// [isPreExamNight] uses the midpoint target instead of min+30 (section 4).
BedtimeCalcResult calculateBedtime({
  required DateTime wakeTime,
  required SleepSettings settings,
  required bool isPreExamNight,
}) {
  final sleepBudgetMinutes = isPreExamNight
      ? settings.midpointTargetMinutes
      : settings.targetMinMinutes + 30;
  var bedtime = wakeTime.subtract(
    Duration(minutes: sleepBudgetMinutes + settings.fallAsleepMinutes),
  );

  final eveningAnchor = DateTime(
    wakeTime.year,
    wakeTime.month,
    wakeTime.day,
  ).subtract(const Duration(days: 1));
  // A latestBedtimeMinutes before noon means "after midnight" (e.g. 01:00),
  // which belongs to the wake date, not the evening anchor — continue the
  // same before/after-midnight scale used for weekly smoothing so the cap
  // doesn't land a full day too early.
  final latestBedtimeContinuousMinutes = settings.latestBedtimeMinutes < 12 * 60
      ? settings.latestBedtimeMinutes + 24 * 60
      : settings.latestBedtimeMinutes;
  final latestBedtime = eveningAnchor.add(
    Duration(minutes: latestBedtimeContinuousMinutes),
  );

  var wasCapped = false;
  if (bedtime.isAfter(latestBedtime)) {
    bedtime = latestBedtime;
    wasCapped = true;
  }

  return BedtimeCalcResult(bedtime: bedtime, wasCapped: wasCapped);
}

/// Steps 1-6 combined for a single night.
NightPlanDraft calculateNightPlanDraft({
  required DateTime wakeDate,
  required SleepSettings settings,
  required List<ScheduleEntry> entriesForWakeDate,
}) {
  final wakeResult = calculateWakeTime(
    wakeDate: wakeDate,
    settings: settings,
    entriesForWakeDate: entriesForWakeDate,
  );
  final bedtimeResult = calculateBedtime(
    wakeTime: wakeResult.wakeTime,
    settings: settings,
    isPreExamNight: wakeResult.isPreExamNight,
  );
  return NightPlanDraft(
    wakeDate: wakeDate,
    wakeTime: wakeResult.wakeTime,
    bedtime: bedtimeResult.bedtime,
    wakeWasCapped: wakeResult.wasCapped,
    bedtimeWasCapped: bedtimeResult.wasCapped,
    isPreExamNight: wakeResult.isPreExamNight,
  );
}

/// Step 7: smooth a week's bedtimes so no night is more than 60 minutes
/// later than its neighbor, by moving the later night earlier — never later.
/// Every night in the week is included, even nights with no schoolwork.
List<NightPlanDraft> smoothWeekNightPlans(List<NightPlanDraft> nights) {
  if (nights.length < 2) return nights;

  final minutes = nights.map(_continuousEveningMinutes).toList();

  for (var i = nights.length - 2; i >= 0; i--) {
    if (minutes[i] - minutes[i + 1] > 60) {
      minutes[i] = minutes[i + 1] + 60;
    }
  }
  for (var i = 1; i < nights.length; i++) {
    if (minutes[i] - minutes[i - 1] > 60) {
      minutes[i] = minutes[i - 1] + 60;
    }
  }

  return List.generate(nights.length, (i) {
    final night = nights[i];
    final eveningAnchor = DateTime(
      night.wakeDate.year,
      night.wakeDate.month,
      night.wakeDate.day,
    ).subtract(const Duration(days: 1));
    final adjustedBedtime = eveningAnchor.add(Duration(minutes: minutes[i]));
    return night.copyWithBedtime(adjustedBedtime);
  });
}

/// Minutes since midnight of [night]'s evening-before anchor date, used so
/// consecutive nights' bedtimes compare on the same "how late is bedtime"
/// scale regardless of whether a bedtime rolled past midnight.
int _continuousEveningMinutes(NightPlanDraft night) {
  final eveningAnchor = DateTime(
    night.wakeDate.year,
    night.wakeDate.month,
    night.wakeDate.day,
  ).subtract(const Duration(days: 1));
  return night.bedtime.difference(eveningAnchor).inMinutes;
}

DateTime _atMinutes(DateTime day, int minutes) =>
    DateTime(day.year, day.month, day.day).add(Duration(minutes: minutes));
