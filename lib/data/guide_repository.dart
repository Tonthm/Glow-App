import 'package:drift/drift.dart';

import '../core/guide.dart';
import 'database.dart';

/// What has been seen and done of the guide (CLAUDE.md section 21).
class GuideRepository {
  final AppDatabase db;

  GuideRepository(this.db);

  static const _empty = GuideStateRow(
    id: 0,
    tourPending: false,
    checklistDismissed: false,
    doneSteps: '',
  );

  /// Reading never writes: no row yet means nothing has happened.
  SimpleSelectStatement<$GuideStatesTable, GuideStateRow> get _query =>
      db.select(db.guideStates)..where((t) => t.id.equals(0));

  Future<GuideStateRow> get() async => await _query.getSingleOrNull() ?? _empty;

  Stream<GuideStateRow> watch() =>
      _query.watchSingleOrNull().map((row) => row ?? _empty);

  Future<void> _change(GuideStateRow Function(GuideStateRow) change) {
    return db.transaction(() async {
      await db.into(db.guideStates).insertOnConflictUpdate(change(await get()));
    });
  }

  Future<void> setTourPending(bool pending) =>
      _change((row) => row.copyWith(tourPending: pending));

  Future<void> dismissChecklist() =>
      _change((row) => row.copyWith(checklistDismissed: true));

  /// Adds [steps] to the ticked ones. Writes only when one is new.
  Future<void> markDone(Set<ChecklistStep> steps) async {
    if (parseSteps((await get()).doneSteps).containsAll(steps)) return;
    await _change(
      (row) => row.copyWith(
        doneSteps: encodeSteps({...parseSteps(row.doneSteps), ...steps}),
      ),
    );
  }

  /// The steps the saved data proves right now.
  Future<Set<ChecklistStep>> stepsInData() async {
    Future<bool> any<T extends Table, R>(TableInfo<T, R> table) async =>
        (await (db.select(table)..limit(1)).get()).isNotEmpty;
    return stepsDoneBy(
      hasSchedule: await any(db.weeklyItems) || await any(db.oneTimeItems),
      hasEveningTask: await any(db.eveningTasks),
      hasRoutineRun: await any(db.routineLogs),
      hasCheckIn: await any(db.checkIns),
    );
  }
}
