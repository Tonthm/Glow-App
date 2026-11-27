/// The guide, the tour, the checklist, the (i) buttons and "รู้จักการนอน"
/// (CLAUDE.md section 21), through the real app.
library;

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/guide.dart';
import 'package:glow/data/card_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/wallet_repository.dart';
import 'package:glow/data/guide_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/ai/ai_providers.dart';
import 'package:glow/features/ai/ai_settings_screen.dart';
import 'package:glow/features/demo/demo_data.dart';
import 'package:glow/features/evening/evening_screen.dart';
import 'package:glow/features/guide/guide_entries.dart';
import 'package:glow/features/guide/guide_screen.dart';
import 'package:glow/features/guide/learn_sleep_screen.dart';
import 'package:glow/features/guide/tour_screen.dart';
import 'package:glow/features/routine/routine_screen.dart';
import 'package:glow/features/schedule/voice_input_screen.dart';
import 'package:glow/features/settings/data_settings.dart';
import 'package:glow/features/share/share_screen.dart';
import 'package:glow/main.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/ai/api_key_store.dart';
import 'package:glow/services/app_clock.dart';
import 'package:glow/services/notification_service_web.dart'
    as web_notifications;
import 'package:glow/services/permissions_service_web.dart' as web_permissions;
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

/// A Tuesday evening, when the routine is open.
final _evening = DateTime(2026, 12, 1, 20, 30);

Future<void> _demo(AppDatabase db) => resetDemoData(db, DateTime(2026, 12, 1));

/// Just set up: no schedule, tasks or check-ins yet.
Future<void> _fresh(AppDatabase db) async {
  final settings = SettingsRepository(db);
  await settings.ensureRowExists();
  await settings.updateEarliestClass(8 * 60);
  await settings.markOnboardingCompleted(DateTime(2026, 12, 1, 8));
}

Future<AppDatabase> _open(
  WidgetTester tester, {
  Future<void> Function(AppDatabase db) seed = _demo,
  DateTime? now,
  bool mic = false,
  Size size = const Size(393, 852),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.runAsync(() => seed(db));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now ?? _evening),
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
        deviceHasSpeechProvider.overrideWithValue(mic),
        apiKeyStoreProvider.overrideWithValue(MemoryApiKeyStore()),
        storyLogoProvider.overrideWithValue(() async => null),
      ],
      child: const GlowApp(),
    ),
  );
  await settle(tester);
  await settle(tester);
  return db;
}

Future<void> _openGuide(WidgetTester tester) async {
  await tapOn(tester, find.byTooltip('คู่มือ').first);
  expect(find.byType(GuideScreen), findsOneWidget);
}

Finder _goButton(String title) => find.descendant(
  of: find.byKey(ValueKey('guide-$title')),
  matching: find.text('ไปที่หน้านี้'),
);

Future<T> _read<T>(WidgetTester tester, Future<T> Function() body) async =>
    (await tester.runAsync(body)) as T;

int _tab(WidgetTester tester) =>
    tester.widget<IndexedStack>(find.byType(IndexedStack).first).index!;

