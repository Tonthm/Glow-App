import 'package:drift/drift.dart';

import '../core/day_overrides.dart';
import '../core/first_class.dart';
import '../core/night_date.dart';
import '../core/quests.dart' show QuestMode;
import '../core/quests.dart' as quests;
import '../core/schedule_load.dart';
import '../core/schedule_models.dart';
import '../core/schedule_resolver.dart';
import '../core/sleep_calculator.dart';
import '../core/sleep_cycles.dart';
import 'database.dart';
import 'schedule_repository.dart';
import 'settings_repository.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// One night's sleep cycle figures, for the bar under tonight's plan.
class NightCycles {
  /// How many minutes earlier cycles made bedtime; 0 if they didn't.
  final int shiftMinutes;
  final int cycleMinutes;
  final int fallAsleepMinutes;
  final int sleepMinutes;

  const NightCycles({
    required this.shiftMinutes,
    required this.cycleMinutes,
    required this.fallAsleepMinutes,
    required this.sleepMinutes,
  });
}

/// Combines schedule + settings + core calculator/resolver to produce night
/// plans, and persists the lock snapshot described in CLAUDE.md section 3
/// step 8 ("ล็อกแผนคืนนี้ตอนถึงเวลาเตือนวางมือถือ").
class NightPlanningRepository {
  final AppDatabase db;
  final ScheduleRepository scheduleRepo;
  final SettingsRepository settingsRepo;

  NightPlanningRepository(this.db, this.scheduleRepo, this.settingsRepo);

  /// All 7 nights (Mon..Sun) of the calendar week containing [anyDateInWeek],
  /// with weekly bedtime smoothing (section 3 step 7) already applied, and
  /// then sleep cycles (section 20) if they are on.
  Future<List<NightPlanDraft>> computeWeekDrafts(DateTime anyDateInWeek) async {
    final formula = await _formulaWeek(anyDateInWeek);
    final settings = await settingsRepo.get();
    if (!settings.cycleAlignEnabled) return formula;
    return alignWeekToCycles(
      formula,
      fallAsleepMinutes: settings.fallAsleepMinutes,
      targetMaxMinutes: settings.targetMaxMinutes,
      cycleMinutes: settings.cycleMinutes,
    );
  }

