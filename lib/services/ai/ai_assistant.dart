import '../../core/ai_config.dart';
import '../../core/ai_payload.dart';
import '../../core/ai_validators.dart';
import '../../data/ai_settings_repository.dart';
import 'ai_client.dart';
import 'api_key_store.dart';

/// Either a checked [value], or why there is none. On any failure the caller
/// uses the way that needs no AI.
class AiResult<T> {
  final T? value;
  final AiFailure? failure;

  const AiResult.ok(T this.value) : failure = null;
  const AiResult.failed(AiFailure this.failure) : value = null;
}

/// Gemini's terms require users to be 18 or older, and don't allow apps likely
/// to be used by anyone younger (read 26 Nov 2026).
const String aiUnderAgeMessage =
    'ผู้ช่วย AI ใช้ได้เมื่อตั้งช่วงอายุเป็น 18 ปีขึ้นไป ตามเงื่อนไขของ '
    '$aiProviderName ฟีเจอร์อื่นใช้ได้ตามปกติ';

/// A gentle line for when AI can't be used.
String aiFailureMessage(AiFailure failure) => switch (failure) {
  AiFailure.quotaReached => 'วันนี้ใช้ AI ครบจำนวนแล้ว ใช้แบบธรรมดาแทน',
  AiFailure.inputTooLong =>
    'ข้อความยาวเกิน $aiMaxInputChars ตัวอักษร ใช้แบบธรรมดาแทน',
  AiFailure.badKey => 'ใช้ AI ไม่ได้ ลองตรวจ API key ในตั้งค่า ใช้แบบธรรมดาแทน',
  AiFailure.underAge => aiUnderAgeMessage,
  _ => 'ตอนนี้ใช้ AI ไม่ได้ ใช้แบบธรรมดาแทน',
};

/// The only way the app talks to AI: age group, consent, and the daily limit
/// are checked before each call, and every answer goes through core/ before it
/// is used.
/// It proposes; nothing here saves anything.
class AiAssistant {
  final AiSettingsRepository settings;
  final ApiKeyStore keys;
  final AiClient client;

  /// Real time, so moving the demo clock can't reset the daily limit.
  final DateTime Function() realNow;

  /// Demo mode: a stand-in client that needs no key or consent.
  final bool demo;

  AiAssistant({
    required this.settings,
    required this.keys,
    required this.client,
    this.demo = false,
    DateTime Function()? realNow,
  }) : realNow = realNow ?? DateTime.now;

  Future<bool> isReady() async {
    if (demo) return true;
    if (await settings.isUnder18()) return false;
    final row = await settings.get();
    if (!row.enabled || row.consentVersion != aiConsentVersion) return false;
    return (await keys.read())?.isNotEmpty ?? false;
  }

  Future<AiResult<List<AiParsedTask>>> parseTasks(
    String text, {
    required DateTime today,
  }) => _ask(
    buildParseRequest(text: text, today: today),
    (answer) => parseAiTasks(answer, source: text, today: today),
  );

  Future<AiResult<AiEstimate>> estimate({
    required String title,
    required DateTime today,
    DateTime? due,
  }) => _ask(
    buildEstimateRequest(title: title, today: today, due: due),
    parseAiEstimate,
  );

  Future<AiResult<List<AiPart>>> split({
    required String title,
    required int totalMinutes,
    required DateTime today,
    DateTime? due,
  }) => _ask(
    buildSplitRequest(
      title: title,
      totalMinutes: totalMinutes,
      today: today,
      due: due,
    ),
    (answer) => parseAiSplit(answer, source: title, totalMinutes: totalMinutes),
  );

  Future<AiResult<String>> explain(List<String> facts) {
    final request = buildExplainRequest(facts);
    return _ask(request, (answer) {
      // Checked against only what was actually sent.
      final sent = (request!.input['facts'] as List).cast<String>();
      return parseAiExplanation(answer, sent);
    });
  }

  /// "ทดสอบการเชื่อมต่อ". Works before AI is switched on, but still needs
  /// consent and a key, and counts toward the daily limit.
  Future<AiFailure?> testConnection() async {
    final result = await _ask(
      buildConnectionTestRequest(),
      (answer) => parseAiConnectionTest(answer) ? true : null,
      requireEnabled: false,
    );
    return result.failure;
  }

  Future<AiResult<T>> _ask<T extends Object>(
    AiRequest? request,
    T? Function(String answer) check, {
    bool requireEnabled = true,
  }) async {
    var apiKey = 'demo';
    var model = aiDefaultModel;
    if (!demo) {
      if (await settings.isUnder18()) {
        return const AiResult.failed(AiFailure.underAge);
      }
      final row = await settings.get();
      final key = await keys.read();
      if ((requireEnabled && !row.enabled) ||
          row.consentVersion != aiConsentVersion ||
          key == null ||
          key.isEmpty) {
        return const AiResult.failed(AiFailure.notReady);
      }
      apiKey = key;
      model = row.model.trim().isEmpty ? aiDefaultModel : row.model.trim();
    }
    if (request == null) return const AiResult.failed(AiFailure.inputTooLong);

    // One retry, only for network trouble. Each try counts, to cap cost.
    for (var attempt = 1; ; attempt++) {
      if (!demo && !await settings.tryUseCall(realNow())) {
        return const AiResult.failed(AiFailure.quotaReached);
      }
      try {
        final answer = await client
            .complete(request, apiKey: apiKey, model: model)
            .timeout(
              aiTimeout,
              onTimeout: () => throw const AiException(AiFailure.timeout),
            );
        final value = check(answer);
        return value == null
            ? const AiResult.failed(AiFailure.badResponse)
            : AiResult.ok(value);
      } on AiException catch (e) {
        final network =
            e.failure == AiFailure.offline || e.failure == AiFailure.timeout;
        if (!network || attempt >= 2) return AiResult.failed(e.failure);
      } catch (_) {
        return const AiResult.failed(AiFailure.badResponse);
      }
    }
  }
}
