import 'package:drift/drift.dart';

import '../core/night_date.dart';
import '../core/schedule_load.dart';
import '../core/schedule_resolver.dart';
import '../core/sleep_calculator.dart';
import 'database.dart';
import 'schedule_repository.dart';
import 'settings_repository.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Combines schedule + settings + core calculator/resolver to produce night
/// plans, and persists the lock snapshot described in CLAUDE.md section 3
/// step 8 ("ล็อกแผนคืนนี้ตอนถึงเวลาเตือนวางมือถือ").
class NightPlanningRepository {
  final AppDatabase db;
  final ScheduleRepository scheduleRepo;
  final SettingsRepository settingsRepo;

  NightPlanningRepository(this.db, this.scheduleRepo, this.settingsRepo);

  /// All 7 nights (Mon..Sun) of the calendar week containing [anyDateInWeek],
  /// with weekly bedtime smoothing (section 3 step 7) already applied.
  Future<List<NightPlanDraft>> computeWeekDrafts(DateTime anyDateInWeek) async {
    final monday = mondayOfWeek(anyDateInWeek);
    final settingsRow = await settingsRepo.get();
    final settings = toSleepSettings(settingsRow);
    final weekly = toCoreWeeklyEntries(await scheduleRepo.getWeeklyItems());
    final oneTime = toCoreOneTimeEntries(await scheduleRepo.getOneTimeItems());

    final drafts = List.generate(7, (i) {
      final wakeDate = monday.add(Duration(days: i));
      final entries = resolveScheduleForDate(
        date: wakeDate,
        weeklyEntries: weekly,
        oneTimeEntries: oneTime,
        termStart: settingsRow.termStart,
        termEnd: settingsRow.termEnd,
      );
      return calculateNightPlanDraft(
        wakeDate: wakeDate,
        settings: settings,
        entriesForWakeDate: entries,
      );
    });

    return smoothWeekNightPlans(drafts);
  }

  Future<NightPlanDraft> computeDraftForWakeDate(DateTime wakeDate) async {
    final week = await computeWeekDrafts(wakeDate);
    final target = _dateOnly(wakeDate);
    return week.firstWhere((n) => n.wakeDate == target);
  }

  Future<EveningLoadResult> computeEveningLoad(NightPlanDraft draft) async {
    final settingsRow = await settingsRepo.get();
    final settings = toSleepSettings(settingsRow);
    final eveningDate = draft.wakeDate.subtract(const Duration(days: 1));
    final entries = resolveScheduleForDate(
      date: eveningDate,
      weeklyEntries: toCoreWeeklyEntries(await scheduleRepo.getWeeklyItems()),
      oneTimeEntries: toCoreOneTimeEntries(await scheduleRepo.getOneTimeItems()),
      termStart: settingsRow.termStart,
      termEnd: settingsRow.termEnd,
    );
    return classifyEveningLoad(
      entriesForEveningDate: entries,
      plannedBedtime: draft.bedtime,
      plannedWakeTime: draft.wakeTime,
      isPreExamNight: draft.isPreExamNight,
      settings: settings,
    );
  }

