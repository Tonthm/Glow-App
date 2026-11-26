import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/data/subject_color_repository.dart';
import 'package:glow/features/schedule/weekly_item_form.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/backup_service.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:glow/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

void main() {
  late AppDatabase db;
  late SubjectColorRepository colors;

  Future<void> start() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    colors = SubjectColorRepository(db);
    await SettingsRepository(db).ensureRowExists();
  }

  Future<void> openForm(WidgetTester tester, {WeeklyItem? existing}) async {
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: GlowAppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    showWeeklyItemForm(context, existing: existing),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tapOn(tester, find.text('open'));
  }

  testWidgets('one save makes a class on every chosen day, in the picked '
      'color', (tester) async {
    await start();
    await openForm(tester);
    await tester.enterText(find.byType(TextField).first, 'ชีวะ');
    await settle(tester);
    // Monday is already chosen.
    await tapOn(tester, find.text('พุธ'));
    await tapOn(tester, find.text('ศุกร์'));
    await tapOn(tester, find.bySemanticsLabel('สีเขียว'));
    await tapOn(tester, find.text('บันทึก'));

    final rows = await db.select(db.weeklyItems).get();
    expect(rows.map((r) => r.dayOfWeek), [1, 3, 5]);
    expect(rows.every((r) => r.title == 'ชีวะ'), isTrue);
    expect(await colors.all(), {'ชีวะ': GlowSubjectColors.all['เขียว']});
    await closeDatabase(tester, db);
  });

  testWidgets('with no day chosen it cannot be saved', (tester) async {
    await start();
    await openForm(tester);
    await tester.enterText(find.byType(TextField).first, 'ชีวะ');
    await tapOn(tester, find.text('จันทร์'));
    expect(find.text('เลือกอย่างน้อย 1 วัน'), findsOneWidget);
    await tapOn(tester, find.text('บันทึก'));
    expect(await db.select(db.weeklyItems).get(), isEmpty);
    await closeDatabase(tester, db);
  });

  testWidgets('editing keeps the saved color unless changed', (tester) async {
    await start();
    await ScheduleRepository(db).addWeeklyItem(
      title: 'ชีวะ',
      dayOfWeek: 2,
      startMinutes: 480,
      endMinutes: 540,
      type: WeeklyItemType.classSession,
      source: ItemSource.calendar,
      calendarEventId: 'abc',
    );
    await colors.set('ชีวะ', 0xFF123456);
    await openForm(
      tester,
      existing: await db.select(db.weeklyItems).getSingle(),
    );
    await tapOn(tester, find.text('บันทึก'));
    expect(await colors.all(), {'ชีวะ': 0xFF123456});
    // What the calendar import stored is still there.
    final row = await db.select(db.weeklyItems).getSingle();
    expect((row.source, row.calendarEventId), (ItemSource.calendar, 'abc'));
    await closeDatabase(tester, db);
  });

  test('colors are one per name, can be cleared, and are backed up', () async {
    await start();
    await colors.set(' Physics ', 1);
    await colors.set('physics', 2);
    await colors.set('เคมี', 3);
    await colors.set('', 4);
    expect(await colors.all(), {'physics': 2, 'เคมี': 3});
    await colors.set('เคมี', null);
    expect(await colors.all(), {'physics': 2});

    final backups = BackupService(db);
    final file = await backups.buildSnapshot();
    await backups.deleteAllData();
    expect(await colors.all(), isEmpty);
    await backups.restoreSnapshot(file);
    expect(await colors.all(), {'physics': 2});
    await db.close();
  });
}
