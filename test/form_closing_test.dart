/// Closing a screen that has a mic, without ever using it, must not fail.
library;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/evening/task_form_sheet.dart';
import 'package:glow/features/schedule/voice_input_screen.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

void main() {
  late AppDatabase db;

  Future<void> show(
    WidgetTester tester,
    Future<void> Function(BuildContext context) open,
  ) async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await SettingsRepository(db).ensureRowExists();
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          platformCapabilitiesProvider.overrideWithValue(
            PlatformCapabilities.web,
          ),
          // No mic button, so nothing touches speech while it is open.
          deviceHasSpeechProvider.overrideWithValue(false),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => open(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tapOn(tester, find.text('open'));
  }

  testWidgets('saving a new task', (tester) async {
    await show(
      tester,
      (context) => showTaskForm(context, planDate: DateTime(2026, 11, 26)),
    );
    await tester.enterText(find.byType(TextField).first, 'เลข');
    await settle(tester);
    await tapOn(tester, find.text('บันทึก'));
    expect(tester.takeException(), isNull);
    expect(await db.select(db.eveningTasks).get(), hasLength(1));
    await closeDatabase(tester, db);
  });

  testWidgets('leaving the sentence page', (tester) async {
    await show(
      tester,
      (context) => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const VoiceInputScreen()),
      ),
    );
    await tester.pageBack();
    await settle(tester);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });
}
