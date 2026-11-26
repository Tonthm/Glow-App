/// Reminders for deadlines and before classes (CLAUDE.md section 5). The user
/// turns them on. None may land between bedtime and waking, and nothing here
/// can move the sleep plan.
library;

/// One planned night.
class SleepWindow {
  final DateTime bedtime;
  final DateTime wake;

  const SleepWindow({required this.bedtime, required this.wake});
}

/// How long before bedtime a held-back reminder is sent: the moment the plan
/// already asks to put the phone down.
const Duration _beforeBed = Duration(minutes: 60);

/// The evening hour a deadline reminder is sent, the day before.
const int deadlineReminderHour = 18;

/// The choices for how long before a class.
const List<int> beforeClassChoices = [10, 15, 30, 60];

/// [at] if it is outside every night, otherwise an earlier time: reminders are
/// only ever pulled forward. Null if that has passed, or if the nights around
/// [at] aren't known.
DateTime? clampToSleep(
  DateTime at, {
  required List<SleepWindow> nights,
  required DateTime now,
}) {
  final known = nights.any(
    (n) => n.bedtime.difference(at).abs() <= const Duration(hours: 36),
  );
  if (!known) return null;
  var result = at;
  // Pulling forward could land in an earlier night, so check again.
  var moved = true;
  while (moved) {
    moved = false;
    for (final night in nights) {
      if (result.isAfter(night.bedtime) && result.isBefore(night.wake)) {
        result = night.bedtime.subtract(_beforeBed);
        moved = true;
      }
    }
  }
  return result.isAfter(now) ? result : null;
}

class UpcomingClass {
  final String title;
  final DateTime start;

  const UpcomingClass({required this.title, required this.start});
}

/// An unfinished task with a due date.
class UpcomingDeadline {
  final String title;
  final DateTime due;

  const UpcomingDeadline({required this.title, required this.due});
}

class TaskReminder {
  /// The same for the same thing, so a calendar updates instead of repeating.
  final String uid;
  final DateTime at;
  final String title;
  final String body;

  const TaskReminder({
    required this.uid,
    required this.at,
    required this.title,
    required this.body,
  });
}

String _two(int n) => n.toString().padLeft(2, '0');

String _stamp(DateTime d) => '${d.year}${_two(d.month)}${_two(d.day)}';

/// [beforeClassMinutes] null means no class reminders.
List<TaskReminder> taskReminders({
  required List<UpcomingClass> classes,
  required List<UpcomingDeadline> deadlines,
  required List<SleepWindow> nights,
  required DateTime now,
  required int? beforeClassMinutes,
  required bool deadlinesOn,
}) {
  final result = <TaskReminder>[];

  if (beforeClassMinutes != null) {
    for (final c in classes) {
      if (!c.start.isAfter(now)) continue;
      final wanted = c.start.subtract(Duration(minutes: beforeClassMinutes));
      final at = clampToSleep(wanted, nights: nights, now: now);
      if (at == null) continue;
      final clock = '${_two(c.start.hour)}:${_two(c.start.minute)}';
      result.add(
        TaskReminder(
          uid: 'glow-class-${_stamp(c.start)}-$clock-${c.title}@glow.app',
          at: at,
          title: at == wanted
              ? 'อีก $beforeClassMinutes นาทีเริ่มคาบ ${c.title}'
              : 'คาบ ${c.title} เริ่ม $clock',
          body: 'เริ่ม $clock',
        ),
      );
    }
  }

  if (deadlinesOn) {
    final byDay = <DateTime, List<String>>{};
    for (final d in deadlines) {
      byDay
          .putIfAbsent(
            DateTime(d.due.year, d.due.month, d.due.day),
            () => [],
          )
          .add(d.title);
    }
    for (final MapEntry(key: due, value: titles) in byDay.entries) {
      final wanted = DateTime(
        due.year,
        due.month,
        due.day - 1,
        deadlineReminderHour,
      );
      final at = clampToSleep(wanted, nights: nights, now: now);
      if (at == null) continue;
      titles.sort();
      result.add(
        TaskReminder(
          uid: 'glow-due-${_stamp(due)}@glow.app',
          at: at,
          title: titles.length == 1
              ? 'พรุ่งนี้มีงานต้องส่ง'
              : 'พรุ่งนี้มีงานต้องส่ง ${titles.length} งาน',
          body: titles.join(', '),
        ),
      );
    }
  }

  result.sort((a, b) => a.at.compareTo(b.at));
  return result;
}