  /// Returns the plan for [wakeDate]: the locked snapshot if one already
  /// exists, otherwise a live draft — which gets locked right now if [now]
  /// has reached that night's "put the phone down" notify time.
  Future<NightPlanDraft> getOrLockPlan(
    DateTime wakeDate, {
    required DateTime now,
  }) async {
    final target = _dateOnly(wakeDate);
    final existing = await (db.select(
      db.nightPlans,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();

    if (existing != null && existing.isLocked) {
      return NightPlanDraft(
        wakeDate: existing.wakeDate,
        wakeTime: existing.plannedWakeAt,
        bedtime: existing.plannedBedtimeAt,
        wakeWasCapped: false,
        bedtimeWasCapped: false,
        isPreExamNight: existing.isPreExamNight,
      );
    }

    final draft = await computeDraftForWakeDate(target);
    final load = await computeEveningLoad(draft);
    final notifyOffsetMinutes = draft.isPreExamNight ? 90 : 60;
    final notifyTime = draft.bedtime.subtract(
      Duration(minutes: notifyOffsetMinutes),
    );

    if (!now.isBefore(notifyTime)) {
      final companion = NightPlansCompanion(
        wakeDate: Value(target),
        plannedWakeAt: Value(draft.wakeTime),
        plannedBedtimeAt: Value(draft.bedtime),
        isRedNight: Value(load.level == EveningLoadLevel.red),
        isYellowNight: Value(load.level == EveningLoadLevel.yellow),
        isPreExamNight: Value(draft.isPreExamNight),
        isLocked: const Value(true),
        lockedAt: Value(now),
      );
      if (existing != null) {
        await (db.update(
          db.nightPlans,
        )..where((t) => t.id.equals(existing.id))).write(companion);
      } else {
        await db.into(db.nightPlans).insert(companion);
      }
    }

    return draft;
  }

  /// Red nights in the next 7 days (today included) that haven't had their
  /// one-time "คืนแดงข้างหน้า" alert sent yet.
  Future<List<NightPlanDraft>> findUnalertedRedNightsAhead(
    DateTime now,
  ) async {
    final today = _dateOnly(now);
    final result = <NightPlanDraft>[];
    for (var i = 0; i < 7; i++) {
      final wakeDate = today.add(Duration(days: i));
      final draft = await computeDraftForWakeDate(wakeDate);
      final load = await computeEveningLoad(draft);
      if (load.level != EveningLoadLevel.red) continue;
      final existing = await (db.select(
        db.nightPlans,
      )..where((t) => t.wakeDate.equals(wakeDate))).getSingleOrNull();
      if (existing?.redAlertSentAt != null) continue;
      result.add(draft);
    }
    return result;
  }

  Future<void> markRedAlertSent(DateTime wakeDate, DateTime sentAt) async {
    final target = _dateOnly(wakeDate);
    final existing = await (db.select(
      db.nightPlans,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();
    if (existing != null) {
      await (db.update(
        db.nightPlans,
      )..where((t) => t.id.equals(existing.id))).write(
        NightPlansCompanion(redAlertSentAt: Value(sentAt)),
      );
      return;
    }
    final draft = await computeDraftForWakeDate(target);
    await db.into(db.nightPlans).insert(
      NightPlansCompanion.insert(
        wakeDate: target,
        plannedWakeAt: draft.wakeTime,
        plannedBedtimeAt: draft.bedtime,
        isPreExamNight: Value(draft.isPreExamNight),
        isRedNight: const Value(true),
        redAlertSentAt: Value(sentAt),
      ),
    );
  }

  /// True if any exam is within the next 7 days (inclusive), per section 4.
  Future<bool> isExamModeActive(DateTime now) async {
    final exams = await _upcomingExams(now);
    return exams.any((e) => e.date.difference(_dateOnly(now)).inDays <= 7);
  }

  /// The soonest upcoming exam and days until it, for the countdown banner.
  Future<({OneTimeItem exam, int daysUntil})?> nextExamCountdown(
    DateTime now,
  ) async {
    final exams = await _upcomingExams(now);
    if (exams.isEmpty) return null;
    final soonest = exams.first;
    return (
      exam: soonest,
      daysUntil: soonest.date.difference(_dateOnly(now)).inDays,
    );
  }

  Future<List<OneTimeItem>> _upcomingExams(DateTime now) async {
    final today = _dateOnly(now);
    final rows =
        await (db.select(db.oneTimeItems)..where(
              (t) => t.type.equalsValue(OneTimeItemType.exam) & t.date.isBiggerOrEqualValue(today),
            ))
            .get();
    rows.sort((a, b) => a.date.compareTo(b.date));
    return rows;
  }
}
