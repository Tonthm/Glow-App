import '../core/schedule_models.dart';
import '../core/task_reminders.dart';
import 'database.dart';
import 'night_planning_repository.dart';
import 'task_list_repository.dart';

/// Tonight and the 7 nights after it, as for the sleep reminders.
const int _daysAhead = 7;

/// The deadline and class reminders the user has switched on, already held
/// back from every night (core/task_reminders). Both Android's notifications
/// and the web calendar file use this.
Future<List<TaskReminder>> upcomingTaskReminders({
  required NightPlanningRepository planning,
  required SettingsRow settings,
  required DateTime now,
}) async {
  if (!settings.notifyDeadline && !settings.notifyBeforeClass) return const [];
  final today = DateTime(now.year, now.month, now.day);
  DateTime day(int ahead) =>
      DateTime(today.year, today.month, today.day + ahead);

  final nights = <SleepWindow>[];
  // From last night to one past the end, so every reminder has neighbors.
  for (var ahead = 0; ahead <= _daysAhead + 2; ahead++) {
    final plan = await planning.currentPlan(day(ahead));
    nights.add(SleepWindow(bedtime: plan.bedtime, wake: plan.wakeTime));
  }

  final classes = <UpcomingClass>[];
  if (settings.notifyBeforeClass) {
    for (var ahead = 0; ahead <= _daysAhead; ahead++) {
      for (final entry in await planning.entriesOn(day(ahead))) {
        if (entry.kind != ItemKind.classSession) continue;
        classes.add(UpcomingClass(title: entry.title, start: entry.start));
      }
    }
  }

  final deadlines = <UpcomingDeadline>[
    if (settings.notifyDeadline)
      for (final entry in await TaskListRepository(planning.db).entries())
        if (!entry.done &&
            entry.task.dueDate != null &&
            !entry.task.dueDate!.isAfter(day(_daysAhead + 1)))
          UpcomingDeadline(title: entry.task.title, due: entry.task.dueDate!),
  ];

  return taskReminders(
    classes: classes,
    deadlines: deadlines,
    nights: nights,
    now: now,
    beforeClassMinutes: settings.notifyBeforeClass
        ? settings.beforeClassMinutes
        : null,
    deadlinesOn: settings.notifyDeadline,
  );
}
