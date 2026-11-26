import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_config.dart';
import 'package:glow/core/ai_payload.dart';
import 'package:glow/data/ai_settings_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/services/ai/ai_assistant.dart';
import 'package:glow/services/ai/ai_client.dart';
import 'package:glow/services/ai/api_key_store.dart';
import 'package:glow/services/ai/fake_ai_client.dart';
import 'package:glow/services/ai/gemini_ai_client.dart';
import 'package:glow/services/backup_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const secret = 'test-secret-key-123';

void main() {
  late AppDatabase db;
  late AiSettingsRepository settings;
  late MemoryApiKeyStore keys;
  final today = DateTime(2026, 11, 23);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = AiSettingsRepository(db);
    keys = MemoryApiKeyStore(secret);
  });

  tearDown(() => db.close());

  Future<void> switchOn({int quota = aiDefaultDailyQuota}) => settings.update(
    AiSettingsCompanion(
      enabled: const Value(true),
      consentVersion: const Value(aiConsentVersion),
      dailyQuota: Value(quota),
    ),
  );

  AiAssistant assistant(AiClient client) => AiAssistant(
    settings: settings,
    keys: keys,
    client: client,
    realNow: () => today,
  );

  test('is off by default and calls nothing', () async {
    final client = FakeAiClient();
    final result = await assistant(
      client,
    ).parseTasks('เลข', today: today);
    expect(result.failure, AiFailure.notReady);
    expect(client.requests, isEmpty);
  });

  test('needs consent and a key', () async {
    await settings.update(const AiSettingsCompanion(enabled: Value(true)));
    expect(await assistant(FakeAiClient()).isReady(), isFalse);
    await switchOn();
    expect(await assistant(FakeAiClient()).isReady(), isTrue);
    await keys.delete();
    expect(await assistant(FakeAiClient()).isReady(), isFalse);
  });

  for (final failure in [AiFailure.offline, AiFailure.timeout]) {
    test('retries once after ${failure.name}', () async {
      await switchOn();
      final client = FakeAiClient(
        respond: (_) async => throw AiException(failure),
      );
      final result = await assistant(client).parseTasks('เลข', today: today);
      expect(result.failure, failure);
      expect(client.requests, hasLength(2));
    });
  }

  test('does not retry a rejected key', () async {
    await switchOn();
    final client = FakeAiClient(
      respond: (_) async => throw const AiException(AiFailure.badKey),
    );
    await assistant(client).parseTasks('เลข', today: today);
    expect(client.requests, hasLength(1));
  });

  test('stops at the daily limit', () async {
    await switchOn(quota: 1);
    final client = FakeAiClient();
    final ai = assistant(client);
    expect((await ai.estimate(title: 'เลข', today: today)).value, isNotNull);
    expect(
      (await ai.estimate(title: 'เลข', today: today)).failure,
      AiFailure.quotaReached,
    );
    expect(client.requests, hasLength(1));
  });

  test('a bad answer is dropped', () async {
    await switchOn();
    final result = await assistant(
      FakeAiClient(respond: (_) async => 'ได้เลย!'),
    ).estimate(title: 'เลข', today: today);
    expect(result.failure, AiFailure.badResponse);
    expect(result.value, isNull);
  });

  group('Gemini client', () {
    final request = buildParseRequest(text: 'เลข', today: today)!;

    String reply(String status, String text) => jsonEncode({
      'status': status,
      'steps': [
        {
          'type': 'model_output',
          'content': [
            {'type': 'text', 'text': text},
          ],
        },
      ],
    });

    test('sends the key only in a header and asks not to be stored', () async {
      late http.Request seen;
      final client = GeminiAiClient(
        client: MockClient((r) async {
          seen = r;
          return http.Response(reply('completed', '{}'), 200);
        }),
      );
      await client.complete(request, apiKey: secret, model: aiDefaultModel);
      expect(seen.url.toString(), isNot(contains(secret)));
      expect(seen.body, isNot(contains(secret)));
      expect(seen.headers['x-goog-api-key'], secret);
      expect(seen.headers.keys, isNot(contains('Api-Revision')));
      expect((jsonDecode(seen.body) as Map)['store'], isFalse);
    });

    test('never puts the key in an error', () async {
      final failing = [
        MockClient((_) async => http.Response('bad key $secret', 403)),
        MockClient((_) async => throw http.ClientException('x $secret')),
        MockClient((_) => Completer<http.Response>().future),
      ];
      for (final mock in failing) {
        final client = GeminiAiClient(
          client: mock,
          timeout: const Duration(milliseconds: 10),
        );
        await expectLater(
          client.complete(request, apiKey: secret, model: aiDefaultModel),
          throwsA(
            isA<AiException>().having(
              (e) => e.toString(),
              'text',
              isNot(contains(secret)),
            ),
          ),
        );
      }
    });

    test('rejects an unfinished answer', () {
      expect(GeminiAiClient.modelText(reply('incomplete', '{')), isNull);
      expect(GeminiAiClient.modelText('not json'), isNull);
      expect(GeminiAiClient.modelText(reply('completed', 'ok')), 'ok');
    });
  });

  group('the key', () {
    test('is not in a backup', () async {
      await switchOn();
      final snapshot = await BackupService(db).buildSnapshot();
      expect(jsonEncode(snapshot), isNot(contains(secret)));
    });

    test('is removed by delete-all but kept by a restore', () async {
      final backup = BackupService(db);
      await switchOn();
      await backup.restoreSnapshot(await backup.buildSnapshot());
      expect(await keys.read(), secret);
      expect((await settings.get()).enabled, isFalse);
      await backup.deleteEverything(keys);
      expect(await keys.read(), isNull);
    });
  });
}
