import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/schedule/voice_input_screen.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:glow/services/speech_service.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

/// A recogniser that behaves as the test says.
class _FakeSpeech extends SpeechService {
  /// Sent as soon as listening starts; null says nothing at all.
  final String? error;
  final bool works;
  _FakeSpeech({this.error, this.works = true});

  @override
  Future<bool> prepare() async => works;

  @override
  Future<void> listen({
    required void Function(String text) onText,
    required void Function(bool listening) onListeningChanged,
    required void Function(String code) onError,
  }) async {
    if (error != null) onError(error!);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> cancel() async {}
}

void main() {
  late AppDatabase db;

  Future<void> show(WidgetTester tester, SpeechService speech) async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final settings = SettingsRepository(db);
    await settings.ensureRowExists();
    await settings.markVoiceNoticeAccepted();
    useSmallPhone(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          platformCapabilitiesProvider.overrideWithValue(
            PlatformCapabilities.web,
          ),
          deviceHasSpeechProvider.overrideWithValue(true),
          speechServiceProvider.overrideWithValue(speech),
        ],
        child: MaterialApp(
          theme: GlowAppTheme.light(),
          home: const VoiceInputScreen(),
        ),
      ),
    );
    await settle(tester);
  }

  final mic = find.byTooltip('กดแล้วพูด');

  void expectBoxAndHint() {
    expect(find.byType(TextField), findsOneWidget);
    expect(
      find.text('บนมือถือ กดไมค์บนคีย์บอร์ดเพื่อพิมพ์ด้วยเสียงได้'),
      findsOneWidget,
    );
  }

  for (final (name, speech) in [
    ('a refused service', _FakeSpeech(error: 'service-not-allowed')),
    ('a blocked mic', _FakeSpeech(error: 'not-allowed')),
    ('a recogniser that will not start', _FakeSpeech(works: false)),
  ]) {
    testWidgets('$name takes the mic button away', (tester) async {
      await show(tester, speech);
      expectBoxAndHint();
      await tapOn(tester, mic);
      expect(mic, findsNothing);
      expect(find.textContaining('คีย์บอร์ด'), findsWidgets);
      expectBoxAndHint();
      await closeDatabase(tester, db);
    });
  }

  testWidgets('hearing nothing keeps the button', (tester) async {
    await show(tester, _FakeSpeech(error: 'no-speech'));
    await tapOn(tester, mic);
    expect(mic, findsOneWidget);
    expect(find.text('ไม่ได้ยินเสียงพูด ลองอีกครั้ง'), findsOneWidget);
    await closeDatabase(tester, db);
  });

  testWidgets('a mic that never answers is taken away', (tester) async {
    await show(tester, _FakeSpeech());
    await tapOn(tester, mic);
    expect(mic, findsOneWidget);
    await tester.pump(micSilenceLimit);
    await settle(tester);
    expect(mic, findsNothing);
    await closeDatabase(tester, db);
  });
}