  /// The week by the section 3 formula alone.
  Future<List<NightPlanDraft>> _formulaWeek(DateTime anyDateInWeek) async {
    final monday = mondayOfWeek(anyDateInWeek);
    final settingsRow = await settingsRepo.get();
    final settings = toSleepSettings(settingsRow);
    final weekly = await _wakeEntries(settingsRow);
    final oneTime = toCoreOneTimeEntries(await scheduleRepo.getOneTimeItems());

    final travel = parseTravelOverrides(settingsRow.travelOverrides);
    final prepByDate = {
      for (final row in await db.select(db.nightPlans).get())
        if (row.prepOverrideMinutes != null)
          _dateOnly(row.wakeDate): row.prepOverrideMinutes!,
    };

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
        settings: settingsFor(
          settings,
          wakeDate,
          travel,
          prepOverride: prepByDate[wakeDate],
        ),
        entriesForWakeDate: entries,
      );
    });

    return smoothWeekNightPlans(drafts);
  }

  /// How much earlier than the formula [draft]'s bedtime is.
  Future<int> _cycleShift(NightPlanDraft draft) async {
    final target = _dateOnly(draft.wakeDate);
    final formula = (await _formulaWeek(
      target,
    )).firstWhere((n) => n.wakeDate == target);
    return formula.bedtime.difference(draft.bedtime).inMinutes;
  }

  /// Cycle figures for [draft]. A locked night keeps what it locked with.
  Future<NightCycles> cyclesFor(NightPlanDraft draft) async {
    final settings = await settingsRepo.get();
    final row = await getPlanRow(draft.wakeDate);
    final locked = row != null && row.isLocked;
    return NightCycles(
      shiftMinutes: locked
          ? row.cycleShiftMinutes ?? 0
          : await _cycleShift(draft),
      cycleMinutes: (locked ? row.cycleMinutes : null) ?? settings.cycleMinutes,
      fallAsleepMinutes: settings.fallAsleepMinutes,
      sleepMinutes: plannedSleepMinutes(
        wakeTime: draft.wakeTime,
        bedtime: draft.bedtime,
        fallAsleepMinutes: settings.fallAsleepMinutes,
      ),
    );
  }

  /// Weekly items for working out wake times, where the earliest class time
  /// given at the start stands in for an empty timetable. The evening
  /// planner and busy-night check see only what was really entered.
  Future<List<WeeklyEntry>> _wakeEntries(SettingsRow settings) async =>
      withEarliestClass(
        toCoreWeeklyEntries(await scheduleRepo.getWeeklyItems()),
        settings.earliestClassMinutes,
      );

  Future<NightPlanDraft> computeDraftForWakeDate(DateTime wakeDate) async {
    final week = await computeWeekDrafts(wakeDate);
    final target = _dateOnly(wakeDate);
    return week.firstWhere((n) => n.wakeDate == target);
  }

  /// Appointments on [date], with holidays and one-off changes applied.
  Future<List<ScheduleEntry>> entriesOn(DateTime date) async {
    final settingsRow = await settingsRepo.get();
    return resolveScheduleForDate(
      date: date,
      weeklyEntries: toCoreWeeklyEntries(await scheduleRepo.getWeeklyItems()),
      oneTimeEntries: toCoreOneTimeEntries(
        await scheduleRepo.getOneTimeItems(),
      ),
      termStart: settingsRow.termStart,
      termEnd: settingsRow.termEnd,
    );
  }

  /// The earliest appointment on [wakeDate], for the line under the bedtime.
  Future<ScheduleEntry?> firstAppointment(DateTime wakeDate) async {
    final settingsRow = await settingsRepo.get();
    final entries = resolveScheduleForDate(
      date: wakeDate,
      weeklyEntries: await _wakeEntries(settingsRow),
      oneTimeEntries: toCoreOneTimeEntries(
        await scheduleRepo.getOneTimeItems(),
      ),
      termStart: settingsRow.termStart,
      termEnd: settingsRow.termEnd,
    );
    return entries.isEmpty ? null : entries.first;
  }

  Future<EveningLoadResult> computeEveningLoad(NightPlanDraft draft) async {
    final settingsRow = await settingsRepo.get();
    final settings = toSleepSettings(settingsRow);
    final eveningDate = draft.wakeDate.subtract(const Duration(days: 1));
    final entries = resolveScheduleForDate(
      date: eveningDate,
      weeklyEntries: toCoreWeeklyEntries(await scheduleRepo.getWeeklyItems()),
      oneTimeEntries: toCoreOneTimeEntries(
        await scheduleRepo.getOneTimeItems(),
      ),
      termStart: settingsRow.termStart,
      termEnd: settingsRow.termEnd,
    );
    final examDates = (await scheduleRepo.getOneTimeItems())
        .where((i) => i.type == OneTimeItemType.exam)
        .map((i) => i.date);
    return classifyEveningLoad(
      isExamMode: isExamModeOn(date: eveningDate, examDates: examDates),
      entriesForEveningDate: entries,
      plannedBedtime: draft.bedtime,
      plannedWakeTime: draft.wakeTime,
      isPreExamNight: draft.isPreExamNight,
      settings: settingsFor(
        settings,
        eveningDate,
        parseTravelOverrides(settingsRow.travelOverrides),
      ),
    );
  }

  static NightPlanDraft _fromRow(NightPlan row) => NightPlanDraft(
    wakeDate: row.wakeDate,
    wakeTime: row.plannedWakeAt,
    bedtime: row.plannedBedtimeAt,
    wakeWasCapped: false,
    bedtimeWasCapped: false,
    isPreExamNight: row.isPreExamNight,
  );

  static DateTime _notifyTimeOf(NightPlanDraft draft) =>
      draft.bedtime.subtract(Duration(minutes: draft.isPreExamNight ? 90 : 60));

  /// "กดเข้านอน" for fire and quests. Nights from before the button mattered
  /// count as pressed.
  static bool countsAsPressed(NightPlan? row) =>
      row != null && (row.legacyBedPress || row.inBedAt != null);

  /// When tonight's plan locks: the put-the-phone-down reminder.
  static DateTime notifyTimeOf(NightPlanDraft draft) => _notifyTimeOf(draft);

  /// The night's quest mode: fixed once the plan has locked, live before.
  Future<QuestMode> questModeFor(NightPlanDraft draft) async {
    final row = await getPlanRow(draft.wakeDate);
    if (row != null && row.isLocked) {
      return QuestMode.values[row.questMode ?? QuestMode.normal.index];
    }
    final load = await computeEveningLoad(draft);
    return quests.questModeFor(
      load: load.level,
      lowEnergy: row?.lowEnergy ?? false,
    );
  }

  /// "วันนี้หมดแรง" uses spent this week on nights other than [wakeDate].
  Future<int> lowEnergyUsedElsewhere(DateTime wakeDate) async {
    final target = _dateOnly(wakeDate);
    final monday = mondayOfWeek(target);
    final sunday = DateTime(monday.year, monday.month, monday.day + 6);
    final rows =
        await (db.select(db.nightPlans)..where(
              (t) =>
                  t.lowEnergy.equals(true) &
                  t.wakeDate.isBiggerOrEqualValue(monday) &
                  t.wakeDate.isSmallerOrEqualValue(sunday),
            ))
            .get();
    return rows.where((r) => _dateOnly(r.wakeDate) != target).length;
  }

  /// Switches "วันนี้หมดแรง" if the rules allow it. Only quests change: the
  /// bedtime plan and fire are untouched.
  Future<bool> setLowEnergy(
    DateTime wakeDate,
    bool value, {
    required DateTime now,
  }) {
    return db.transaction(() async {
      final draft = await currentPlan(wakeDate);
      final locked = (await getPlanRow(wakeDate))?.isLocked == true;
      final allowed =
          !locked &&
          quests.canChangeLowEnergy(
            now: now,
            lockTime: _notifyTimeOf(draft),
            usedOnOtherNightsThisWeek: await lowEnergyUsedElsewhere(wakeDate),
          );
      if (!allowed) return false;
      await _upsertPlan(wakeDate, NightPlansCompanion(lowEnergy: Value(value)));
      return true;
    });
  }

  /// Shortens (or restores, with null) the prep time for one morning. Like
  /// any other edit, it doesn't change a plan that has already locked.
  Future<void> setPrepOverride(DateTime wakeDate, int? minutes) => _upsertPlan(
    wakeDate,
    NightPlansCompanion(prepOverrideMinutes: Value(minutes)),
  );

  Future<void> setEveningFrom(DateTime wakeDate, DateTime from) =>
      _upsertPlan(wakeDate, NightPlansCompanion(eveningFrom: Value(from)));

  Future<void> setEveningStartedAt(DateTime wakeDate, DateTime at) =>
      _upsertPlan(wakeDate, NightPlansCompanion(eveningStartedAt: Value(at)));

  /// "ยังไม่นอน": forgets the press so it can be made again.
  Future<void> undoInBed(DateTime wakeDate) {
    return _upsertPlan(
      wakeDate,
      const NightPlansCompanion(inBedAt: Value(null)),
    );
  }

  Future<NightPlan?> getPlanRow(DateTime wakeDate) {
    final target = _dateOnly(wakeDate);
    return (db.select(
      db.nightPlans,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();
  }

  /// The locked snapshot if there is one, else a live draft. Never locks.
  Future<NightPlanDraft> currentPlan(DateTime wakeDate) async {
    final row = await getPlanRow(wakeDate);
    if (row != null && row.isLocked) return _fromRow(row);
    return computeDraftForWakeDate(_dateOnly(wakeDate));
  }

  /// Locks every recent night whose put-the-phone-down time has passed, even
  /// if the app wasn't open then. Without this, a night the app was never
  /// opened for would have no plan: no check-in card and no missed-night
  /// effect, so staying away would beat answering honestly.
  Future<void> lockElapsedNights(DateTime now, {int lookbackDays = 10}) async {
    final onboardedAt = (await settingsRepo.get()).onboardedAt;
    if (onboardedAt == null) return;
    final today = _dateOnly(now);
    for (var i = lookbackDays; i >= 0; i--) {
      final wakeDate = DateTime(today.year, today.month, today.day - i);
      if ((await getPlanRow(wakeDate))?.isLocked == true) continue;
      final draft = await computeDraftForWakeDate(wakeDate);
      if (_notifyTimeOf(draft).isBefore(onboardedAt)) continue;
      await getOrLockPlan(wakeDate, now: now);
    }
  }

  /// Records that "เข้านอนแล้ว" was pressed for [wakeDate]'s night.
  Future<void> markInBed(DateTime wakeDate, DateTime now) {
    return _upsertPlan(wakeDate, NightPlansCompanion(inBedAt: Value(now)));
  }

  /// Writes [changes] to the night's row, first creating an unlocked row from
  /// the current draft if there isn't one.
  Future<void> _upsertPlan(DateTime wakeDate, NightPlansCompanion changes) {
    final target = _dateOnly(wakeDate);
    return db.transaction(() async {
      if (await getPlanRow(target) == null) {
        final draft = await computeDraftForWakeDate(target);
        await db
            .into(db.nightPlans)
            .insert(
              NightPlansCompanion.insert(
                wakeDate: target,
                plannedWakeAt: draft.wakeTime,
                plannedBedtimeAt: draft.bedtime,
                isPreExamNight: Value(draft.isPreExamNight),
              ),
            );
      }
      await (db.update(
        db.nightPlans,
      )..where((t) => t.wakeDate.equals(target))).write(changes);
    });
  }

  /// Returns the plan for [wakeDate]: the locked snapshot if one already
  /// exists, otherwise a live draft — which gets locked right now if [now]
  /// has reached that night's "put the phone down" notify time.
  Future<NightPlanDraft> getOrLockPlan(
    DateTime wakeDate, {
    required DateTime now,
  }) {
    // One transaction, so two loads at the same moment can't both insert.
    return db.transaction(() => _getOrLockPlan(wakeDate, now: now));
  }

  Future<NightPlanDraft> _getOrLockPlan(
    DateTime wakeDate, {
    required DateTime now,
  }) async {
    final target = _dateOnly(wakeDate);
    final existing = await (db.select(
      db.nightPlans,
    )..where((t) => t.wakeDate.equals(target))).getSingleOrNull();

    if (existing != null && existing.isLocked) {
      return _fromRow(existing);
    }

    final draft = await computeDraftForWakeDate(target);
    final load = await computeEveningLoad(draft);
    if (!now.isBefore(_notifyTimeOf(draft))) {
      final mode = quests.questModeFor(
        load: load.level,
        lowEnergy: existing?.lowEnergy ?? false,
      );
      final companion = NightPlansCompanion(
        wakeDate: Value(target),
        plannedWakeAt: Value(draft.wakeTime),
        plannedBedtimeAt: Value(draft.bedtime),
        isRedNight: Value(load.level == EveningLoadLevel.red),
        isYellowNight: Value(load.level == EveningLoadLevel.yellow),
        isPreExamNight: Value(draft.isPreExamNight),
        isLocked: const Value(true),
        lockedAt: Value(now),
        questMode: Value(mode.index),
        cycleShiftMinutes: Value(await _cycleShift(draft)),
        cycleMinutes: Value((await settingsRepo.get()).cycleMinutes),
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
  Future<List<NightPlanDraft>> findUnalertedRedNightsAhead(DateTime now) async {
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

  Future<void> markRedAlertSent(DateTime wakeDate, DateTime sentAt) {
    return _upsertPlan(
      wakeDate,
      NightPlansCompanion(
        isRedNight: const Value(true),
        redAlertSentAt: Value(sentAt),
      ),
    );
  }
}
