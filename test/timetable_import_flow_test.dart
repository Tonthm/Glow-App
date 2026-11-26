import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_config.dart';
import 'package:glow/core/ai_payload.dart';
import 'package:glow/core/area_crop.dart';
import 'package:glow/data/ai_settings_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/ai/ai_providers.dart';
import 'package:glow/features/ai/area_crop_view.dart';
import 'package:glow/features/ai/timetable_import_screen.dart';
import 'package:glow/features/schedule/add_item_sheet.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/ai/ai_assistant.dart';
import 'package:glow/services/ai/ai_client.dart';
import 'package:glow/services/ai/api_key_store.dart';
import 'package:glow/services/ai/fake_ai_client.dart';
import 'package:glow/services/ai/gemini_ai_client.dart';
import 'package:glow/services/photo_picker.dart';
import 'package:glow/services/timetable_image.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

/// A screenshot that says who took it and where.
Uint8List _screenshot() {
  final picture = img.Image(width: 3000, height: 2000);
  img.fill(picture, color: img.ColorRgb8(240, 240, 240));
  picture.exif.imageIfd['Artist'] = img.IfdValueAscii('SECRET-NAME');
  picture.exif.gpsIfd[2] = img.IfdValueAscii('SECRET-PLACE');
  return img.encodeJpg(picture);
}

class _Picker implements PhotoPicker {
  @override
  Future<Uint8List?> pick(PhotoFrom from, {bool selfie = true}) async =>
      _screenshot();
}

