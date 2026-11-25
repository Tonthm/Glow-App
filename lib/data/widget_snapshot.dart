import '../core/night_date.dart';
import '../core/widget_content.dart';
import 'check_in_repository.dart';
import 'database.dart';
import 'evening_repository.dart';
import 'fire_repository.dart';
import 'night_planning_repository.dart';
import 'quest_repository.dart';
import 'schedule_repository.dart';
import 'settings_repository.dart';
import 'wallet_repository.dart';

/// Gathers what the widgets show. Takes only the database, so it also works
/// in the background isolate behind a notification button.
Future<WidgetContent> loadWidgetContent(AppDatabase db, DateTime now) async {
  final settings = SettingsRepository(db);
  final schedule = ScheduleRepository(db);
  final planning = NightPlanningRepository(db, schedule, settings);
  final fire = FireRepository(db);
  final wallet = WalletRepository(db);
  final checkIns = CheckInRepository(db, planning, fire, settings, wallet);
  final row = await settings.get();
  final fireLevel = (await fire.get()).level;
  final hasSchedule =
      (await schedule.getWeeklyItems()).isNotEmpty ||
      (await schedule.getOneTimeItems()).isNotEmpty;

  var wakeDate = resolveTonightWakeDate(now);
  // Once this morning is checked in, look ahead to the coming night.
  if (await checkIns.getForWakeDate(wakeDate) != null) {
    wakeDate = DateTime(wakeDate.year, wakeDate.month, wakeDate.day + 1);
  }

  WidgetNight? night;
  final draft = await planning.currentPlan(wakeDate);
  if (row.onboardingCompleted && hasSchedule) {
    night = WidgetNight(
      bedtime: draft.bedtime,
      wakeTime: draft.wakeTime,
      pressedAt: (await planning.getPlanRow(wakeDate))?.inBedAt,
    );
  }

  final evening = row.eveningEnabled && night != null
      ? await EveningRepository(db, planning, settings).load(now)
      : null;

  return buildWidgetContent(
    now: now,
    tonight: night,
    eveningBlocks: evening?.plan.blocks ?? const [],
    weeklyPassCount: await QuestRepository(
      db,
      wallet,
      schedule,
    ).currentWeekPassCount(now),
    mode: await planning.questModeFor(draft),
    fireLevel: fireLevel,
  );
}
