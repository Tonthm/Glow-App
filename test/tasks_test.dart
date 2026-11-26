import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_validators.dart';
import 'package:glow/core/evening_planner.dart';
import 'package:glow/core/split_scheduler.dart';
import 'package:glow/core/web_reminders.dart';
import 'package:glow/data/calendar_reminder_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/evening_repository.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/data/task_list_repository.dart';
import 'package:glow/features/tasks/task_list_screen.dart';
import 'package:glow/features/tonight/countdown_strip.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/app_clock.dart';
import 'package:glow/services/backup_service.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

/// A Thursday at noon.
final _now = DateTime(2026, 11, 26, 12);

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late NightPlanningRepository planning;
  late EveningRepository evening;
  late TaskListRepository tasks;

  Future<void> start() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepository(db);
    planning = NightPlanningRepository(db, ScheduleRepository(db), settings);
    evening = EveningRepository(db, planning, settings);
    tasks = TaskListRepository(db);
    await settings.ensureRowExists();
  }

  Future<int> add(String title, {DateTime? due, DateTime? plan}) async {
    await evening.addTask(
      title: title,
      minutes: 60,
      kind: EveningTaskKind.homework,
      planDate: plan ?? DateTime(2026, 11, 26),
      dueDate: due,
    );
    return (await db.select(db.eveningTasks).get()).last.id;
  }

  Future<TaskEntry> entry(int id) async =>
      (await tasks.entries()).singleWhere((e) => e.task.id == id);

  group('steps and parts', () {
    setUp(start);
    tearDown(() => db.close());

    test('a user adds, ticks and removes steps', () async {
      final id = await add('รายงาน');
      for (final title in ['หาข้อมูล', '  ', 'เขียน']) {
        await tasks.addStep(id, title);
      }
      var list = (await entry(id)).checklist;
      expect(list.map((i) => i.title), ['หาข้อมูล', 'เขียน']);
      await tasks.tick(list.first, true, now: _now);
      list = (await entry(id)).checklist;
      expect(list.map((i) => i.done), [true, false]);
      // Ticking steps doesn't finish the task by itself.
      expect((await entry(id)).done, isFalse);
      await tasks.removeStep(list.last.id);
      expect((await entry(id)).checklist, hasLength(1));
    });

    test("the AI's split becomes one task with a tickable checklist", () async {
      final id = await add('โครงงาน', due: DateTime(2026, 11, 30));
      await evening.acceptSplit(await entry(id).then((e) => e.task), [
        ScheduledPart(
          const AiPart(title: 'ส่วน 1', minutes: 30),
          DateTime(2026, 11, 27),
        ),
        ScheduledPart(
          const AiPart(title: 'ส่วน 2', minutes: 30),
          DateTime(2026, 11, 28),
        ),
      ], now: _now);

      expect(await tasks.entries(), hasLength(1));
      var split = await entry(id);
      expect(split.checklist.map((i) => i.title), ['ส่วน 1', 'ส่วน 2']);
      await tasks.tick(split.checklist.first, true, now: _now);
      split = await entry(id);
      expect(split.done, isFalse);
      // Each part stays on its own evening.
      expect(split.checklist.map((i) => i.planDate), [
        DateTime(2026, 11, 27),
        DateTime(2026, 11, 28),
      ]);
      await tasks.tick(split.checklist.last, true, now: _now);
      expect((await entry(id)).done, isTrue);
      await tasks.setTaskDone(id, false, now: _now);
      expect((await entry(id)).checklist.any((i) => i.done), isFalse);
    });

    test('unticking old work brings it back to tonight', () async {
      final id = await add('เก่า', plan: DateTime(2026, 11, 20));
      await tasks.setTaskDone(id, true, now: _now);
      expect((await entry(id)).done, isTrue);
      await tasks.setTaskDone(id, false, now: _now);
      final task = (await entry(id)).task;
      expect((task.status, task.doneMinutes), (taskTodo, 0));
      expect(task.planDate, DateTime(2026, 11, 26));
    });

    test('removing a task removes its steps', () async {
      final id = await add('a');
      final other = await add('b');
      await tasks.addStep(id, '1');
      await tasks.addStep(other, '2');
      await evening.removeTask(id);
      expect((await db.select(db.taskSteps).get()).single.taskId, other);
    });

    test('ticking never pays coins or touches the fire', () async {
      final id = await add('a');
      await tasks.setTaskDone(id, true, now: _now);
      expect(await db.select(db.wallets).get(), isEmpty);
      expect(await db.select(db.fireStates).get(), isEmpty);
    });

    test('steps are backed up', () async {
      final id = await add('a');
      await tasks.addStep(id, 'ขั้น');
      final backups = BackupService(db);
      final file = await backups.buildSnapshot();
      await backups.deleteAllData();
      await backups.restoreSnapshot(file);
      expect((await entry(id)).checklist.single.title, 'ขั้น');
    });
  });

  group('reminders in the web calendar', () {
    late CalendarReminderRepository calendar;

    setUp(() async {
      await start();
      calendar = CalendarReminderRepository(db, planning, settings);
      await settings.updateNotificationToggles(
        putPhoneDown: false,
        bedtime: false,
        busyNight: false,
        checkIn: false,
      );
      await ScheduleRepository(db).addWeeklyItem(
        title: 'คณิต',
        dayOfWeek: DateTime.friday,
        startMinutes: 8 * 60,
        endMinutes: 9 * 60,
        type: WeeklyItemType.classSession,
      );
      await add('รายงาน', due: DateTime(2026, 11, 28));
    });
    tearDown(() => db.close());

    test('are left out until the user turns them on', () async {
      expect(await calendar.generate(_now), isNull);
    });

    test('are added once on, and count as up to date', () async {
      await settings.updateTaskReminders(deadline: true, beforeClass: true);
      final file = (await calendar.generate(_now))!;
      expect(file.events.map((e) => e.start), [
        // 15 minutes before Friday's class, then the evening before the due
        // day (Friday), then next week's class.
        DateTime(2026, 11, 27, 7, 45),
        DateTime(2026, 11, 27, 18),
      ]);
      final text = file.text.replaceAll('\r\n ', '');
      expect(text, contains('SUMMARY:Glow · อีก 15 นาทีเริ่มคาบ คณิต'));
      expect(text, contains('SUMMARY:Glow · พรุ่งนี้มีงานต้องส่ง'));
      expect(await calendar.status(_now), CalendarReminderStatus.upToDate);
    });

    test('with only these on, nothing says it is running out for days', () async {
      await settings.updateTaskReminders(deadline: true);
      await calendar.generate(_now);
      for (final later in [_now, _now.add(const Duration(days: 3))]) {
        expect(await calendar.status(later), CalendarReminderStatus.upToDate);
      }
      expect(
        await calendar.status(_now.add(const Duration(days: 6))),
        CalendarReminderStatus.runningOut,
      );
    });

    test('finishing the task marks the calendar as out of date', () async {
      await settings.updateTaskReminders(deadline: true);
      await calendar.generate(_now);
      final id = (await db.select(db.eveningTasks).getSingle()).id;
      await tasks.setTaskDone(id, true, now: _now);
      expect(await calendar.status(_now), CalendarReminderStatus.planChanged);
    });
  });

  group('screens', () {
    Future<void> show(WidgetTester tester, Widget screen) async {
      useSmallPhone(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            clockProvider.overrideWithValue(() => _now),
          ],
          child: MaterialApp(theme: GlowAppTheme.light(), home: screen),
        ),
      );
      await settle(tester);
    }

    testWidgets('filters by doing, missed and done', (tester) async {
      await start();
      await add('งานใหม่', due: DateTime(2026, 11, 30));
      await add('งานเลย', due: DateTime(2026, 11, 20));
      final done = await add('งานจบ');
      await tasks.setTaskDone(done, true, now: _now);
      await show(tester, const TaskListScreen());

      expect(find.text('งานใหม่'), findsOneWidget);
      expect(find.text('งานเลย'), findsNothing);
      await tapOn(tester, find.text('พลาด 1'));
      expect(find.text('งานเลย'), findsOneWidget);
      expect(find.text('งานใหม่'), findsNothing);
      await tapOn(tester, find.text('เสร็จ 1'));
      expect(find.text('งานจบ'), findsOneWidget);

      // Ticking a missed task moves it to done.
      await tapOn(tester, find.text('พลาด 1'));
      await tapOn(tester, find.byType(Checkbox));
      expect(find.text('เสร็จ 2'), findsOneWidget);
      await closeDatabase(tester, db);
    });

    testWidgets('steps are added and ticked, with progress', (tester) async {
      await start();
      await add('รายงาน');
      await show(tester, const TaskListScreen());
      await tapOn(tester, find.text('รายงาน'));
      for (final step in ['หนึ่ง', 'สอง']) {
        await tester.enterText(find.byType(TextField), step);
        await tapOn(tester, find.byTooltip('เพิ่มงานย่อยนี้'));
      }
      await tapOn(tester, find.text('หนึ่ง'));
      // On the sheet and on the card behind it.
      expect(find.text('1/2'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await closeDatabase(tester, db);
    });

    testWidgets('home counts down and points back to sleep', (tester) async {
      await start();
      await db
          .into(db.oneTimeItems)
          .insert(
            OneTimeItemsCompanion.insert(
              title: 'เคมี',
              date: DateTime(2026, 11, 29),
              type: OneTimeItemType.exam,
              startMinutes: const Value(9 * 60),
              endMinutes: const Value(11 * 60),
            ),
          );
      await add('รายงาน', due: DateTime(2026, 11, 30));
      await show(tester, const Scaffold(body: CountdownStrip()));

      expect(find.text('สอบ เคมี'), findsOneWidget);
      expect(find.text('อีก 3 วัน'), findsOneWidget);
      expect(find.text('ส่ง รายงาน'), findsOneWidget);
      expect(find.text('สอบอีก 3 วัน เริ่มนอนตามแผนไว้'), findsOneWidget);
      await closeDatabase(tester, db);
    });

    testWidgets('with nothing near, the strip takes no room', (tester) async {
      await start();
      await show(
        tester,
        const Scaffold(body: Column(children: [CountdownStrip()])),
      );
      expect(tester.getSize(find.byType(CountdownStrip)).height, 0);
      await closeDatabase(tester, db);
    });
  });
}
