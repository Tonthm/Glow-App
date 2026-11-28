/// The sleep tab (CLAUDE.md section 1): the default tab, in order of
/// importance, on the smallest phone the app is tested on and a usual one.
library;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/sleep_cycles.dart';
import 'package:material_ui/material_ui.dart';

import 'package:glow/data/database.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/demo/demo_data.dart';
import 'package:glow/features/tonight/tonight_scene.dart';
import 'package:glow/main.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/notification_service_web.dart'
    as web_notifications;
import 'package:glow/services/permissions_service_web.dart' as web_permissions;
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:glow/services/app_clock.dart';
import 'package:glow/theme/widgets/glow_mascot.dart';
import 'package:glow/theme/widgets/glow_card.dart';

import 'helpers.dart';

/// A Tuesday evening, when the activity card is already showing.
final _now = DateTime(2026, 12, 1, 20, 30);

Future<AppDatabase> _open(
  WidgetTester tester,
  Size size, {
  DateTime? now,
  Future<void> Function(AppDatabase)? prepare,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.runAsync(() async {
    await resetDemoData(db, DateTime(2026, 12, 1));
    if (prepare != null) await prepare(db);
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now ?? _now),
        // The web version, the main platform.
        platformCapabilitiesProvider.overrideWithValue(
          PlatformCapabilities.web,
        ),
        permissionsServiceProvider.overrideWithValue(
          web_permissions.createPermissionsService(),
        ),
        notificationServiceProvider.overrideWithValue(
          web_notifications.createNotificationService(
            web_permissions.createPermissionsService(),
          ),
        ),
      ],
      child: const GlowApp(),
    ),
  );
  await settle(tester);
  await settle(tester);
  return db;
}

double _top(WidgetTester tester, String text) =>
    tester.getTopLeft(find.text(text).first).dy;

