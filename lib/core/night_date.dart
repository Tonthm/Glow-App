/// Given [now], returns the wake date that "tonight's plan" refers to.
/// Before noon we're most likely still inside last night's cycle (asleep or
/// about to check in), so the relevant wake date is today; from noon onward
/// we're planning the upcoming night, so it's tomorrow.
DateTime resolveTonightWakeDate(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return now.hour < 12 ? today : today.add(const Duration(days: 1));
}

/// The Monday that starts the calendar week containing [date].
DateTime mondayOfWeek(DateTime date) {
  final day = DateTime(date.year, date.month, date.day);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}
