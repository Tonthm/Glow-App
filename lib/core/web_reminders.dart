/// When the web version should nudge the user about calendar reminders and
/// backups (CLAUDE.md section 17).
library;

import 'ics_builder.dart';

const Duration _runningOutWithin = Duration(days: 2);
const Duration _backupEvery = Duration(days: 7);

enum CalendarReminderStatus {
  /// Never added to the calendar.
  neverAdded,
  upToDate,

  /// The plan moved after the reminders were added.
  planChanged,

  /// Less than two days of reminders are left.
  runningOut,
}

/// What was put in the calendar, by event id.
Map<String, DateTime> exportedStarts(List<IcsEvent> events) => {
  for (final e in events) e.uid: e.start,
};

/// [exported] is what was added last time, [coveredUntil] the last of those
/// events, and [current] what would be added now.
CalendarReminderStatus calendarReminderStatus({
  required Map<String, DateTime> exported,
  required DateTime? coveredUntil,
  required List<IcsEvent> current,
  required DateTime now,
}) {
  if (coveredUntil == null) return CalendarReminderStatus.neverAdded;
  final expected = {
    for (final e in current)
      if (!e.start.isAfter(coveredUntil)) e.uid: e.start,
  };
  for (final entry in exported.entries) {
    if (!entry.value.isAfter(now)) continue;
    final start = expected[entry.key];
    if (start == null || !start.isAtSameMomentAs(entry.value)) {
      return CalendarReminderStatus.planChanged;
    }
  }
  // A reminder that belongs in the covered days but was never added.
  for (final uid in expected.keys) {
    if (!exported.containsKey(uid)) return CalendarReminderStatus.planChanged;
  }
  return coveredUntil.difference(now) < _runningOutWithin
      ? CalendarReminderStatus.runningOut
      : CalendarReminderStatus.upToDate;
}

/// True after more than 7 days without a backup, counted from [startedAt]
/// if there has never been one.
bool isBackupOverdue({
  required DateTime? lastBackupAt,
  required DateTime? startedAt,
  required DateTime now,
}) {
  final since = lastBackupAt ?? startedAt;
  return since != null && now.difference(since) > _backupEvery;
}
