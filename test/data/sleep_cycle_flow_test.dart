/// Sleep cycles through the real database (CLAUDE.md section 20).
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/services/backup_service.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late NightPlanningRepository planning;

  // Monday 2026-11-30, and the evening before it.
  final monday = DateTime(2026, 11, 30);
  DateTime sunday(int hour, int minute) => DateTime(2026, 11, 29, hour, minute);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepository(db);
    planning = NightPlanningRepository(db, ScheduleRepository(db), settings);
    await settings.ensureRowExists();
    await settings.markOnboardingCompleted(DateTime(2026, 11, 20));
    await ScheduleRepository(db).addWeeklyItem(
      title: 'คณิต',
      dayOfWeek: DateTime.monday,
      startMinutes: 8 * 60,
      endMinutes: 12 * 60,
      type: WeeklyItemType.classSession,
    );
  });

  tearDown(() => db.close());

  test('on by default: bedtime moves earlier to six cycles', () async {
    final draft = await planning.computeDraftForWakeDate(monday);
    expect(draft.wakeTime, DateTime(2026, 11, 30, 6, 35));
    expect(draft.bedtime, sunday(21, 20));
    final cycles = await planning.cyclesFor(draft);
    expect(cycles.shiftMinutes, 30);
    expect(cycles.cycleMinutes, 90);
    expect(cycles.sleepMinutes, 540);
    expect(cycles.fallAsleepMinutes, 15);
  });

  test('switched off, the formula alone decides', () async {
    await settings.updateCycles(align: false);
    final draft = await planning.computeDraftForWakeDate(monday);
    expect(draft.bedtime, sunday(21, 50));
    final cycles = await planning.cyclesFor(draft);
    expect(cycles.shiftMinutes, 0);
    expect(cycles.sleepMinutes, 510);
  });

  test('no night of a week is later or shorter than without cycles', () async {
    final on = await planning.computeWeekDrafts(monday);
    await settings.updateCycles(align: false);
    final off = await planning.computeWeekDrafts(monday);
    for (var i = 0; i < 7; i++) {
      expect(on[i].bedtime.isAfter(off[i].bedtime), isFalse, reason: '$i');
      expect(on[i].wakeTime, off[i].wakeTime);
    }
  });

  test('the saved length stays within 70 to 100 minutes', () async {
    await settings.updateCycles(minutes: 40);
    expect((await settings.get()).cycleMinutes, 70);
    await settings.updateCycles(minutes: 130);
    expect((await settings.get()).cycleMinutes, 100);
  });

  test('a locked night keeps its time and its reason', () async {
    await planning.getOrLockPlan(monday, now: sunday(20, 30));
    expect((await planning.getPlanRow(monday))!.cycleShiftMinutes, 30);

    await settings.updateCycles(align: false, minutes: 100);
    final draft = await planning.currentPlan(monday);
    expect(draft.bedtime, sunday(21, 20));
    final cycles = await planning.cyclesFor(draft);
    expect((cycles.shiftMinutes, cycles.cycleMinutes), (30, 90));
  });

  test('backups keep the choices; older files get the defaults', () async {
    final backup = BackupService(db);
    await settings.updateCycles(align: false, minutes: 80);
    await planning.getOrLockPlan(monday, now: sunday(23, 0));
    final snapshot = await backup.buildSnapshot();
    await backup.deleteAllData();
    await backup.restoreSnapshot(snapshot);
    var row = await settings.get();
    expect((row.cycleAlignEnabled, row.cycleMinutes), (false, 80));
    expect((await planning.getPlanRow(monday))!.cycleMinutes, 80);

    final old = <String, dynamic>{...snapshot, 'version': 12};
    old['settings'] = {...snapshot['settings'] as Map<String, dynamic>}
      ..remove('cycleAlignEnabled')
      ..remove('cycleMinutes');
    old['nightPlans'] = [
      for (final plan in snapshot['nightPlans'] as List)
        {...plan as Map<String, dynamic>}
          ..remove('cycleShiftMinutes')
          ..remove('cycleMinutes'),
    ];
    await backup.restoreSnapshot(old);
    row = await settings.get();
    expect((row.cycleAlignEnabled, row.cycleMinutes), (true, 90));
    expect((await planning.getPlanRow(monday))!.cycleShiftMinutes, isNull);
  });
}
