/// The photo on the card never goes to the AI (CLAUDE.md section 12).
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_config.dart';
import 'package:glow/core/ai_payload.dart';

void main() {
  final today = DateTime(2026, 11, 26);

  /// Everything each job may send. A new job, or a new value, has to be added
  /// here on purpose.
  const allowed = {
    AiTask.parseTasks: {'today', 'text'},
    AiTask.estimate: {'today', 'title', 'due'},
    AiTask.split: {'today', 'title', 'totalMinutes', 'due'},
    AiTask.explain: {'facts'},
    AiTask.connectionTest: {'ping'},
  };

  final requests = [
    buildParseRequest(text: 'ทำเลข', today: today)!,
    buildEstimateRequest(title: 'ทำเลข', today: today)!,
    buildSplitRequest(title: 'ทำเลข', totalMinutes: 120, today: today)!,
    buildExplainRequest(['พรุ่งนี้มีสอบ'])!,
    buildConnectionTestRequest(),
  ];

  test('every AI job is covered here', () {
    expect(allowed.keys.toSet(), AiTask.values.toSet());
    expect(requests.map((r) => r.task).toSet(), AiTask.values.toSet());
  });

  test('no job may send a photo', () {
    for (final request in requests) {
      expect(request.input.keys.toSet(), allowed[request.task]);
    }
    for (final keys in allowed.values) {
      expect(keys.where((k) => RegExp('photo|image|jpeg').hasMatch(k)), isEmpty);
    }
  });

  test('no AI code can reach the card photo', () {
    final files = [
      ...Directory('lib/services/ai').listSync(recursive: true),
      ...Directory('lib/features/ai').listSync(recursive: true),
      ...Directory('lib/core').listSync().where(
        (f) => f.uri.pathSegments.last.startsWith('ai_'),
      ),
      File('lib/data/ai_settings_repository.dart'),
    ].whereType<File>().toList();
    expect(files.length, greaterThan(10));
    for (final file in files) {
      final source = file.readAsStringSync();
      expect(
        RegExp(
          'cardPhoto|CardPhoto|card_repository|cardRepository|card_photo'
          '|photo_processor',
        ).hasMatch(source),
        isFalse,
        reason: file.path,
      );
    }
  });
}
