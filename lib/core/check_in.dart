import 'sleep_calculator.dart';

/// Morning check-in result bucket, per CLAUDE.md section 6. "ครบ+ตรงเวลา" is
/// not a separate bucket here — it's [CheckInResult.enough] plus the
/// separate [CheckInOutcome.onTime] flag, since on-time is tracked
/// independently of how many hours were slept.
enum CheckInResult { enough, almostEnough, notEnough, over }

class CheckInOutcome {
  final CheckInResult result;
  final bool onTime;
  final Duration sleepDuration;

  const CheckInOutcome({
    required this.result,
    required this.onTime,
    required this.sleepDuration,
  });
}

const int _onTimeToleranceMinutes = 45;

/// Classifies a morning check-in, per CLAUDE.md section 6:
/// - ชั่วโมงนอน = ตื่น − ปิดไฟ − เวลากว่าจะหลับ
/// - ตรงเวลา = ปิดไฟห่างจากแผนไม่เกิน ±45 นาที
/// - ครบ: within [min, max]; เกิน: > max; เกือบครบ: short of min by <= 60
///   min; ไม่ครบ: short of min by > 60 min.
CheckInOutcome classifyCheckIn({
  required DateTime lightsOffAt,
  required DateTime actualWakeAt,
  required DateTime plannedBedtime,
  required SleepSettings settings,
}) {
  final sleepDuration = actualSleepDuration(
    lightsOffAt: lightsOffAt,
    wakeAt: actualWakeAt,
    fallAsleepMinutes: settings.fallAsleepMinutes,
  );
  final sleepMinutes = sleepDuration.inMinutes;

  final CheckInResult result;
  if (sleepMinutes > settings.targetMaxMinutes) {
    result = CheckInResult.over;
  } else if (sleepMinutes >= settings.targetMinMinutes) {
    result = CheckInResult.enough;
  } else if (settings.targetMinMinutes - sleepMinutes <= 60) {
    result = CheckInResult.almostEnough;
  } else {
    result = CheckInResult.notEnough;
  }

  final onTime =
      lightsOffAt.difference(plannedBedtime).inMinutes.abs() <=
      _onTimeToleranceMinutes;

  return CheckInOutcome(
    result: result,
    onTime: onTime,
    sleepDuration: sleepDuration,
  );
}

/// First moment [wakeDate]'s night can be checked in, per section 6:
/// "ตื่นตามแผน − 2 ชม.".
DateTime checkInWindowStart(DateTime plannedWakeTime) =>
    plannedWakeTime.subtract(const Duration(hours: 2));

/// Last moment [wakeDate]'s night can still be checked in, per section 6:
/// "จนถึง 14:00 ของวันถัดไป" (วันถัดไปจากวันที่ตื่น).
DateTime checkInWindowEnd(DateTime wakeDate) {
  final nextDay = DateTime(wakeDate.year, wakeDate.month, wakeDate.day + 1);
  return nextDay.add(const Duration(hours: 14));
}

/// Whether [now] still falls inside the check-in window for a night whose
/// planned wake time is [plannedWakeTime]. Past the window, the night counts
/// as "ไม่มีข้อมูล" (section 6).
bool isCheckInWindowOpen({
  required DateTime plannedWakeTime,
  required DateTime now,
}) {
  final start = checkInWindowStart(plannedWakeTime);
  final end = checkInWindowEnd(
    DateTime(plannedWakeTime.year, plannedWakeTime.month, plannedWakeTime.day),
  );
  return !now.isBefore(start) && !now.isAfter(end);
}

/// ชั่วโมงนอน = ตื่น − ปิดไฟ − เวลากว่าจะหลับ (section 6). Every place that
/// shows "hours slept" must use this so the numbers agree.
Duration actualSleepDuration({
  required DateTime lightsOffAt,
  required DateTime wakeAt,
  required int fallAsleepMinutes,
}) {
  final slept =
      wakeAt.difference(lightsOffAt) - Duration(minutes: fallAsleepMinutes);
  return slept.isNegative ? Duration.zero : slept;
}

/// Turns the two clock times picked on the "แก้เวลา" wheels into full
/// date-times for the night that ends on [wakeDate]. A lights-off from noon
/// onward is the evening before; one before noon is after midnight, i.e.
/// already on the wake date.
({DateTime lightsOffAt, DateTime wakeAt}) resolveCheckInTimes({
  required DateTime wakeDate,
  required int lightsOffHour,
  required int lightsOffMinute,
  required int wakeHour,
  required int wakeMinute,
}) {
  final lightsOffDay = lightsOffHour >= 12 ? wakeDate.day - 1 : wakeDate.day;
  return (
    lightsOffAt: DateTime(
      wakeDate.year,
      wakeDate.month,
      lightsOffDay,
      lightsOffHour,
      lightsOffMinute,
    ),
    wakeAt: DateTime(
      wakeDate.year,
      wakeDate.month,
      wakeDate.day,
      wakeHour,
      wakeMinute,
    ),
  );
}
