import 'package:drift/drift.dart';

import '../core/fire.dart' as core;
import '../core/night_date.dart';
import 'database.dart';

core.FireState _toCore(FireStateRow row) => core.FireState(
  points: row.points,
  level: row.level,
  shields: row.shields,
  maxLevelEverReached: row.maxLevelEverReached,
  currentStreak: row.currentStreak,
  longestStreak: row.longestStreak,
);

FireStatesCompanion _toCompanion(core.FireState state) => FireStatesCompanion(
  points: Value(state.points),
  level: Value(state.level),
  shields: Value(state.shields),
  maxLevelEverReached: Value(state.maxLevelEverReached),
  currentStreak: Value(state.currentStreak),
  longestStreak: Value(state.longestStreak),
);

/// Persists the single-row fire/streak/shield state from CLAUDE.md section
/// 7, delegating all the actual rules to the pure functions in core/fire.
class FireRepository {
  final AppDatabase db;

  FireRepository(this.db);

  Stream<FireStateRow> watch() {
    return (db.select(
      db.fireStates,
    )..where((t) => t.id.equals(0))).watchSingleOrNull().asyncMap((row) async {
      return row ?? await ensureRowExists();
    });
  }

  Future<FireStateRow> get() async {
    final row = await (db.select(
      db.fireStates,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    return row ?? await ensureRowExists();
  }

  Future<FireStateRow> ensureRowExists() async {
    await db
        .into(db.fireStates)
        .insert(const FireStatesCompanion(id: Value(0)), mode: InsertMode.insertOrIgnore);
    return await (db.select(
      db.fireStates,
    )..where((t) => t.id.equals(0))).getSingle();
  }

  Future<FireStateRow> applyEffect(core.NightFireEffect effect) async {
    final current = await get();
    final next = core.applyNightFireEffect(_toCore(current), effect);
    await (db.update(db.fireStates)..where((t) => t.id.equals(0)))
        .write(_toCompanion(next));
    return await get();
  }

  /// Grants the free Monday shield at most once per calendar week, per
  /// section 7. Safe to call on every app open.
  Future<void> grantFreeShieldIfNewWeek(DateTime now) async {
    final current = await get();
    final thisMonday = mondayOfWeek(now);
    if (current.lastFreeShieldMonday != null &&
        !mondayOfWeek(current.lastFreeShieldMonday!).isBefore(thisMonday)) {
      return;
    }
    final next = core.grantFreeShield(_toCore(current));
    await (db.update(db.fireStates)..where((t) => t.id.equals(0))).write(
      _toCompanion(next).copyWith(lastFreeShieldMonday: Value(thisMonday)),
    );
  }
}
