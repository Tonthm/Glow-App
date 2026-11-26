import '../../core/ai_payload.dart';

enum AiFailure {
  /// AI is off, not agreed to, or has no key.
  notReady,
  inputTooLong,
  quotaReached,
  offline,
  timeout,
  badKey,
  rateLimited,
  server,

  /// The answer was missing, cut off, or didn't pass the checks.
  badResponse,
}

/// Carries only what kind of failure it was. It never holds a request,
/// header, URL, or server message, so the API key can't reach a log.
class AiException implements Exception {
  final AiFailure failure;
  final int? statusCode;

  const AiException(this.failure, {this.statusCode});

  @override
  String toString() =>
      'AiException(${failure.name}${statusCode == null ? '' : ' $statusCode'})';
}

/// One call to an AI provider. Swap the implementation to change provider.
abstract interface class AiClient {
  /// The model's answer as text, still unchecked. Throws [AiException].
  Future<String> complete(
    AiRequest request, {
    required String apiKey,
    required String model,
  });
}