void main() {
  late AppDatabase db;
  late AiSettingsRepository aiSettings;

  Future<void> start({int imageConsent = 0}) async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    aiSettings = AiSettingsRepository(db);
    final settings = SettingsRepository(db);
    await settings.ensureRowExists();
    await settings.applyAgeGroupDefaults(AgeGroup.adult);
    await aiSettings.update(
      AiSettingsCompanion(
        enabled: const Value(true),
        consentVersion: const Value(aiConsentVersion),
        imageConsentVersion: Value(imageConsent),
      ),
    );
  }

  AiAssistant assistant(AiClient client) => AiAssistant(
    settings: aiSettings,
    keys: MemoryApiKeyStore('k'),
    client: client,
  );

  final small = Uint8List.fromList([0xFF, 0xD8, 1, 2]);

  group('before anything is sent', () {
    test('pictures need their own agreement', () async {
      await start();
      addTearDown(db.close);
      final client = FakeAiClient();
      final result = await assistant(client).readTimetable(small);
      expect(result.failure, AiFailure.notReady);
      expect(client.requests, isEmpty);
      // The other jobs don't need it.
      expect(
        (await assistant(client).estimate(
          title: 'เลข',
          today: DateTime(2026, 11, 26),
        )).value,
        isNotNull,
      );
    });

    test('with it, one call is made and counted', () async {
      await start(imageConsent: aiImageConsentVersion);
      addTearDown(db.close);
      final client = FakeAiClient();
      final result = await assistant(client).readTimetable(small);
      expect(result.value!.items, hasLength(3));
      expect(client.requests.single.imageJpeg, small);
      expect((await aiSettings.get()).callCount, 1);
    });

    test('a picture over the size limit is never sent', () async {
      await start(imageConsent: aiImageConsentVersion);
      addTearDown(db.close);
      final client = FakeAiClient();
      final result = await assistant(client).readTimetable(
        Uint8List(maxTimetableImageBytes + 1),
      );
      expect(result.failure, AiFailure.inputTooLong);
      expect(client.requests, isEmpty);
    });

    test('network trouble is retried once, counting both', () async {
      await start(imageConsent: aiImageConsentVersion);
      addTearDown(db.close);
      final client = FakeAiClient(
        respond: (_) async => throw const AiException(AiFailure.offline),
      );
      final result = await assistant(client).readTimetable(small);
      expect(result.failure, AiFailure.offline);
      expect(client.requests, hasLength(2));
      expect((await aiSettings.get()).callCount, 2);
    });
  });

  test('the request puts the picture beside the text, and stores nothing', () {
    final body = GeminiAiClient.requestBody(
      buildTimetableRequest(small)!,
      'm',
    );
    expect(body['input'], [
      {'type': 'text', 'text': '{"task":"read this timetable"}'},
      {'type': 'image', 'data': base64Encode(small), 'mime_type': 'image/jpeg'},
    ]);
    expect(body['store'], isFalse);
    expect(
      (body['generation_config'] as Map)['max_output_tokens'],
      aiTimetableOutputTokens,
    );
    // Other jobs still send plain text.
    expect(
      GeminiAiClient.requestBody(buildConnectionTestRequest(), 'm')['input'],
      isA<String>(),
    );
  });

  testWidgets('a sent picture is small and carries no metadata', (tester) async {
    await tester.runAsync(() async {
      final picked = _screenshot();
      expect(latin1.decode(picked), contains('SECRET-NAME'));
      final opened = await openTimetablePicture(picked);
      final jpeg = await timetableJpeg(
        opened,
        const CropArea(left: 0, top: 0.5, right: 1, bottom: 1),
      );
      opened.dispose();
      final text = latin1.decode(jpeg);
      expect(text.contains('Exif'), isFalse);
      expect(text.contains('SECRET'), isFalse);
      expect(jpeg.length, lessThanOrEqualTo(maxTimetableImageBytes));
      final sent = img.decodeJpg(jpeg)!;
      // 2400 x 800 after cutting, then shrunk to the longest side allowed.
      expect(sent.width, timetableImageSide);
      expect(sent.height, closeTo(533, 2));
    });
  });

  testWidgets('every part of a crop handle can be dragged', (tester) async {
    useSmallPhone(tester);
    final picture = await tester.runAsync(
      () => openTimetablePicture(_screenshot()),
    );
    addTearDown(picture!.dispose);
    var area = const CropArea();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AreaCropView(
              picture: picture,
              area: area,
              onChanged: (v) => setState(() => area = v),
            ),
          ),
        ),
      ),
    );
    final handle = tester.getRect(
      find.bySemanticsLabel('ลากมุมบนซ้ายเพื่อครอบตัด'),
    );
    expect(handle.size, const Size(48, 48));
    // Start near the outer edge, away from the picture.
    await tester.dragFrom(
      handle.topLeft + const Offset(3, 3),
      const Offset(80, 60),
    );
    await tester.pump();
    expect(area.left, greaterThan(0.1));
    expect(area.top, greaterThan(0.1));
    expect((area.right, area.bottom), (1, 1));
  });

  testWidgets('pick, cut, look, agree, send, check, and only then save', (
    tester,
  ) async {
    await start();
    // Clashes with the first class the stand-in reads.
    await ScheduleRepository(db).addWeeklyItem(
      title: 'ของเดิม',
      dayOfWeek: DateTime.monday,
      startMinutes: 9 * 60,
      endMinutes: 10 * 60,
      type: WeeklyItemType.classSession,
    );
    final client = FakeAiClient();
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          photoPickerProvider.overrideWithValue(_Picker()),
          apiKeyStoreProvider.overrideWithValue(MemoryApiKeyStore('k')),
          aiClientProvider.overrideWithValue(client),
        ],
        child: MaterialApp(
          theme: GlowAppTheme.light(),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TimetableImportScreen(),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    /// Decoding and drawing pictures runs outside the test clock.
    Future<void> until(Finder finder) async {
      for (var i = 0; i < 300 && finder.evaluate().isEmpty; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(finder, findsWidgets);
      await settle(tester);
    }

    await tapOn(tester, find.text('open'));
    await tester.tap(find.text('เลือกรูป'));
    await until(find.text('ดูรูปที่จะส่ง'));
    await tester.drag(
      find.bySemanticsLabel('ลากมุมบนซ้ายเพื่อครอบตัด'),
      const Offset(30, 30),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('ดูรูปที่จะส่ง'));
    await until(find.text('ส่งให้ Google อ่าน'));
    expect(find.textContaining('จะถูกส่งไปให้ Google'), findsOneWidget);
    expect(client.requests, isEmpty);

    // Refusing sends nothing.
    await tapOn(tester, find.text('ส่งให้ Google อ่าน'));
    await tapOn(tester, find.text('ไม่ยอมรับ'));
    expect(client.requests, isEmpty);

    await tapOn(tester, find.text('ส่งให้ Google อ่าน'));
    await tapOn(tester, find.text('ยอมรับให้ส่งรูป'));
    await until(find.textContaining('AI อ่านได้ 3 คาบ'));
    expect(client.requests, hasLength(1));
    expect(find.text('ส่วนที่อ่านไม่ออก'), findsOneWidget);
    expect(tester.takeException(), isNull);
    // Nothing saved yet.
    expect(await db.select(db.weeklyItems).get(), hasLength(1));
    // The clashing one starts as "skip", so two will be saved.
    expect(find.text('บันทึก 2 คาบ'), findsOneWidget);

    await tapOn(tester, find.text('แทนที่'));
    expect(find.text('บันทึก 3 คาบ'), findsOneWidget);
    await tester.tap(find.text('บันทึก 3 คาบ'));
    await settle(tester);

    final rows = await db.select(db.weeklyItems).get();
    expect(rows.map((r) => r.title).toSet(), {
      'คณิตศาสตร์',
      'ฟิสิกส์',
      'English',
    });
    expect(rows.every((r) => r.source == ItemSource.ai), isTrue);
    expect(find.text('open'), findsOneWidget);
    await closeDatabase(tester, db);
  });

  testWidgets('the + menu never offers it to a birth date under 18', (
    tester,
  ) async {
    await start();
    await db
        .into(db.cardProfiles)
        .insert(
          CardProfilesCompanion(
            id: const Value(0),
            birthDate: Value(DateTime(2012, 1, 1)),
          ),
        );
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          apiKeyStoreProvider.overrideWithValue(MemoryApiKeyStore('k')),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showAddMethodSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tapOn(tester, find.text('open'));
    expect(find.text('พิมพ์'), findsOneWidget);
    expect(find.text('นำเข้าจากรูป'), findsNothing);
    await closeDatabase(tester, db);
  });
}
