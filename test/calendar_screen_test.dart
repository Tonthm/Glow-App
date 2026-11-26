import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/schedule/month_view.dart';
import 'package:glow/features/schedule/schedule_screen.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/app_clock.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

/// A Thursday.
final _now = DateTime(2026, 11, 26, 20);

void main() {
  late AppDatabase db;
  late SettingsRepository settings;

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> seed() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepository(db);
    await settings.ensureRowExists();
    await db
        .into(db.weeklyItems)
        .insert(
          WeeklyItemsCompanion.insert(
            title: 'คณิตศาสตร์เพิ่มเติม',
            dayOfWeek: DateTime.thursday,
            startMinutes: 8 * 60,
            endMinutes: 10 * 60,
            type: WeeklyItemType.classSession,
          ),
        );
    await db
        .into(db.oneTimeItems)
        .insert(
          OneTimeItemsCompanion.insert(
            title: 'สอบเคมี',
            date: DateTime(2026, 11, 26),
            type: OneTimeItemType.exam,
            startMinutes: const Value(13 * 60),
            endMinutes: const Value(15 * 60),
          ),
        );
    await db
        .into(db.oneTimeItems)
        .insert(
          OneTimeItemsCompanion.insert(
            title: 'วันหยุดพิเศษ',
            date: DateTime(2026, 11, 27),
            type: OneTimeItemType.holiday,
          ),
        );
    await db
        .into(db.eveningTasks)
        .insert(
          EveningTasksCompanion.insert(
            title: 'การบ้านฟิสิกส์',
            minutes: 30,
            kind: 0,
            planDate: DateTime(2026, 11, 26),
          ),
        );
  }

  Future<void> show(
    WidgetTester tester, {
    double textScale = 1,
    ThemeData? theme,
  }) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => _now),
        ],
        child: MaterialApp(
          theme: theme ?? GlowAppTheme.light(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const ScheduleScreen(),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    // Closing waits on timers, which only run when the test clock moves.
    var closed = false;
    db.close().then((_) => closed = true);
    for (var i = 0; i < 50 && !closed; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(closed, isTrue, reason: 'the database did not close');
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
    await settle(tester);
  }

  List<double> columnOrder(WidgetTester tester, List<String> labels) => [
    for (final label in labels)
      tester
          .getCenter(
            find.descendant(
              of: find.byType(MonthView),
              matching: find.text(label),
            ),
          )
          .dx,
  ];

  for (final (name, theme, scale) in [
    ('light', GlowAppTheme.light(), 1.0),
    ('dark, large text', GlowAppTheme.dark(), 1.6),
  ]) {
    testWidgets('month, week and day fit a small phone ($name)', (tester) async {
      await seed();
      await show(tester, theme: theme, textScale: scale);

      expect(find.text('พฤศจิกายน 2569'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tap(tester, find.text('สัปดาห์'));
      expect(find.text('22–28 พ.ย. 2569'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tap(tester, find.text('วัน'));
      expect(find.text('พฤหัสบดี 26 พ.ย. 2569'), findsOneWidget);
      expect(find.text('การบ้านฟิสิกส์'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await finish(tester);
    });
  }

  testWidgets('weeks start on Sunday unless set to Monday', (tester) async {
    await seed();
    await show(tester);
    var x = columnOrder(tester, ['อา', 'จ', 'ส']);
    expect(x[0] < x[1] && x[1] < x[2], isTrue);

    await settings.updateCalendarFirstWeekday(DateTime.monday);
    await settle(tester);
    x = columnOrder(tester, ['จ', 'ส', 'อา']);
    expect(x[0] < x[1] && x[1] < x[2], isTrue);
    await finish(tester);
  });

  testWidgets('arrows, swipes and "today" move between months', (tester) async {
    await seed();
    await show(tester);
    await tap(tester, find.byTooltip('เดือนถัดไป'));
    await tap(tester, find.byTooltip('เดือนถัดไป'));
    expect(find.text('มกราคม 2570'), findsOneWidget);
    await tester.fling(find.byType(MonthView), const Offset(200, 0), 1000);
    await settle(tester);
    expect(find.text('ธันวาคม 2569'), findsOneWidget);
    await tap(tester, find.text('วันนี้'));
    expect(find.text('พฤศจิกายน 2569'), findsOneWidget);
    await finish(tester);
  });

  Finder day(String start) =>
      find.bySemanticsLabel(RegExp('^${RegExp.escape(start)}'));

  testWidgets('a day lists its classes, exam and task', (tester) async {
    await seed();
    await show(tester);
    expect(
      day('พฤหัสบดี 26 พ.ย. 2569 วันนี้ สอบ 1 เรียน 1 งาน 1'),
      findsOneWidget,
    );
    await tap(tester, day('พฤหัสบดี 26 พ.ย.'));
    expect(find.text('คณิตศาสตร์เพิ่มเติม'), findsOneWidget);
    expect(find.text('สอบเคมี'), findsOneWidget);
    expect(find.text('การบ้านฟิสิกส์'), findsOneWidget);
    expect(find.text('เรียน · 08:00–10:00 · ทุกสัปดาห์'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('adding from a day fills in that day', (tester) async {
    await seed();
    await show(tester);
    // Wednesday 18 November.
    await tap(tester, day('พุธ 18 พ.ย.'));
    expect(find.text('วันนี้ยังว่าง'), findsOneWidget);

    await tap(tester, find.text('เพิ่มในวันนี้'));
    await tap(tester, find.text('ครั้งเดียว'));
    await tester.enterText(find.byType(TextField).last, 'สอบย่อย');
    await settle(tester);
    await tap(tester, find.text('บันทึก'));
    final once = await (db.select(
      db.oneTimeItems,
    )..where((t) => t.title.equals('สอบย่อย'))).getSingle();
    expect(once.date, DateTime(2026, 11, 18));
    // The open list shows it at once.
    expect(find.text('สอบย่อย'), findsOneWidget);

    await tap(tester, find.text('เพิ่มในวันนี้'));
    await tap(tester, find.text('ประจำสัปดาห์'));
    await tester.enterText(find.byType(TextField).last, 'ชมรม');
    await settle(tester);
    await tap(tester, find.text('บันทึก'));
    final weekly = await (db.select(
      db.weeklyItems,
    )..where((t) => t.title.equals('ชมรม'))).getSingle();
    expect(weekly.dayOfWeek, DateTime.wednesday);
    await finish(tester);
  });

  testWidgets('tapping an empty hour adds at that day and time', (tester) async {
    await seed();
    await show(tester);
    await tap(tester, find.text('สัปดาห์'));
    await tap(tester, day('เพิ่มวันอังคาร 24 11 นาฬิกา'));
    await tap(tester, find.text('ครั้งเดียว'));
    await tester.enterText(find.byType(TextField).last, 'นัดหมอ');
    await settle(tester);
    await tap(tester, find.text('บันทึก'));
    final item = await (db.select(
      db.oneTimeItems,
    )..where((t) => t.title.equals('นัดหมอ'))).getSingle();
    expect(item.date, DateTime(2026, 11, 24));
    expect((item.startMinutes, item.endMinutes), (11 * 60, 12 * 60));
    await finish(tester);
  });
}
