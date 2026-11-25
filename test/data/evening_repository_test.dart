import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/evening_planner.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/evening_repository.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/services/backup_service.dart';

void main() {
  late AppDatabase db;
  late EveningRepository evening;

  final monday = DateTime(2026, 11, 23);
  final tuesday = DateTime(2026, 11, 24);
  DateTime at(int hour, [int minute = 0]) =>
      DateTime(2026, 11, 23, hour, minute);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final settings = SettingsRepository(db);
    await settings.ensureRowExists();
    evening = EveningRepository(
      db,
      NightPlanningRepository(db, ScheduleRepository(db), settings),
      settings,
    );
  });

  tearDown(() => db.close());

  Future<int> add(String title, int minutes, {DateTime? on}) => evening.addTask(
    title: title,
    minutes: minutes,
    kind: EveningTaskKind.homework,
    planDate: on ?? monday,
  );

  test('tonight\'s tasks are planned and end before the reminder', () async {
    await add('เลข', 60);
    final view = await evening.load(at(16));
    expect(view.tasks.single.title, 'เลข');
    for (final block in view.plan.blocks) {
      expect(block.end.isAfter(view.notifyTime), isFalse);
    }
  });

  test('unfinished work moves to tomorrow once the plan locks', () async {
    await add('เลข', 60);
    // A free evening: bedtime 22:45, so the reminder is 21:45.
    await evening.carryOverLockedTasks(at(21, 44));
    expect((await db.select(db.eveningTasks).getSingle()).planDate, monday);

    await evening.carryOverLockedTasks(at(21, 45));
    final moved = await db.select(db.eveningTasks).getSingle();
    expect(moved.planDate, tuesday);
    expect(moved.carried, isTrue);

    // Running it again doesn't push it further.
    await evening.carryOverLockedTasks(at(23));
    expect((await db.select(db.eveningTasks).getSingle()).planDate, tuesday);
  });

  test('old tasks catch up to today after days away', () async {
    await add('เลข', 30, on: DateTime(2026, 11, 18));
    await evening.carryOverLockedTasks(at(16));
    expect((await db.select(db.eveningTasks).getSingle()).planDate, monday);
  });

  test('finishing a block keeps the rest and moves it up', () async {
    final id = await add('รายงาน', 90);
    await evening.finishBlock(id, 50, at(17, 30));
    var view = await evening.load(at(17, 30));
    expect(view.tasks.single.doneMinutes, 50);
    final next = view.plan.blocks.firstWhere((b) => b.taskId == id);
    expect(next.start.isBefore(at(17, 30)), isFalse);

    await evening.finishBlock(id, 40, at(18, 30));
    view = await evening.load(at(18, 30));
    expect(view.tasks, isEmpty);
    expect(view.doneTasks.single.title, 'รายงาน');
  });

  test('a hand-made order sticks', () async {
    await add('ก', 20);
    await add('ข', 20);
    var view = await evening.load(at(16));
    await evening.move(view.tasks, 1, -1);
    view = await evening.load(at(16));
    expect([for (final t in view.tasks) t.title], ['ข', 'ก']);
  });

  test('postponing moves one task to tomorrow', () async {
    final id = await add('เลข', 30);
    await evening.postpone(id);
    expect((await evening.load(at(16))).tasks, isEmpty);
  });

  test('tasks are part of backup and delete-all', () async {
    await add('เลข', 30);
    final backup = BackupService(db);
    final snapshot = await backup.buildSnapshot();
    await backup.deleteAllData();
    expect(await db.select(db.eveningTasks).get(), isEmpty);
    await backup.restoreSnapshot(snapshot);
    expect((await db.select(db.eveningTasks).getSingle()).title, 'เลข');
  });
}
