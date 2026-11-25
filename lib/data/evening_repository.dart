import 'package:drift/drift.dart';

import '../core/evening_planner.dart';
import '../core/schedule_load.dart';
import '../core/schedule_models.dart';
import 'database.dart';
import 'night_planning_repository.dart';
import 'settings_repository.dart';

const int _todo = 0;
const int _done = 1;

/// The evening being planned at [now]. Before 04:00 it is still last night's.
DateTime eveningDateFor(DateTime now) {
  final day = now.hour < 4 ? now.day - 1 : now.day;
  return DateTime(now.year, now.month, day);
}

DateTime _addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

/// Everything the evening screens show.
class EveningView {
  final DateTime eveningDate;
  final EveningPlan plan;

  /// Tonight's unfinished tasks in planning order.
  final List<EveningTask> tasks;
  final List<EveningTask> doneTasks;
  final bool redNight;

  /// No class today and the evening hasn't been started early.
  final bool canStartNow;
  final List<StudySuggestion> suggestions;
  final DateTime notifyTime;

  const EveningView({
    required this.eveningDate,
    required this.plan,
    required this.tasks,
    required this.doneTasks,
    required this.redNight,
    required this.canStartNow,
    required this.suggestions,
    required this.notifyTime,
  });

  EveningTask? taskById(int id) {
    for (final task in tasks) {
      if (task.id == id) return task;
    }
    return null;
  }
}

/// Tonight's tasks (CLAUDE.md section 14). No coins, quests, or fire: this
/// only helps the user get to bed on plan.
class EveningRepository {
  final AppDatabase db;
  final NightPlanningRepository planning;
  final SettingsRepository settingsRepo;

  EveningRepository(this.db, this.planning, this.settingsRepo);

  static PlannerTask _toPlanner(EveningTask row) => PlannerTask(
    id: row.id,
    title: row.title,
    minutes: row.minutes - row.doneMinutes,
    due: row.dueDate,
    kind: EveningTaskKind.values[row.kind],
    examDate: row.examDate,
    userOrder: row.userOrder,
  );

