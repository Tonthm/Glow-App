import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/ai_config.dart';
import '../../core/ai_payload.dart';
import 'ai_client.dart';

/// Gemini's Interactions API, called straight from the phone with the user's
/// own key.
///
/// No "Api-Revision" header: Google's reference works without it, and adding
/// it makes the browser's preflight check fail (403, seen on 26 Nov 2026),
/// which would break the web version.
class GeminiAiClient implements AiClient {
  static final Uri endpoint = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/interactions',
  );

  final http.Client _http;
  final Duration timeout;

  GeminiAiClient({http.Client? client, this.timeout = aiTimeout})
    : _http = client ?? http.Client();

  static Map<String, Object?> requestBody(AiRequest request, String model) => {
    'model': model,
    'system_instruction': request.systemInstruction,
    'input': request.imageJpeg == null
        ? request.inputJson
        : [
            {'type': 'text', 'text': request.inputJson},
            {
              'type': 'image',
              'data': base64Encode(request.imageJpeg!),
              'mime_type': 'image/jpeg',
            },
          ],
    'response_format': {
      'type': 'text',
      'mime_type': 'application/json',
      'schema': request.schema,
    },
    'generation_config': {
      'max_output_tokens': aiOutputTokensFor(request.task),
      'thinking_level': 'minimal',
    },
    // Don't keep the request on Google's side for later retrieval.
    'store': false,
  };

  @override
  Future<String> complete(
    AiRequest request, {
    required String apiKey,
    required String model,
  }) async {
    final http.Response response;
    try {
      response = await _http
          .post(
            endpoint,
            // The key goes in a header, never in the URL.
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey,
            },
            body: jsonEncode(requestBody(request, model)),
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const AiException(AiFailure.timeout);
    } catch (_) {
      // The original error is dropped on purpose.
      throw const AiException(AiFailure.offline);
    }

    final status = response.statusCode;
    if (status != 200) {
      // A wrong key comes back as 400, not 401 (seen on 26 Nov 2026). The body
      // is only searched, never kept.
      if (status == 400 && response.body.contains('API_KEY_INVALID')) {
        throw const AiException(AiFailure.badKey, statusCode: 400);
      }
      throw AiException(switch (status) {
        401 || 403 => AiFailure.badKey,
        402 || 429 => AiFailure.rateLimited,
        _ => AiFailure.server,
      }, statusCode: status);
    }
    final text = modelText(utf8.decode(response.bodyBytes));
    if (text == null) throw const AiException(AiFailure.badResponse);
    return text;
  }

  /// The text in the model's output steps, or null if the reply isn't a
  /// finished one.
  static String? modelText(String body) {
    try {
      final map = jsonDecode(body);
      if (map is! Map || map['status'] != 'completed') return null;
      final steps = map['steps'];
      if (steps is! List) return null;
      final text = StringBuffer();
      for (final step in steps) {
        if (step is! Map || step['type'] != 'model_output') continue;
        final content = step['content'];
        if (content is! List) continue;
        for (final part in content) {
          if (part is Map && part['type'] == 'text' && part['text'] is String) {
            text.write(part['text']);
          }
        }
      }
      return text.isEmpty ? null : text.toString();
    } on FormatException {
      return null;
    }
  }
}
