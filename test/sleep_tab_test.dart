/// The sleep tab (CLAUDE.md section 1): the default tab, in order of
/// importance, on the smallest phone the app is tested on and a usual one.
library;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/sleep_cycles.dart';
import 'package:material_ui/material_ui.dart';

import 'package:glow/data/database.dart';
import 'package:glow/features/demo/demo_data.dart';
import 'package:glow/main.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/notification_service_web.dart'
    as web_notifications;
import 'package:glow/services/permissions_service_web.dart' as web_permissions;
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:glow/services/app_clock.dart';

import 'helpers.dart';

/// A Tuesday evening, when the activity card is already showing.
final _now = DateTime(2026, 12, 1, 20, 30);

Future<AppDatabase> _open(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.runAsync(() => resetDemoData(db, DateTime(2026, 12, 1)));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => _now),
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

  testWidgets('the sleep tab icon is the biggest', (tester) async {
    final db = await _open(tester, const Size(393, 852));
    final sleep = tester.widget<Icon>(find.byIcon(Icons.bedtime));
    final other = tester.widget<Icon>(
      find.byIcon(Icons.calendar_today_outlined).last,
    );
    expect(sleep.size, greaterThan(other.size!));
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
      expect(size.height, 14, reason: '$part must be visible');
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
}