  Future<List<EveningTask>> _tasksFor(DateTime eveningDate, int status) {
    return (db.select(db.eveningTasks)
          ..where(
            (t) => t.planDate.equals(eveningDate) & t.status.equals(status),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  Future<EveningView> load(DateTime now) async {
    await carryOverLockedTasks(now);
    final eveningDate = eveningDateFor(now);
    final wakeDate = _addDays(eveningDate, 1);
    final row = await settingsRepo.get();
    final draft = await planning.currentPlan(wakeDate);
    final entries = await planning.entriesOn(eveningDate);
    final load = await planning.computeEveningLoad(draft);
    final planRow = await planning.getPlanRow(wakeDate);
    final redNight = load.level == EveningLoadLevel.red;
    final notifyTime = NightPlanningRepository.notifyTimeOf(draft);

    final windowStart = eveningWindowStart(
      eveningDate,
      entries,
      travelMinutes: row.defaultTravelMinutes,
      startNow: planRow?.eveningStartedAt,
    );
    final rows = await _tasksFor(eveningDate, _todo);
    final plannerTasks = rows.map(_toPlanner).toList();
    final plan = planEvening(
      windowStart: windowStart,
      notifyTime: notifyTime,
      fixedActivities: [
        for (final e in entries)
          if (e.kind == ItemKind.activity) e,
      ],
      tasks: plannerTasks,
      settings: toEveningSettings(row),
      eveningDate: eveningDate,
      redNight: redNight,
      tasksFrom: planRow?.eveningFrom,
    );

    final done = await _tasksFor(eveningDate, _done);
    final byId = {for (final r in rows) r.id: r};
    final ordered = [
      for (final t in orderTasks(plannerTasks, eveningDate)) byId[t.id]!,
    ];

    final upcomingExams =
        await (db.select(db.oneTimeItems)..where(
              (t) =>
                  t.type.equalsValue(OneTimeItemType.exam) &
                  t.date.isBiggerOrEqualValue(eveningDate),
            ))
            .get();
    final classOnDate = entries.any((e) => e.kind != ItemKind.activity);

    return EveningView(
      eveningDate: eveningDate,
      plan: plan,
      tasks: ordered,
      doneTasks: done,
      redNight: redNight,
      canStartNow:
          !classOnDate &&
          planRow?.eveningStartedAt == null &&
          now.isBefore(windowStart),
      suggestions: suggestStudy(
        eveningDate: eveningDate,
        exams: [
          for (final e in upcomingExams)
            StudyExam(title: e.title, date: e.date),
        ],
        alreadyPlannedExamDates: {
          for (final t in [...rows, ...done])
            if (t.examDate != null) t.examDate!,
        },
        eveningIsFull:
            redNight || plan.overflow.isNotEmpty || !now.isBefore(plan.end),
      ),
      notifyTime: notifyTime,
    );
  }

  Future<int> addTask({
    required String title,
    required int minutes,
    required EveningTaskKind kind,
    required DateTime planDate,
    DateTime? dueDate,
    DateTime? examDate,
    ItemSource source = ItemSource.typed,
    bool suggested = false,
  }) {
    return db
        .into(db.eveningTasks)
        .insert(
          EveningTasksCompanion.insert(
            title: title,
            minutes: minutes,
            kind: kind.index,
            planDate: planDate,
            dueDate: Value(dueDate),
            examDate: Value(examDate),
            source: Value(source),
            suggested: Value(suggested),
          ),
        );
  }

  Future<void> updateTask(EveningTask task) =>
      db.update(db.eveningTasks).replace(task);

  Future<void> removeTask(int id) =>
      (db.delete(db.eveningTasks)..where((t) => t.id.equals(id))).go();

  Future<EveningTask?> _task(int id) => (db.select(
    db.eveningTasks,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  /// "เลื่อนไปพรุ่งนี้".
  Future<void> postpone(int id) async {
    final task = await _task(id);
    if (task == null) return;
    await updateTask(
      task.copyWith(
        planDate: _addDays(task.planDate, 1),
        carried: true,
        userOrder: const Value(null),
      ),
    );
  }

  /// "เสร็จ" on one block. The next blocks move up to [now].
  Future<void> finishBlock(int taskId, int blockMinutes, DateTime now) {
    return db.transaction(() async {
      final task = await _task(taskId);
      if (task == null) return;
      final doneMinutes = task.doneMinutes + blockMinutes;
      await updateTask(
        task.copyWith(
          doneMinutes: doneMinutes,
          status: doneMinutes >= task.minutes ? _done : _todo,
        ),
      );
      await replanFrom(now);
    });
  }

  /// "จัดใหม่": lay out what's left starting now.
  Future<void> replanFrom(DateTime now) =>
      planning.setEveningFrom(_addDays(eveningDateFor(now), 1), now);

  /// "เริ่มตอนนี้" on a day with no classes.
  Future<void> startNow(DateTime now) =>
      planning.setEveningStartedAt(_addDays(eveningDateFor(now), 1), now);

  /// Moves a task up (-1) or down (+1) and keeps that order from then on.
  Future<void> move(List<EveningTask> ordered, int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= ordered.length) return Future.value();
    final list = ordered.toList();
    final moved = list.removeAt(index);
    list.insert(target, moved);
    return db.transaction(() async {
      for (var i = 0; i < list.length; i++) {
        await updateTask(list[i].copyWith(userOrder: Value(i + 1)));
      }
    });
  }

  /// Once an evening's plan locks (the put-the-phone-down time), unfinished
  /// tasks move to the next day by themselves, so nothing asks the user to
  /// pick the phone up again.
  Future<void> carryOverLockedTasks(DateTime now) {
    return db.transaction(() async {
      final today = eveningDateFor(now);
      final open =
          await (db.select(db.eveningTasks)..where(
                (t) =>
                    t.status.equals(_todo) &
                    t.planDate.isSmallerOrEqualValue(today),
              ))
              .get();
      final locked = <DateTime, bool>{};
      for (final task in open) {
        var date = task.planDate;
        while (!date.isAfter(today)) {
          if (date == today) {
            final isLocked = locked[date] ??= !now.isBefore(
              NightPlanningRepository.notifyTimeOf(
                await planning.currentPlan(_addDays(date, 1)),
              ),
            );
            if (!isLocked) break;
          }
          date = _addDays(date, 1);
        }
        if (date != task.planDate) {
          await updateTask(
            task.copyWith(
              planDate: date,
              carried: true,
              userOrder: const Value(null),
            ),
          );
        }
      }
    });
  }
}
