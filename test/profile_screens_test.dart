import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/card_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/data/wallet_repository.dart';
import 'package:glow/features/card/card_details_sheet.dart';
import 'package:glow/features/onboarding/onboarding_screen.dart';
import 'package:glow/features/settings/settings_screen.dart';
import 'package:glow/features/share/share_screen.dart';
import 'package:glow/providers.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:glow/theme/widgets/student_card.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late CardRepository cards;

  /// A fixed number of frames, so a spinner that never stops shows up as a
  /// failed check instead of a test that never ends.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// The smallest phone the app is tested on. Anything that doesn't fit
  /// fails the test.
  Future<void> show(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(theme: GlowAppTheme.light(), home: screen),
      ),
    );
    await settle(tester);
  }

  Future<void> start() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepository(db);
    cards = CardRepository(db, WalletRepository(db));
    await settings.ensureRowExists();
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

  Finder field(String label) => find.widgetWithText(TextField, label);

  Future<void> tap(WidgetTester tester, String text) async {
    // A list only builds what is near the screen, so scroll to find it.
    if (find.text(text).evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        find.text(text),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tester.ensureVisible(find.text(text));
    await settle(tester);
    await tester.tap(find.text(text));
    await settle(tester);
  }

  testWidgets('first run: a name is needed unless skipped, and the birth '
      'date is checked', (tester) async {
    await start();
    await show(tester, const OnboardingScreen());

    await tap(tester, 'ต่อไป');
    expect(find.text('ใส่ชื่อก่อน หรือกด "ข้าม"'), findsOneWidget);

    await tester.enterText(field('ชื่อ'), 'มายด์');
    await tester.enterText(field('วันเกิด (ว/ด/ปปปป)'), '31/4/2551');
    await tap(tester, 'ต่อไป');
    expect(
      find.text('ไม่มีวันที่นี้ในปฏิทิน ลองตรวจอีกครั้ง'),
      findsOneWidget,
    );

    await tester.enterText(field('วันเกิด (ว/ด/ปปปป)'), '01052543');
    await tap(tester, 'ต่อไป');
    expect(find.text('เรียนเช้าสุดกี่โมง'), findsOneWidget);

    // Going back keeps what was typed.
    await tester.tap(find.byType(BackButton));
    await settle(tester);
    expect(find.text('มายด์'), findsOneWidget);
    await tap(tester, 'ต่อไป');
    await tap(tester, 'เริ่มใช้งาน');

    final profile = await cards.get();
    expect(profile.displayName, 'มายด์');
    expect(profile.birthDate, DateTime(2000, 5, 1));
    final row = await settings.get();
    expect(row.onboardingCompleted, isTrue);
    expect(row.ageGroup, AgeGroup.adult);
    expect(row.earliestClassMinutes, 8 * 60);
    await finish(tester);
  });

  testWidgets('first run: skipping saves nothing about the user', (
    tester,
  ) async {
    await start();
    await show(tester, const OnboardingScreen());
    await tester.enterText(field('ชื่อ'), 'พิมพ์ค้างไว้');
    await tap(tester, 'ข้าม');
    await tap(tester, 'เริ่มใช้งาน');

    expect((await cards.get()).displayName, '');
    final row = await settings.get();
    expect(row.onboardingCompleted, isTrue);
    expect(row.ageGroup, AgeGroup.under18);
    await finish(tester);
  });

  testWidgets('the profile editor fits a small phone and saves', (tester) async {
    await start();
    await show(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showCardDetailsSheet(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tap(tester, 'open');
    await tester.enterText(field('ชั้นปี'), 'ม.5');
    await tester.enterText(field('วันเกิด (ว/ด/ปปปป)'), '5/3/2551');
    await tap(tester, 'บันทึก');

    final profile = await cards.get();
    expect(profile.classYear, 'ม.5');
    expect(profile.birthDate, DateTime(2008, 3, 5));
    await finish(tester);
  });

  testWidgets('settings hides AI from an under-18 birth date', (tester) async {
    await start();
    await settings.applyAgeGroupDefaults(AgeGroup.adult);
    await show(tester, const AdvancedSettingsScreen());
    final ai = find.text('ผู้ช่วย AI', skipOffstage: false);
    await tester.scrollUntilVisible(
      find.text('ปฏิทิน'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(ai, findsWidgets);

    await cards.setBirthDate(DateTime(2012, 1, 1), now: DateTime.now());
    await settle(tester);
    expect(ai, findsNothing);
    await finish(tester);
  });

  testWidgets('a shared card has no photo until the user adds it', (
    tester,
  ) async {
    await start();
    await cards.savePhoto(img.encodeJpg(img.Image(width: 40, height: 50)));
    await show(tester, ShareScreen(monday: DateTime(2026, 11, 23)));

    Uint8List? shared() =>
        tester.widget<StudentCard>(find.byType(StudentCard)).photo;
    expect(shared(), isNull);
    await tap(tester, 'ใส่รูปถ่าย');
    expect(shared(), isNotNull);
    await finish(tester);
  });
}
