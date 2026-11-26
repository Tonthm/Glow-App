/// Builds what leaves the phone (CLAUDE.md section 16). Each builder takes
/// only the values that may be sent, so timetables, sleep data, and anything
/// about the user have no way in.
library;

import 'dart:convert';

import 'ai_config.dart';

class AiRequest {
  final AiTask task;

  /// The data sent to the model, as JSON.
  final Map<String, Object?> input;

  const AiRequest._(this.task, this.input);

  String get systemInstruction => aiSystemPrompts[task]!;
  Map<String, Object> get schema => aiSchemas[task]!;
  String get inputJson => jsonEncode(input);
}

String isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Null when [text] is empty or longer than allowed. It is never cut short,
/// so the user knows exactly what was sent.
AiRequest? buildParseRequest({required String text, required DateTime today}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || trimmed.length > aiMaxInputChars) return null;
  return AiRequest._(AiTask.parseTasks, {
    'today': isoDate(today),
    'text': trimmed,
  });
}

AiRequest? buildEstimateRequest({
  required String title,
  required DateTime today,
  DateTime? due,
}) {
  final trimmed = title.trim();
  if (trimmed.isEmpty || trimmed.length > aiMaxInputChars) return null;
  return AiRequest._(AiTask.estimate, {
    'today': isoDate(today),
    'title': trimmed,
    'due': due == null ? null : isoDate(due),
  });
}

AiRequest? buildSplitRequest({
  required String title,
  required int totalMinutes,
  required DateTime today,
  DateTime? due,
}) {
  final trimmed = title.trim();
  if (trimmed.isEmpty || trimmed.length > aiMaxInputChars) return null;
  return AiRequest._(AiTask.split, {
    'today': isoDate(today),
    'title': trimmed,
    'totalMinutes': totalMinutes,
    'due': due == null ? null : isoDate(due),
  });
}

/// [facts] are the sentences made by core/evening_facts. Later facts are left
/// out if they would make the text too long.
AiRequest? buildExplainRequest(List<String> facts) {
  final kept = <String>[];
  var length = 0;
  for (final fact in facts) {
    length += fact.length;
    if (length > aiMaxInputChars) break;
    kept.add(fact);
  }
  if (kept.isEmpty) return null;
  return AiRequest._(AiTask.explain, {'facts': kept});
}

AiRequest buildConnectionTestRequest() =>
    const AiRequest._(AiTask.connectionTest, {'ping': true});