void main() {
  testWidgets('opens on the sleep tab with its parts in order', (tester) async {
    // Tall, so that every part is built.
    final db = await _open(tester, const Size(393, 1800));

    expect(find.text('นอน'), findsOneWidget);
    expect(find.text('คืนนี้'), findsNothing);
    final order = [
      'เข้านอนคืนนี้',
      'แผนช่วงเย็น',
      'ช่วงก่อนนอน',
      'เข้านอนแล้ว',
      'สัปดาห์นี้และเควส',
      'บัตรของฉัน',
    ].map((text) => _top(tester, text)).toList();
    expect(order, [...order]..sort());

    await closeDatabase(tester, db);
  });

  testWidgets('navigation keeps touch targets on a small phone', (
    tester,
  ) async {
    final db = await _open(tester, const Size(320, 640));
    for (final label in ['นอน', 'ตาราง', 'สถิติ', 'บัตร']) {
      final target = find.ancestor(
        of: find.text(label),
        matching: find.byType(InkWell),
      );
      final size = tester.getSize(target);
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
    await closeDatabase(tester, db);
  });

  testWidgets('the evening card opens the whole evening', (tester) async {
    final db = await _open(tester, const Size(393, 852));
    await tapOn(tester, find.text('แผนช่วงเย็น'));
    expect(find.text('ตารางเย็นนี้'), findsOneWidget);
    await closeDatabase(tester, db);
  });

  testWidgets('the cycle bar says it is an estimate and why', (tester) async {
    final db = await _open(tester, const Size(320, 1800));
    expect(find.textContaining(RegExp(r'^ประมาณ .* รอบ')), findsOneWidget);
    expect(find.text(cycleDisclaimer), findsOneWidget);
    for (final part in ['fall-asleep', 'cycle-1']) {
      final size = tester.getSize(find.byKey(ValueKey(part)));
      expect(size.height, 6, reason: '$part follows the compact mockup');
      expect(size.width, greaterThan(4), reason: part);
    }
    // Nothing claims to know what kind of sleep any part is.
    expect(find.textContaining('REM'), findsNothing);
    expect(find.textContaining('หลับลึก'), findsNothing);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });

  testWidgets('stats show the estimated average cycles a night', (
    tester,
  ) async {
    final db = await _open(tester, const Size(393, 2000));
    await tapOn(tester, find.text('สถิติ'));
    expect(
      find.textContaining(RegExp(r'^เฉลี่ยต่อคืน ประมาณ .* รอบ \(7 วันล่าสุด')),
      findsOneWidget,
    );
    expect(find.textContaining('ค่าประมาณจากเวลาที่เช็กอิน'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });

  testWidgets('fits the smallest phone', (tester) async {
    final db = await _open(tester, const Size(320, 640));
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });

  for (final width in [320.0, 393.0, 520.0]) {
    testWidgets('scene keeps artwork and card overlap at $width dp', (
      tester,
    ) async {
      final db = await _open(tester, Size(width, 1800));
      final background = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/scenes/tonight_light.webp',
      );
      final card = find.ancestor(
        of: find.text('เข้านอนคืนนี้'),
        matching: find.byType(GlowCard),
      );
      final imageBounds = tester.getRect(background);
      expect(imageBounds.width / imageBounds.height, closeTo(1.5, .001));
      expect(imageBounds.bottom - tester.getRect(card).top, closeTo(10, .001));
      expect(tester.takeException(), isNull);
      await closeDatabase(tester, db);
    });
  }

  testWidgets('scene follows theme and remains usable with large Thai text', (
    tester,
  ) async {
    final db = await _open(tester, const Size(320, 640));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await settle(tester);
    Finder background(String theme) => find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/scenes/tonight_$theme.webp',
    );
    expect(background('light'), findsOneWidget);
    await tester.runAsync(
      () => SettingsRepository(db).updateThemeMode(AppThemeMode.dark),
    );
    await settle(tester);
    expect(background('dark'), findsOneWidget);
    await tapOn(tester, find.text('เข้านอนแล้ว'));
    await tester.scrollUntilVisible(
      find.byType(TonightScene),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    expect(find.text('ฝันดีนะ พักให้เต็มที่'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byType(GlowMascot)).dy,
      greaterThanOrEqualTo(
        tester
            .getBottomLeft(find.text('บอกว่าเข้านอนแล้ว · แล้วเจอกันตอนเช้า'))
            .dy,
      ),
    );
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });

  testWidgets('first appointment uses the real exam title and time', (
    tester,
  ) async {
    const title = 'การออกแบบระบบและประสบการณ์ผู้ใช้งานดิจิทัล';
    final db = await _open(
      tester,
      const Size(320, 1800),
      prepare: (db) => ScheduleRepository(db)
          .addOneTimeItem(
            title: title,
            date: DateTime(2026, 12, 2),
            type: OneTimeItemType.exam,
            startMinutes: 7 * 60,
            endMinutes: 8 * 60,
          )
          .then((_) {}),
    );
    expect(find.text('พรุ่งนี้ · สอบวิชาแรก'), findsOneWidget);
    expect(find.text(title).first, findsOneWidget);
    expect(find.text('07:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });

  testWidgets('a free day has no invented class or time', (tester) async {
    final db = await _open(
      tester,
      const Size(320, 1800),
      prepare: (db) async {
        await db.delete(db.weeklyItems).go();
        await db.delete(db.oneTimeItems).go();
        await SettingsRepository(db).updateEarliestClass(8 * 60);
        await ScheduleRepository(db).addOneTimeItem(
          title: 'วันหยุด',
          date: DateTime(2026, 12, 2),
          type: OneTimeItemType.holiday,
        );
      },
    );
    expect(find.byType(TonightScene), findsOneWidget);
    expect(find.text('พรุ่งนี้ · วันว่าง'), findsOneWidget);
    expect(find.text('ไม่มีนัดในตาราง'), findsOneWidget);
    expect(find.text('เรียนเช้าสุดที่บอกไว้'), findsNothing);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });

  testWidgets('mascot follows bedtime and undo on a small phone', (
    tester,
  ) async {
    final db = await _open(tester, const Size(320, 640));
    GlowMascotPose pose() =>
        tester.widget<GlowMascot>(find.byType(GlowMascot)).pose;
    expect(pose(), GlowMascotPose.ready);
    await tapOn(tester, find.text('เข้านอนแล้ว'));
    await tester.scrollUntilVisible(
      find.byType(GlowMascot),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    expect(pose(), GlowMascotPose.sleeping);
    await tapOn(tester, find.text('ยังไม่นอน'));
    await tester.scrollUntilVisible(
      find.byType(GlowMascot),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    expect(pose(), GlowMascotPose.ready);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });
}
