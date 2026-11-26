/// Builds what leaves the phone (CLAUDE.md section 16). Each builder takes
/// only the values that may be sent, so timetables, sleep data, and anything
/// about the user have no way in.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'ai_config.dart';
import 'area_crop.dart';

class AiRequest {
  final AiTask task;

  /// The data sent to the model, as JSON.
  final Map<String, Object?> input;

  /// Only for [AiTask.readTimetable]: the picture the user chose to send.
  final Uint8List? imageJpeg;

  const AiRequest._(this.task, this.input, {this.imageJpeg});

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

/// [jpeg] is the timetable picture, already cut, shrunk and stripped of its
/// metadata (services/timetable_image). Nothing else goes with it. Null if it
/// is empty or too big.
AiRequest? buildTimetableRequest(Uint8List jpeg) {
  if (jpeg.isEmpty || jpeg.length > maxTimetableImageBytes) return null;
  return AiRequest._(AiTask.readTimetable, const {
    'task': 'read this timetable',
  }, imageJpeg: jpeg);
}

AiRequest buildConnectionTestRequest() =>
    const AiRequest._(AiTask.connectionTest, {'ping': true});
