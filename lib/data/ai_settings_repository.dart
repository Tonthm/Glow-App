import 'package:drift/drift.dart';

import '../core/birth_date.dart';
import 'database.dart';

/// The AI assistant's settings (CLAUDE.md section 12). The key is not here.
class AiSettingsRepository {
  final AppDatabase db;

  AiSettingsRepository(this.db);

  /// Reads first: an insert, even an ignored one, can wake the watchers, and
  /// they call this again.
  Future<AiSettingsRow> get() async {
    final existing = await (db.select(
      db.aiSettings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    if (existing != null) return existing;
    await db
        .into(db.aiSettings)
        .insert(
          const AiSettingsCompanion(id: Value(0)),
          mode: InsertMode.insertOrIgnore,
        );
    return (db.select(db.aiSettings)..where((t) => t.id.equals(0))).getSingle();
  }

  Stream<AiSettingsRow> watch() async* {
    await get();
    yield* (db.select(db.aiSettings)..where((t) => t.id.equals(0)))
        .watchSingleOrNull()
        .asyncMap((row) async => row ?? await get());
  }

  Future<void> update(AiSettingsCompanion change) async {
    await get();
    await (db.update(
      db.aiSettings,
    )..where((t) => t.id.equals(0))).write(change);
  }

  /// From the birth date if there is one, else the chosen age group. No
  /// choice yet counts as under 18, the stored default. [now] is real time.
  Future<AiAgeState> ageState(DateTime now) async {
    final settings = await (db.select(
      db.settings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    final profile = await (db.select(
      db.cardProfiles,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    return aiAgeState(
      birthDate: profile?.birthDate,
      choseAdult: settings?.ageGroup == AgeGroup.adult,
      now: now,
    );
  }

  /// Calls made on [now]'s day.
  static int callsOn(AiSettingsRow row, DateTime now) =>
      row.callDay == DateTime(now.year, now.month, now.day) ? row.callCount : 0;

  /// Counts one call against today's limit. False if the limit is reached.
  Future<bool> tryUseCall(DateTime now) => db.transaction(() async {
    final row = await get();
    final used = callsOn(row, now);
    if (used >= row.dailyQuota) return false;
    await update(
      AiSettingsCompanion(
        callDay: Value(DateTime(now.year, now.month, now.day)),
        callCount: Value(used + 1),
      ),
    );
    return true;
  });
}
