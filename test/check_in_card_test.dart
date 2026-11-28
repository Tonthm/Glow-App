/// The wake time on the morning card (CLAUDE.md section 6): the press says
/// it, and the plan is never used to fill it in.
library;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/tonight/check_in_result_screen.dart';
import 'package:glow/main.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/app_clock.dart';
import 'package:glow/services/notification_service_web.dart'
    as web_notifications;
import 'package:glow/services/permissions_service_web.dart' as web_permissions;
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:glow/theme/widgets/glow_mascot.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

/// Tuesday. With class at 08:00 the planned wake time is 06:35.
DateTime _tuesday(int hour, int minute) => DateTime(2026, 12, 1, hour, minute);

const _confirm = 'ตื่นแล้ว · ใช่ ตามนี้';
const _pick = 'เลือกเวลาตื่น';
const _justNow = 'เพิ่งตื่นตอนนี้';

void main() {
  late AppDatabase db;
  late DateTime now;

  Future<void> open(WidgetTester tester, DateTime at) async {
    now = at;
    tester.view.physicalSize = const Size(320, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.runAsync(() async {
      final settings = SettingsRepository(db);
      await settings.ensureRowExists();
      await settings.updateEarliestClass(8 * 60);
      await settings.markOnboardingCompleted(DateTime(2026, 11, 30, 12));
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => now),
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
  }

  Future<List<CheckInRow>> saved(WidgetTester tester) async =>
      (await tester.runAsync(() => db.select(db.checkIns).get()))!;

  /// The saved wake time, after the result page has shown.
  Future<DateTime> savedWake(WidgetTester tester) async {
    expect(find.byType(CheckInResultScreen), findsOneWidget);
    final rows = await saved(tester);
    return rows.singleWhere((r) => r.wakeDate == _tuesday(0, 0)).actualWakeAt;
  }

  testWidgets('shows now, not the planned time, and saves the press', (
    tester,
  ) async {
    await open(tester, _tuesday(6, 52));
    expect(
      tester.widget<GlowMascot>(find.byType(GlowMascot)).pose,
      GlowMascotPose.awake,
    );
    expect(find.textContaining('06:52'), findsOneWidget);
    expect(find.textContaining('06:35'), findsNothing);
    expect(find.textContaining('เวลาตื่นคือตอนที่กดปุ่ม'), findsOneWidget);

    // The card was open a few minutes before the press.
    now = DateTime(2026, 12, 1, 6, 58, 40);
    await tapOn(tester, find.text(_confirm));
    expect(await savedWake(tester), _tuesday(6, 58));
    expect(
      tester.widget<GlowMascot>(find.byType(GlowMascot)).pose,
      GlowMascotPose.awake,
    );
    await closeDatabase(tester, db);
  });

  testWidgets('opened late, it asks, and "just now" saves now', (tester) async {
    await open(tester, _tuesday(11, 0));
    expect(find.text('ตื่นกี่โมง'), findsOneWidget);
    expect(find.text(_confirm), findsNothing);
    expect(find.textContaining('06:35'), findsNothing);

    await tapOn(tester, find.text(_justNow));
    expect(await savedWake(tester), _tuesday(11, 0));
    await closeDatabase(tester, db);
  });

  testWidgets('a picked time is shown and saved only once confirmed', (
    tester,
  ) async {
    await open(tester, _tuesday(11, 0));
    await tapOn(tester, find.text(_pick));
    await tapOn(tester, find.text('บันทึก'));
    expect(await saved(tester), isEmpty);
    expect(find.text('ตื่นกี่โมง'), findsNothing);
    expect(find.textContaining('เวลาตื่นคือตอนที่กดปุ่ม'), findsNothing);

    // Later still, the picked time stays.
    now = _tuesday(12, 30);
    await tapOn(tester, find.text(_confirm));
    expect(await savedWake(tester), _tuesday(6, 35));
    await closeDatabase(tester, db);
  });

  testWidgets('an edited time is not replaced by the press time', (
    tester,
  ) async {
    await open(tester, _tuesday(6, 52));
    await tapOn(tester, find.text('แก้เวลา'));
    await tapOn(tester, find.text('บันทึก'));
    now = _tuesday(7, 40);
    await tapOn(tester, find.text(_confirm));
    expect(await savedWake(tester), _tuesday(6, 52));
    await closeDatabase(tester, db);
  });

  testWidgets('a card left open too long asks instead of saving', (
    tester,
  ) async {
    await open(tester, _tuesday(8, 30));
    now = _tuesday(9, 10);
    await tapOn(tester, find.text(_confirm));
    expect(await saved(tester), isEmpty);
    expect(find.text('ตื่นกี่โมง'), findsOneWidget);
    expect(find.text(_justNow), findsOneWidget);
    await closeDatabase(tester, db);
  });

  testWidgets('the next day only a picked time is offered', (tester) async {
    await open(tester, DateTime(2026, 12, 2, 4, 0));
    expect(find.text(_pick), findsOneWidget);
    expect(find.text(_justNow), findsNothing);
    expect(find.text(_confirm), findsNothing);
    await closeDatabase(tester, db);
  });
}
