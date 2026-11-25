import 'package:drift/drift.dart';

import '../core/quests.dart';
import '../core/routine_builder.dart';
import '../core/routine_config.dart';
import 'database.dart';
import 'wallet_repository.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

List<String> _split(String text) => text.isEmpty ? const [] : text.split(',');

/// Today's activities and the stretching log (CLAUDE.md section 13).
class RoutineRepository {
  final AppDatabase db;
  final WalletRepository walletRepo;

  RoutineRepository(this.db, this.walletRepo);

  Future<DayActivity?> _activityRow(DateTime wakeDate) {
    final target = _dateOnly(wakeDate);
    return (db.select(
      db.dayActivities,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();
  }

  /// Null if nothing has been saved for the night yet.
  Future<({Set<DayActivityKind> activities, bool confirmed})?> activitiesFor(
    DateTime wakeDate,
  ) async {
    final row = await _activityRow(wakeDate);
    if (row == null) return null;
    final names = _split(row.activities).toSet();
    return (
      activities: {
        for (final kind in DayActivityKind.values)
          if (names.contains(kind.name)) kind,
      },
      confirmed: row.confirmed,
    );
  }

  Future<void> saveActivities(
    DateTime wakeDate,
    Set<DayActivityKind> activities, {
    required bool confirmed,
  }) {
    return db
        .into(db.dayActivities)
        .insertOnConflictUpdate(
          DayActivitiesCompanion.insert(
            wakeDate: _dateOnly(wakeDate),
            activities: activities.map((a) => a.name).join(','),
            confirmed: Value(confirmed),
          ),
        );
  }

  Future<RoutineLog?> logFor(DateTime wakeDate) {
    final target = _dateOnly(wakeDate);
    return (db.select(
      db.routineLogs,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();
  }

  /// Saves a finished run and returns the coins it earned just now. A night
  /// pays at most once, however many times the routine is repeated.
  Future<int> finishRoutine({
    required DateTime wakeDate,
    required List<Pose> poses,
    required Set<String> skippedPoseIds,
    required QuestMode mode,
  }) {
    final target = _dateOnly(wakeDate);
    return db.transaction(() async {
      final before = await logFor(target);
      final completed = routineCountsAsDone(
        total: poses.length,
        skipped: skippedPoseIds.length,
      );
      final alreadyPaid = before?.coinsAwarded ?? 0;
      final earned = completed && alreadyPaid == 0
          ? routineQuestCoins(mode)
          : 0;
      await db
          .into(db.routineLogs)
          .insertOnConflictUpdate(
            RoutineLogsCompanion.insert(
              wakeDate: target,
              poseIds: poses.map((p) => p.id).join(','),
              skippedPoseIds: Value(skippedPoseIds.join(',')),
              completed: Value(completed || (before?.completed ?? false)),
              coinsAwarded: Value(alreadyPaid + earned),
            ),
          );
      if (earned > 0) await walletRepo.addCoins(earned);
      return earned;
    });
  }
}