void main() {
  /// What shows once each destination has been reached. Tabs are checked by
  /// number instead.
  final arrivals = <Destination, Finder Function()>{
    Destination.routine: () => find.byType(RoutineScreen),
    Destination.evening: () => find.byType(EveningScreen),
    Destination.addClass: () => find.text('เพิ่มคาบเรียน/กิจกรรม'),
    Destination.addTask: () => find.widgetWithText(TextField, 'ชื่องาน'),
    Destination.speakTimetable: () => find.byType(VoiceInputScreen),
    // AI is off, so the picture import leads to its settings.
    Destination.importPicture: () => find.byType(AiSettingsScreen),
    Destination.aiSettings: () => find.byType(AiSettingsScreen),
    Destination.editCard: () => find.text('โปรไฟล์และบัตร'),
    Destination.shareStory: () => find.byType(ShareScreen),
    Destination.backup: () => find.byType(BackupScreen),
  };
  const tabs = {
    Destination.sleep: 0,
    Destination.schedule: 1,
    Destination.stats: 2,
    Destination.card: 3,
  };

  test('every destination has a way to check it', () {
    expect({...arrivals.keys, ...tabs.keys}, Destination.values.toSet());
  });

  for (final entry in guideEntries.where((e) => e.mic != true)) {
    testWidgets('the guide goes to "${entry.title}"', (tester) async {
      final db = await _open(tester);
      await _openGuide(tester);
      await tapOn(tester, _goButton(entry.title));
      expect(tester.takeException(), isNull);
      final tab = tabs[entry.destination];
      if (tab != null) {
        expect(find.byType(GuideScreen), findsNothing);
        expect(_tab(tester), tab);
      } else {
        expect(arrivals[entry.destination]!(), findsWidgets);
        // Back returns to the guide.
        tester.state<NavigatorState>(find.byType(Navigator).first).pop();
        await settle(tester);
        expect(find.byType(GuideScreen), findsOneWidget);
      }
      await closeDatabase(tester, db);
    });
  }

  testWidgets('with a working mic the guide offers speaking', (tester) async {
    final db = await _open(tester, mic: true, size: const Size(393, 3000));
    await _openGuide(tester);
    expect(find.text('พูดใส่ตาราง'), findsOneWidget);
    expect(find.text('ใส่หลายคาบเป็นประโยค'), findsNothing);
    await closeDatabase(tester, db);
  });

  testWidgets('the guide hides what the user cannot get into', (tester) async {
    final db = await _open(
      tester,
      size: const Size(393, 3000),
      seed: (db) async {
        await _demo(db);
        // Under 18 by birth date, with the evening and routine switched off.
        await CardRepository(
          db,
          WalletRepository(db),
        ).setBirthDate(DateTime(2012, 1, 1), now: _evening);
        await SettingsRepository(db).updateRoutineEnabled(false);
        await (db.update(db.settings))
            .write(const SettingsCompanion(eveningEnabled: Value(false)));
      },
    );
    await _openGuide(tester);
    expect(find.text('ผู้ช่วย AI'), findsNothing);
    expect(find.text('ตั้งค่าผู้ช่วย AI'), findsNothing);
    expect(find.text('นำเข้าตารางจากรูป'), findsNothing);
    expect(find.text('พูดใส่ตาราง'), findsNothing);
    expect(find.text('ท่าก่อนนอน'), findsNothing);
    expect(find.text('จัดเย็นนี้'), findsNothing);
    expect(find.text('เพิ่มงาน'), findsNothing);
    expect(find.text('แผนคืนนี้'), findsOneWidget);
    await closeDatabase(tester, db);
  });

  for (final (moment, hour, message) in [
    ('after waking up', 9, 'ท่าก่อนนอนเปิดได้ตอนเย็น'),
    ('in the early afternoon', 13, 'ท่าก่อนนอนเปิดได้ตั้งแต่'),
  ]) {
    testWidgets('the routine does not open from the guide $moment', (
      tester,
    ) async {
      final db = await _open(tester, now: DateTime(2026, 12, 1, hour));
      Future<int> runs() async =>
          (await _read(tester, () => db.select(db.routineLogs).get())).length;
      final before = await runs();
      await _openGuide(tester);
      await tapOn(tester, _goButton('ท่าก่อนนอน'));
      expect(find.byType(RoutineScreen), findsNothing);
      expect(find.textContaining(message), findsOneWidget);
      expect(await runs(), before);
      await closeDatabase(tester, db);
    });
  }

  testWidgets('the card tab opens the guide too', (tester) async {
    final db = await _open(tester);
    await tapOn(tester, find.text('บัตร'));
    await _openGuide(tester);
    await closeDatabase(tester, db);
  });

  group('tour', () {
    testWidgets('comes right after setup, and closes for good', (tester) async {
      final db = await _open(tester, seed: (db) async {});
      await tapOn(tester, find.text('ข้าม'));
      await tapOn(tester, find.text('เริ่มใช้งาน'));
      expect(find.byType(TourScreen), findsOneWidget);

      for (final card in tourCards) {
        expect(find.text(card.title), findsOneWidget);
        expect(find.text(card.actionLabel), findsOneWidget);
        if (card != tourCards.last) await tapOn(tester, find.text('ถัดไป'));
      }
      await tapOn(tester, find.text('เสร็จแล้ว'));
      expect(find.byType(TourScreen), findsNothing);
      final guide = await _read(tester, () => GuideRepository(db).get());
      expect(guide.tourPending, isFalse);
      await closeDatabase(tester, db);
    });

    testWidgets('a card button goes and does it', (tester) async {
      final db = await _open(
        tester,
        seed: (db) async {
          await _fresh(db);
          await GuideRepository(db).setTourPending(true);
        },
      );
      await tapOn(tester, find.text('เพิ่มคาบเรียน'));
      expect(find.byType(TourScreen), findsNothing);
      expect(find.text('เพิ่มคาบเรียน/กิจกรรม'), findsOneWidget);
      final guide = await _read(tester, () => GuideRepository(db).get());
      expect(guide.tourPending, isFalse);
      await closeDatabase(tester, db);
    });

    testWidgets('is not forced on someone already using the app', (
      tester,
    ) async {
      final db = await _open(tester);
      expect(find.byType(TourScreen), findsNothing);
      await _openGuide(tester);
      await tapOn(tester, find.text('ดูทัวร์แนะนำอีกครั้ง'));
      expect(find.byType(TourScreen), findsOneWidget);
      await tapOn(tester, find.text('ข้าม'));
      expect(find.byType(GuideScreen), findsOneWidget);
      await closeDatabase(tester, db);
    });

    testWidgets('fits the smallest phone', (tester) async {
      final db = await _open(
        tester,
        size: const Size(320, 640),
        seed: (db) async {
          await _fresh(db);
          await GuideRepository(db).setTourPending(true);
        },
      );
      for (var i = 1; i < tourCards.length; i++) {
        await tapOn(tester, find.text('ถัดไป'));
      }
      expect(tester.takeException(), isNull);
      await closeDatabase(tester, db);
    });
  });

  group('starter checklist', () {
    testWidgets('ticks what was done, and can be closed for good', (
      tester,
    ) async {
      final db = await _open(tester, seed: _fresh, size: const Size(393, 2200));
      await settle(tester);
      // Only the plan has been seen.
      expect(find.text('ทำแล้ว 1 จาก 5 ขั้น'), findsOneWidget);
      // One folded card.
      expect(find.text('ใส่ตารางเรียน'), findsNothing);

      await tapOn(tester, find.text('เริ่มต้นใช้งาน'));
      await tapOn(tester, find.text('ใส่ตารางเรียน'));
      expect(_tab(tester), 1);
      await tapOn(tester, find.text('นอน'));

      await tapOn(tester, find.text('ปิดรายการนี้'));
      expect(find.text('เริ่มต้นใช้งาน'), findsNothing);
      final guide = await _read(tester, () => GuideRepository(db).get());
      expect(guide.checklistDismissed, isTrue);
      await closeDatabase(tester, db);
    });

    testWidgets('a step stays ticked after its task is deleted', (
      tester,
    ) async {
      final db = await _open(
        tester,
        size: const Size(393, 2200),
        seed: (db) async {
          await _fresh(db);
          await db
              .into(db.eveningTasks)
              .insert(
                EveningTasksCompanion.insert(
                  title: 'การบ้านเลข',
                  minutes: 30,
                  kind: 0,
                  planDate: DateTime(2026, 12, 1),
                ),
              );
        },
      );
      await settle(tester);
      expect(find.text('ทำแล้ว 2 จาก 5 ขั้น'), findsOneWidget);
      await tester.runAsync(() => db.delete(db.eveningTasks).go());
      await settle(tester);
      expect(find.text('ทำแล้ว 2 จาก 5 ขั้น'), findsOneWidget);
      await closeDatabase(tester, db);
    });

    testWidgets('goes away when everything is done', (tester) async {
      final db = await _open(
        tester,
        size: const Size(393, 2200),
        seed: (db) async {
          await _demo(db);
          await GuideRepository(db).markDone(ChecklistStep.values.toSet());
        },
      );
      expect(find.text('เริ่มต้นใช้งาน'), findsNothing);
      await closeDatabase(tester, db);
    });
  });

  group('(i) buttons', () {
    Future<void> explain(WidgetTester tester, GuideTip tip) async {
      await tapOn(tester, find.byTooltip('อธิบาย: ${tip.title}'));
      expect(find.text(tip.body.split('\n').first), findsOneWidget);
      await tapOn(tester, find.text('เข้าใจแล้ว'));
    }

    testWidgets('explain the four things', (tester) async {
      final db = await _open(tester, size: const Size(393, 2200));
      await explain(tester, GuideTip.cycles);
      await tapOn(tester, find.text('สัปดาห์นี้และเควส'));
      await explain(tester, GuideTip.questModes);
      await tapOn(tester, find.text('แผนช่วงเย็น'));
      await explain(tester, GuideTip.evening);
      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await settle(tester);
      await tapOn(tester, find.text('บัตร'));
      await explain(tester, GuideTip.fireAndShields);
      await closeDatabase(tester, db);
    });
  });

  testWidgets('"รู้จักการนอน" gives its source and says it is not medical '
      'advice', (tester) async {
    final db = await _open(tester, size: const Size(320, 640));
    await _openGuide(tester);
    await tapOn(tester, find.text('รู้จักการนอน'));
    expect(find.byType(LearnSleepScreen), findsOneWidget);
    expect(sleepFacts, hasLength(3));
    for (final (_, _, lines) in sleepFacts) {
      expect(lines.length, lessThanOrEqualTo(3));
    }
    await tester.scrollUntilVisible(
      find.text(sleepFactsNotice),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('145–155'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await closeDatabase(tester, db);
  });
}
