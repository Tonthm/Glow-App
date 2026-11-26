import 'package:drift/drift.dart';

import 'database.dart';
import 'evening_repository.dart';

/// `EveningTasks.status`.
const int taskTodo = 0;
const int taskDone = 1;

/// The hidden original of a split task.
const int taskSplit = 2;

const int maxStepTitleLength = 100;
const int maxStepsPerTask = 30;

/// One line of a task's checklist: a step the user added, or one part of a
/// split task.
class ChecklistItem {
  final int id;
  final String title;
  final bool done;

  /// A part is a task of its own, planned on [planDate].
  final bool isPart;
  final DateTime? planDate;
  final int? minutes;

  const ChecklistItem({
    required this.id,
    required this.title,
    required this.done,
    this.isPart = false,
    this.planDate,
    this.minutes,
  });
}

/// A task as the user thinks of it: a split one is one entry with its parts as
/// the checklist.
class TaskEntry {
  final EveningTask task;
  final List<ChecklistItem> checklist;

  const TaskEntry(this.task, this.checklist);

  bool get isSplit => task.status == taskSplit;

  bool get done => isSplit
      ? checklist.isNotEmpty && checklist.every((i) => i.done)
      : task.status == taskDone;
}

List<TaskEntry> taskEntries(List<EveningTask> tasks, List<TaskStepRow> steps) {
  return [
    for (final task in tasks)
      if (task.parentId == null)
        TaskEntry(
          task,
          task.status == taskSplit
              ? [
                  for (final part
                      in (tasks.where((t) => t.parentId == task.id).toList()
                        ..sort((a, b) => a.id.compareTo(b.id))))
                    ChecklistItem(
                      id: part.id,
                      title: part.title,
                      done: part.status == taskDone,
                      isPart: true,
                      planDate: part.planDate,
                      minutes: part.minutes,
                    ),
                ]
              : [
                  for (final step
                      in (steps.where((s) => s.taskId == task.id).toList()
                        ..sort((a, b) => a.position.compareTo(b.position))))
                    ChecklistItem(
                      id: step.id,
                      title: step.title,
                      done: step.done,
                    ),
                ],
        ),
  ];
}

/// Ticking tasks and their steps. Like the rest of the evening planner, none
/// of this earns coins or touches the fire.
class TaskListRepository {
  final AppDatabase db;

  TaskListRepository(this.db);

  Future<List<TaskEntry>> entries() async => taskEntries(
    await db.select(db.eveningTasks).get(),
    await db.select(db.taskSteps).get(),
  );

  Future<void> addStep(int taskId, String title) => db.transaction(() async {
    var clean = title.trim();
    if (clean.isEmpty) return;
    if (clean.length > maxStepTitleLength) {
      clean = clean.substring(0, maxStepTitleLength);
    }
    final existing = await (db.select(
      db.taskSteps,
    )..where((s) => s.taskId.equals(taskId))).get();
    if (existing.length >= maxStepsPerTask) return;
    final last = existing.fold(0, (m, s) => s.position > m ? s.position : m);
    await db
        .into(db.taskSteps)
        .insert(
          TaskStepsCompanion.insert(
            taskId: taskId,
            title: clean,
            position: last + 1,
          ),
        );
  });

  Future<void> removeStep(int id) =>
      (db.delete(db.taskSteps)..where((s) => s.id.equals(id))).go();

  Future<void> tick(ChecklistItem item, bool done, {required DateTime now}) {
    if (item.isPart) return setTaskDone(item.id, done, now: now);
    return (db.update(db.taskSteps)..where((s) => s.id.equals(item.id))).write(
      TaskStepsCompanion(done: Value(done)),
    );
  }

  /// For a split task, ticks or unticks all of its parts.
  Future<void> setTaskDone(int id, bool done, {required DateTime now}) {
    return db.transaction(() async {
      final task = await (db.select(
        db.eveningTasks,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (task == null) return;
      if (task.status == taskSplit) {
        final parts = await (db.select(
          db.eveningTasks,
        )..where((t) => t.parentId.equals(id))).get();
        for (final part in parts) {
          await setTaskDone(part.id, done, now: now);
        }
        return;
      }
      if ((task.status == taskDone) == done) return;
      final tonight = eveningDateFor(now);
      await db
          .update(db.eveningTasks)
          .replace(
            task.copyWith(
              status: done ? taskDone : taskTodo,
              doneMinutes: done ? task.minutes : 0,
              // Unticked work comes back to an evening still to come.
              planDate: !done && task.planDate.isBefore(tonight)
                  ? tonight
                  : task.planDate,
            ),
          );
    });
  }
}
