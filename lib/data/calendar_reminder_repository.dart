import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/ics_builder.dart';
import '../core/schedule_load.dart';
import '../core/web_reminders.dart';
import 'database.dart';
import 'night_planning_repository.dart';
import 'settings_repository.dart';

/// Tonight and the 7 nights after it; past events are dropped.
const int _nightsCovered = 7;

class CalendarReminderRepository {
  final AppDatabase db;
  final NightPlanningRepository planning;
  final SettingsRepository settingsRepo;

  CalendarReminderRepository(this.db, this.planning, this.settingsRepo);

  /// Reads first: an insert, even an ignored one, can wake the watchers, and
  /// they call this again.
  static Future<CalendarReminderRow> _row(AppDatabase db) async {
    final existing = await (db.select(
      db.calendarReminderStates,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    if (existing != null) return existing;
    await db
        .into(db.calendarReminderStates)
        .insert(
          const CalendarReminderStatesCompanion(id: Value(0)),
          mode: InsertMode.insertOrIgnore,
        );
    return (db.select(
      db.calendarReminderStates,
    )..where((t) => t.id.equals(0))).getSingle();
  }

  static Future<void> _write(
    AppDatabase db,
    CalendarReminderStatesCompanion change,
  ) async {
    await _row(db);
    await (db.update(
      db.calendarReminderStates,
    )..where((t) => t.id.equals(0))).write(change);
  }

  static Future<void> markBackedUp(AppDatabase db, DateTime now) =>
      _write(db, CalendarReminderStatesCompanion(lastBackupAt: Value(now)));

  Future<CalendarReminderRow> get() => _row(db);

  static Set<IcsEventKind> enabledKinds(SettingsRow settings) => {
    if (settings.notifyPutPhoneDown) IcsEventKind.putPhoneDown,
    if (settings.notifyBedtime) IcsEventKind.bedtime,
    if (settings.notifyCheckIn) IcsEventKind.checkIn,
  };

  Future<List<IcsNight>> _nights(DateTime now) async {
    final result = <IcsNight>[];
    for (var ahead = 0; ahead <= _nightsCovered; ahead++) {
      final plan = await planning.currentPlan(
        DateTime(now.year, now.month, now.day + ahead),
      );
      result.add(
        IcsNight(
          wakeDate: plan.wakeDate,
          notifyTime: NightPlanningRepository.notifyTimeOf(plan),
          bedtime: plan.bedtime,
          wakeTime: plan.wakeTime,
        ),
      );
    }
    return result;
  }

  /// Builds the next 7 days of reminders and records what was in them.
  /// Returns null if there is nothing to add.
  Future<IcsCalendar?> generate(DateTime now) async {
    final nights = await _nights(now);
    final enabled = enabledKinds(await settingsRepo.get());
    return db.transaction(() async {
      final row = await _row(db);
      final calendar = buildIcs(
        nights: nights,
        enabled: enabled,
        sequences: (jsonDecode(row.sequences) as Map<String, dynamic>)
            .cast<String, int>(),
        now: now,
      );
      if (calendar.events.isEmpty) return null;
      await _write(
        db,
        CalendarReminderStatesCompanion(
          lastAddedAt: Value(now),
          coveredUntil: Value(calendar.events.last.start),
          sequences: Value(jsonEncode(calendar.sequences)),
          events: Value(
            jsonEncode({
              for (final e in exportedStarts(calendar.events).entries)
                e.key: e.value.toUtc().toIso8601String(),
            }),
          ),
        ),
      );
      return calendar;
    });
  }

  Future<CalendarReminderStatus> status(DateTime now) async {
    final row = await _row(db);
    final settings = await settingsRepo.get();
    final exported = (jsonDecode(row.events) as Map<String, dynamic>).map(
      (uid, start) => MapEntry(uid, DateTime.parse(start as String)),
    );
    return calendarReminderStatus(
      exported: exported,
      // The database keeps whole seconds, as do the exported times.
      coveredUntil: row.coveredUntil,
      current: icsEvents(
        nights: await _nights(now),
        enabled: enabledKinds(settings),
        now: now,
      ),
      now: now,
    );
  }

  Future<bool> backupOverdue(DateTime now) async {
    final row = await _row(db);
    final settings = await settingsRepo.get();
    return isBackupOverdue(
      lastBackupAt: row.lastBackupAt,
      startedAt: settings.onboardedAt,
      now: now,
    );
  }

  /// Wake dates in the next 7 days that the timetable makes red.
  Future<List<DateTime>> redNightsAhead(DateTime now) async {
    final result = <DateTime>[];
    for (var ahead = 1; ahead <= _nightsCovered; ahead++) {
      final plan = await planning.currentPlan(
        DateTime(now.year, now.month, now.day + ahead),
      );
      final load = await planning.computeEveningLoad(plan);
      if (load.level == EveningLoadLevel.red) result.add(plan.wakeDate);
    }
    return result;
  }
}
