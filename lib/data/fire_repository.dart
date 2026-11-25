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
        .insert(
          const FireStatesCompanion(id: Value(0)),
          mode: InsertMode.insertOrIgnore,
        );
    return await (db.select(
      db.fireStates,
    )..where((t) => t.id.equals(0))).getSingle();
  }

  Future<FireStateRow> applyEffect(core.NightFireEffect effect) async {
    final current = await get();
    final next = core.applyNightFireEffect(_toCore(current), effect);
    await (db.update(
      db.fireStates,
    )..where((t) => t.id.equals(0))).write(_toCompanion(next));
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

  /// Attempts to buy one shield with coins — the caller (ShopRepository)
  /// only deducts coins if this returns [ShieldPurchaseOutcome.success].
  /// Enforces both section 7 caps: max [core.maxShields] held, and at most
  /// one purchase per calendar week.
  Future<ShieldPurchaseOutcome> tryPurchaseShield(DateTime now) async {
    final current = await get();
    if (current.shields >= core.maxShields) {
      return ShieldPurchaseOutcome.alreadyFull;
    }
    final thisMonday = mondayOfWeek(now);
    if (current.lastShieldPurchaseMonday != null &&
        !mondayOfWeek(current.lastShieldPurchaseMonday!).isBefore(thisMonday)) {
      return ShieldPurchaseOutcome.alreadyPurchasedThisWeek;
    }
    final next = core.buyShield(_toCore(current));
    if (next == null) return ShieldPurchaseOutcome.alreadyFull;
    await (db.update(db.fireStates)..where((t) => t.id.equals(0))).write(
      _toCompanion(next).copyWith(lastShieldPurchaseMonday: Value(thisMonday)),
    );
    return ShieldPurchaseOutcome.success;
  }
}

enum ShieldPurchaseOutcome { success, alreadyFull, alreadyPurchasedThisWeek }
