import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/check_in_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/fire_repository.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/data/wallet_repository.dart';
import 'package:glow/services/backup_service.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late NightPlanningRepository planning;
  late FireRepository fire;
  late CheckInRepository checkIns;

  // Wednesday 2026-11-25, 10:00.
  final onboarding = DateTime(2026, 11, 25, 10);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepository(db);
    planning = NightPlanningRepository(db, ScheduleRepository(db), settings);
    fire = FireRepository(db);
    checkIns = CheckInRepository(
      db,
      planning,
      fire,
      settings,
      WalletRepository(db),
    );
    await settings.ensureRowExists();
    await settings.markOnboardingCompleted(onboarding);
  });

  tearDown(() => db.close());

  test('two screens loading at once lock a night only once', () async {
    final evening = DateTime(2026, 11, 25, 23);
    final tomorrow = DateTime(2026, 11, 26);
    await Future.wait([
      planning.getOrLockPlan(tomorrow, now: evening),
      planning.getOrLockPlan(tomorrow, now: evening),
    ]);
    expect(await db.select(db.nightPlans).get(), hasLength(1));
  });

  test('nights from before onboarding are never locked', () async {
    await planning.lockElapsedNights(onboarding);
    expect(await db.select(db.nightPlans).get(), isEmpty);
  });

  test('nights the app was never opened for are locked later', () async {
    // Opened again three days later in the afternoon.
    await planning.lockElapsedNights(DateTime(2026, 11, 28, 15));
    final wakeDays = [
      for (final p in await db.select(db.nightPlans).get()) p.wakeDate.day,
    ]..sort();
    expect(wakeDays, [26, 27, 28]);
  });

  test('a morning after not opening the app still offers a check-in', () async {
    final morning = DateTime(2026, 11, 26, 13);
    await planning.lockElapsedNights(morning);
    final pending = await checkIns.findPendingCheckIn(morning);
    expect(pending?.wakeDate, DateTime(2026, 11, 26));
  });

  test('a shield spent on a missed night is recorded on that night', () async {
    await fire.grantFreeShieldIfNewWeek(onboarding);
    final later = DateTime(2026, 11, 27, 15);
    await planning.lockElapsedNights(later);
    await checkIns.sweepMissedNights(later);

    final night = await planning.getPlanRow(DateTime(2026, 11, 26));
    expect(night!.usedShield, isTrue);
    expect((await fire.get()).shields, 0);
  });

  test(
    '"in bed" survives and keeps the night unlocked until its time',
    () async {
      final tomorrow = DateTime(2026, 11, 26);
      await planning.markInBed(tomorrow, onboarding);
      final row = await planning.getPlanRow(tomorrow);
      expect(row!.inBedAt, onboarding);
      expect(row.isLocked, isFalse);
    },
  );

  test('backup and restore keeps check-ins, fire, and coins', () async {
    final morning = DateTime(2026, 11, 26, 8);
    await planning.markInBed(DateTime(2026, 11, 26), onboarding);
    await planning.lockElapsedNights(morning);
    await checkIns.recordCheckIn(
      wakeDate: DateTime(2026, 11, 26),
      lightsOffAt: DateTime(2026, 11, 25, 22),
      actualWakeAt: DateTime(2026, 11, 26, 7),
      now: morning,
    );

    final backup = BackupService(db);
    final snapshot = await backup.buildSnapshot();
    await backup.deleteAllData();
    for (final table in db.allTables) {
      expect(await db.select(table).get(), isEmpty);
    }

    await backup.restoreSnapshot(snapshot);
    expect(await backup.buildSnapshot(), snapshot);
    expect((await db.select(db.checkIns).get()).length, 1);
    expect((await fire.get()).points, 1);
    expect((await db.select(db.wallets).getSingle()).coins, greaterThan(0));
  });

  test('restoring a file that is not a backup changes nothing', () async {
    await expectLater(
      BackupService(db).restoreSnapshot({'hello': 'world'}),
      throwsFormatException,
    );
    expect((await settings.get()).onboardingCompleted, isTrue);
  });
}
