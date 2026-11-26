import 'dart:convert';

import '../../core/ai_config.dart';
import '../../core/ai_payload.dart';
import '../../core/thai_task_parser.dart';
import 'ai_client.dart';

/// An [AiClient] with no network and no key, for tests and demo mode. By
/// default it makes plausible answers from the request; [respond] replaces
/// that.
class FakeAiClient implements AiClient {
  final Future<String> Function(AiRequest request)? respond;

  /// Every request seen, newest last.
  final List<AiRequest> requests = [];

  FakeAiClient({this.respond});

  @override
  Future<String> complete(
    AiRequest request, {
    required String apiKey,
    required String model,
  }) {
    requests.add(request);
    return respond?.call(request) ?? Future.value(demoAnswer(request));
  }

  static String demoAnswer(AiRequest request) {
    final input = request.input;
    return jsonEncode(switch (request.task) {
      AiTask.parseTasks => {'tasks': _tasks(input)},
      AiTask.estimate => {
        'minutes': 45,
        'low': 30,
        'high': 60,
        'reason': 'งานลักษณะนี้มักใช้ประมาณคาบเดียว',
      },
      AiTask.split => {'parts': _parts(input)},
      AiTask.explain => {'summary': (input['facts'] as List).take(2).join(' ')},
      AiTask.connectionTest => {'ok': true},
    });
  }

  /// Splits on "แล้วก็" and reads each piece with the rule parser.
  static List<Object> _tasks(Map<String, Object?> input) {
    final today = DateTime.parse(input['today'] as String);
    final result = <Object>[];
    for (final piece in (input['text'] as String).split('แล้วก็')) {
      final task = parseSpokenTask(piece, now: today);
      if (task.title.isEmpty) continue;
      result.add({
        'title': task.title,
        'kind': task.kind.name,
        'due': task.due == null ? null : isoDate(task.due!),
        'minutes': task.minutes,
        'exam': null,
        'uncertain': ['kind'],
      });
    }
    return result;
  }

  static List<Object> _parts(Map<String, Object?> input) {
    final total = input['totalMinutes'] as int;
    final count = (total / 45).ceil().clamp(2, 8);
    final each = total ~/ count;
    return [
      for (var i = 0; i < count; i++)
        {
          'title': '${input['title']} ช่วงที่ ${i + 1}',
          'minutes': i == count - 1 ? total - each * (count - 1) : each,
          'order': i + 1,
        },
    ];
  }
}
