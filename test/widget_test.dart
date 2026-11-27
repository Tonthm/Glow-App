import 'dart:ui' show PointerDeviceKind;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/onboarding/welcome_page.dart';
import 'package:glow/main.dart';
import 'package:glow/providers.dart';

import 'helpers.dart';

void main() {
  testWidgets('tooltips survive resizing the centered app', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    tooltip: 'ตรวจคำอธิบาย',
                    onPressed: () {},
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            ),
          ),
        );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byTooltip('ตรวจคำอธิบาย')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('ตรวจคำอธิบาย'), findsOneWidget);
    tester.view.physicalSize = const Size(1440, 1000);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
    await closeDatabase(tester, db);
  });
  testWidgets('saved theme applies to routes opened from the app', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await SettingsRepository(db).ensureRowExists();
    await SettingsRepository(db).updateThemeMode(AppThemeMode.dark);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('หน้าถัดไป')),
          ),
        );
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('หน้าถัดไป'))).brightness,
      Brightness.dark,
    );
    await closeDatabase(tester, db);
  });
  for (final width in [320.0, 1440.0]) {
    testWidgets('onboarding fits a fresh install at $width wide', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      // The real databaseProvider opens a file via path_provider, which has no
      // platform-channel implementation under plain `flutter test` — use an
      // in-memory database instead, as in db_open_smoke_test.dart. Held here
      // (via overrideWithValue, so the provider's own ref.onDispose never
      // runs) and closed explicitly below, so drift's internal cleanup timer
      // fires inside the test instead of during ProviderScope's own teardown,
      // which the test invariant check can't tolerate.
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const GlowApp(),
        ),
      );
      await tester.pumpAndSettle();

      // The card first, then the two questions about sleep.
      expect(find.text(WelcomePage.headline), findsOneWidget);
      expect(
        tester.getSize(find.byType(Navigator)).width,
        width.clamp(0.0, 520.0),
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('ข้าม'));
      await tester.pumpAndSettle();
      expect(find.text('เรียนเช้าสุดกี่โมง'), findsOneWidget);
      expect(find.text('เวลาเดินทางไปเรียน'), findsOneWidget);

      await db.close();
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
