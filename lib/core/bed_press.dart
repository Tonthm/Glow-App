/// Rules for the "เข้านอนแล้ว" button (CLAUDE.md section 6).
library;

const Duration _windowBeforeNotify = Duration(hours: 2);
const Duration _windowBeforeWake = Duration(hours: 2);
const Duration undoWindow = Duration(minutes: 15);

DateTime bedPressWindowStart(DateTime notifyTime) =>
    notifyTime.subtract(_windowBeforeNotify);

DateTime bedPressWindowEnd(DateTime plannedWakeTime) =>
    plannedWakeTime.subtract(_windowBeforeWake);

/// From 2 hours before the put-the-phone-down reminder until 2 hours before
/// the planned wake time. Pressing later than planned is always allowed.
bool canPressInBed({
  required DateTime now,
  required DateTime notifyTime,
  required DateTime plannedWakeTime,
}) =>
    !now.isBefore(bedPressWindowStart(notifyTime)) &&
    !now.isAfter(bedPressWindowEnd(plannedWakeTime));

/// "ยังไม่นอน" is offered for 15 minutes after pressing.
bool canUndoInBed({required DateTime pressedAt, required DateTime now}) {
  final since = now.difference(pressedAt);
  return !since.isNegative && since <= undoWindow;
}

/// Where a night's lights-off time came from.
enum LightsOffSource { button, plan, edited }
