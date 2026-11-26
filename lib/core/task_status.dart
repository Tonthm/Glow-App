/// Where a task stands (CLAUDE.md section 14).
library;

/// The three filters of the task list.
enum TaskState { doing, missed, done }

/// Missed means not finished and the due day is over. A task with no due date
/// is never missed.
TaskState taskState({
  required bool done,
  required DateTime? due,
  required DateTime now,
}) {
  if (done) return TaskState.done;
  if (due == null) return TaskState.doing;
  final today = DateTime(now.year, now.month, now.day);
  return DateTime(due.year, due.month, due.day).isBefore(today)
      ? TaskState.missed
      : TaskState.doing;
}

/// Ticked steps out of all of them.
(int, int) stepProgress(List<bool> steps) =>
    (steps.where((done) => done).length, steps.length);
