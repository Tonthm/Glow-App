import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/quests.dart';
import 'package:glow/core/routine_builder.dart';
import 'package:glow/core/routine_config.dart';
import 'package:glow/core/schedule_load.dart';
import 'package:glow/data/check_in_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/fire_repository.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/quest_repository.dart';
import 'package:glow/data/routine_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/data/wallet_repository.dart';
import 'package:glow/features/demo/demo_data.dart';

/// Walks the pitch demo through the data layer, whichever weekday it is
/// presented on.
void main() {
  for (var offset = 0; offset < 7; offset++) {
    final today = DateTime(2026, 11, 23 + offset);

    test('demo path starting on weekday ${today.weekday}', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final settings = SettingsRepository(db);
      final schedule = ScheduleRepository(db);
      final planning = NightPlanningRepository(db, schedule, settings);
      final fire = FireRepository(db);
      final wallet = WalletRepository(db);
      final checkIns = CheckInRepository(
        db,
        planning,
        fire,
        settings,
        wallet,
      );
      final quests = QuestRepository(db, wallet, schedule);
      final routines = RoutineRepository(db, wallet);

      /// What the Tonight screen does each time it loads.
      Future<void> open(DateTime now) async {
        await planning.lockElapsedNights(now);
        await fire.grantFreeShieldIfNewWeek(now);
        await checkIns.sweepMissedNights(now);
        await quests.claimWeeklyRewardIfComplete(now);
        await quests.claimExamPeriodRewardsIfComplete(now);
      }

      await resetDemoData(db, today);
      DateTime at(int days, int hour, [int minute = 0]) =>
          DateTime(today.year, today.month, today.day + days, hour, minute);

      // Evening: nothing pending, fire one point short, one blanket's coins.
      await open(at(0, 21, 30));
      expect(await checkIns.findPendingCheckIn(at(0, 21, 30)), isNull);
      expect((await fire.get()).level, 2);
      expect((await fire.get()).points, 6);
      expect((await wallet.get()).coins, 60);

      final tomorrow = at(1, 0);
      final tonight = await planning.getOrLockPlan(
        tomorrow,
        now: at(0, 21, 30),
      );
      final mode = await planning.questModeFor(tonight);
      expect(mode, QuestMode.normal);

      // Stretch, then go to bed.
      final routine = buildRoutine(
        wakeDate: tomorrow,
        activities: {DayActivityKind.sitting, DayActivityKind.screen},
        mode: mode,
      );
      final routineCoins = await routines.finishRoutine(
        wakeDate: tomorrow,
        poses: routine,
        skippedPoseIds: {},
        mode: mode,
      );
      expect(routineCoins, 5);
      await planning.markInBed(tomorrow, at(0, 21, 35));

      // Next morning.
      final morning = tonight.wakeTime.add(const Duration(minutes: 1));
      await open(morning);
      final pending = await checkIns.findPendingCheckIn(morning);
      expect(pending?.wakeDate, tomorrow);
      expect(pending!.defaultLightsOff, at(0, 21, 35));

      final result = await checkIns.recordCheckIn(
        wakeDate: tomorrow,
        lightsOffAt: pending.defaultLightsOff,
        actualWakeAt: pending.plannedWakeTime,
        now: morning,
        source: pending.defaultSource,
      );
      await open(morning);
      expect(result.outcome.result, CheckInResult.enough);
      expect(result.outcome.onTime, isTrue);
      expect((await fire.get()).level, 3);
      expect((await wallet.get()).coins, greaterThanOrEqualTo(60 + 5 + 20));

      // The busy day: only "หลับตามแผน" is left.
      final redWake = at(2, 0);
      final redDraft = await planning.computeDraftForWakeDate(redWake);
      expect(
        (await planning.computeEveningLoad(redDraft)).level,
        EveningLoadLevel.red,
      );
      await open(at(1, 17));
      expect(await planning.questModeFor(redDraft), QuestMode.minimum);
      // Jumping there must not cost any fire.
      expect((await fire.get()).level, 3);
    });
  }
}
