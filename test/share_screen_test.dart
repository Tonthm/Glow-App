/// The share screen: what it offers, and that nothing personal is on it.
library;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/story_share.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/share/share_screen.dart';
import 'package:glow/features/share/story_gallery_screen.dart';
import 'package:glow/features/share/story_painter.dart';
import 'package:glow/features/share/story_preview.dart';
import 'package:glow/features/share/story_samples.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/app_clock.dart';
import 'package:glow/services/image_share.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:glow/theme/widgets/student_card.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

class FakeSharer implements ImageSharer {
  @override
  final bool canShare;
  ShareOutcome outcome = ShareOutcome.done;
  final shared = <String>[];
  final downloaded = <String>[];

  FakeSharer({required this.canShare});

  @override
  Future<ShareOutcome> share(Uint8List png, String name) async {
    shared.add(name);
    return outcome;
  }

  @override
  Future<bool> download(Uint8List png, String name) async {
    downloaded.add(name);
    return true;
  }
}

void main() {
  late AppDatabase db;
  late FakeSharer sharer;

  /// What each picture was made from.
  late List<(StorySummary, StoryOptions)> drawn;

  final now = DateTime(2026, 11, 27, 9);

  Future<void> show(
    WidgetTester tester, {
    bool canShare = true,
    int nights = 3,
    bool dark = false,
  }) async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await SettingsRepository(db).ensureRowExists();
    for (var ago = 0; ago < nights; ago++) {
      final day = DateTime(2026, 11, 27 - ago);
      await db
          .into(db.checkIns)
          .insert(
            CheckInsCompanion.insert(
              wakeDate: day,
              lightsOffAt: DateTime(2026, 11, 26 - ago, 22, 30),
              actualWakeAt: DateTime(2026, 11, 27 - ago, 6, 45),
              result: CheckInResultDb.enough,
              onTime: true,
              checkedInAt: day,
            ),
          );
    }
    sharer = FakeSharer(canShare: canShare);
    drawn = [];
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => now),
          imageSharerProvider.overrideWithValue(sharer),
          storyLogoProvider.overrideWithValue(() async => null),
          storyRendererProvider.overrideWithValue((
            StorySummary story,
            StoryOptions options, {
            ui.Image? logo,
            ui.Image? photo,
          }) async {
            drawn.add((story, options));
            return Uint8List(1);
          }),
        ],
        child: MaterialApp(
          theme: dark ? GlowAppTheme.dark() : GlowAppTheme.light(),
          home: const ShareScreen(),
        ),
      ),
    );
    await settle(tester);
  }

  final shareButton = find.widgetWithText(ElevatedButton, 'แชร์');

  testWidgets('where the browser shares files: share, and a download too', (
    tester,
  ) async {
    await show(tester);
    await tapOn(tester, shareButton);
    expect(sharer.shared, ['glow_week.png']);
    await tapOn(tester, find.text('ดาวน์โหลดไฟล์ PNG'));
    expect(sharer.downloaded, ['glow_week.png']);
    await closeDatabase(tester, db);
  });

  testWidgets('where it cannot: only a download, and no share button', (
    tester,
  ) async {
    await show(tester, canShare: false);
    expect(shareButton, findsNothing);
    await tapOn(tester, find.text('ดาวน์โหลดไฟล์ PNG'));
    expect(sharer.downloaded, ['glow_week.png']);
    expect(sharer.shared, isEmpty);
    await closeDatabase(tester, db);
  });

  testWidgets('a failed share says what to do instead', (tester) async {
    await show(tester);
    sharer.outcome = ShareOutcome.failed;
    await tapOn(tester, shareButton);
    expect(find.textContaining('แชร์ไม่สำเร็จ'), findsOneWidget);
    await closeDatabase(tester, db);
  });

  testWidgets('closing the share sheet is not an error', (tester) async {
    await show(tester);
    sharer.outcome = ShareOutcome.cancelled;
    await tapOn(tester, shareButton);
    expect(find.textContaining('ไม่สำเร็จ'), findsNothing);
    await closeDatabase(tester, db);
  });

  testWidgets('each choice remakes the picture', (tester) async {
    await show(tester);
    expect(drawn.last.$1.view, StoryView.week);

    await tapOn(tester, find.text('รายเดือน'));
    expect(drawn.last.$1.view, StoryView.month);
    await tapOn(tester, find.text('รายวัน'));
    expect(drawn.last.$1.view, StoryView.night);
    expect(find.text('คืนที่ตื่นวันที่ 27/11'), findsOneWidget);

    await tapOn(tester, find.text('ตัวอักษรสีเข้ม'));
    expect(drawn.last.$2.darkText, isTrue);
    await tapOn(tester, find.text('ล่าง'));
    expect(drawn.last.$2.position, StoryPosition.bottom);
    await tapOn(tester, find.text('โลโก้ Glow'));
    expect(drawn.last.$2.showLogo, isFalse);
    await tapOn(tester, find.text('แสดงเวลาเข้านอน – ตื่น'));
    expect(drawn.last.$2.showTimes, isFalse);

    await tapOn(tester, shareButton);
    expect(sharer.shared, ['glow_night.png']);
    await closeDatabase(tester, db);
  });

  testWidgets('with no recorded night, sharing is off and says why', (
    tester,
  ) async {
    await show(tester, nights: 0);
    for (final view in ['รายวัน', 'รายสัปดาห์', 'รายเดือน']) {
      await tapOn(tester, find.text(view));
      expect(
        tester.widget<ElevatedButton>(shareButton).enabled,
        isFalse,
        reason: view,
      );
      expect(find.textContaining('ยังไม่มีคืนที่เช็กอิน'), findsOneWidget);
    }
    expect(drawn, isEmpty);
    await closeDatabase(tester, db);
  });

  testWidgets('the debug page draws every sample in every view', (
    tester,
  ) async {
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(() => now),
          storyLogoProvider.overrideWithValue(() async => null),
        ],
        child: MaterialApp(
          theme: GlowAppTheme.light(),
          home: const StoryGalleryScreen(),
        ),
      ),
    );
    await settle(tester);
    for (final sample in StorySample.values) {
      await tester.scrollUntilVisible(
        find.text(sample.label),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await settle(tester);
    expect(find.byType(StoryPreview), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no student card, and no switch for a name or its photo', (
    tester,
  ) async {
    await show(tester, dark: true);
    expect(find.byType(StudentCard), findsNothing);
    expect(find.text('แสดงชื่อและโรงเรียน', skipOffstage: false), findsNothing);
    expect(find.text('ใส่รูปถ่าย', skipOffstage: false), findsNothing);
    // Adding it to a photo is offered only once one is chosen.
    expect(
      find.text('ใส่บนรูปของฉันแล้วบันทึก', skipOffstage: false),
      findsNothing,
    );
    await closeDatabase(tester, db);
  });
}
