/// Reads the AI's answers (CLAUDE.md section 16). Each parser returns null if
/// anything at all is wrong, and the caller then uses the way that needs no
/// AI. Bad answers are never repaired or guessed at.
library;

import 'dart:convert';

import 'ai_config.dart';
import 'ai_explain_guard.dart';
import 'evening_planner.dart';

const int aiMaxTasks = 10;
const int aiMaxTitleChars = 100;
const int aiMaxReasonChars = 150;
const int aiMinTaskMinutes = 5;
const int aiMaxTaskMinutes = 600;
const int aiMaxEstimateMinutes = 240;
const int aiMinParts = 2;
const int aiMaxParts = 8;
const int aiMinPartMinutes = 15;
const int aiMaxPartMinutes = 60;
const int _maxDaysAhead = 365;

enum AiTaskField { title, kind, due, minutes, exam }

class AiParsedTask {
  final String title;
  final EveningTaskKind kind;
  final DateTime? due;
  final int? minutes;
  final String? examName;
  final Set<AiTaskField> uncertain;

  const AiParsedTask({
    required this.title,
    required this.kind,
    this.due,
    this.minutes,
    this.examName,
    this.uncertain = const {},
  });
}

class AiEstimate {
  final int minutes;
  final int low;
  final int high;
  final String reason;

  const AiEstimate({
    required this.minutes,
    required this.low,
    required this.high,
    required this.reason,
  });
}

class AiPart {
  final String title;
  final int minutes;

  const AiPart({required this.title, required this.minutes});
}

/// [value] as a map with exactly [keys], no more and no fewer.
Map<String, Object?>? _exact(Object? value, Set<String> keys) {
  if (value is! Map<String, Object?>) return null;
  if (value.length != keys.length || !keys.every(value.containsKey)) {
    return null;
  }
  return value;
}

Map<String, Object?>? _decode(String text, Set<String> keys) {
  if (text.length > aiMaxResponseChars) return null;
  try {
    return _exact(jsonDecode(text), keys);
  } on FormatException {
    return null;
  }
}

/// Task lengths move in 5-minute steps.
int roundToFive(int minutes) => ((minutes / 5).round() * 5).clamp(5, 24 * 60);

/// A "YYYY-MM-DD" that is a real day.
DateTime? _date(String text) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
  if (match == null) return null;
  final year = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  final day = int.parse(match[3]!);
  final date = DateTime(year, month, day);
  // DateTime rolls "02-30" over into March.
  return date.month == month && date.day == day ? date : null;
}

/// An AI-written title. A banned phrase is allowed only if the user's own
/// [source] text already had one.
String? _title(Object? value, String source) {
  if (value is! String) return null;
  final title = value.trim();
  if (title.isEmpty || title.length > aiMaxTitleChars) return null;
  if (hasForbiddenPhrase(title) && !hasForbiddenPhrase(source)) return null;
  return title;
}

/// Tasks split out of the user's [source] text.
List<AiParsedTask>? parseAiTasks(
  String response, {
  required String source,
  required DateTime today,
}) {
  final root = _decode(response, {'tasks'});
  final list = root?['tasks'];
  if (list is! List || list.isEmpty || list.length > aiMaxTasks) return null;

  final first = DateTime(today.year, today.month, today.day);
  final last = DateTime(today.year, today.month, today.day + _maxDaysAhead);
  final result = <AiParsedTask>[];
  for (final item in list) {
    final map = _exact(item, {
      'title',
      'kind',
      'due',
      'minutes',
      'exam',
      'uncertain',
    });
    if (map == null) return null;

    final title = _title(map['title'], source);
    final kindName = map['kind'];
    if (title == null || !aiTaskKinds.contains(kindName)) return null;

    DateTime? due;
    final dueValue = map['due'];
    if (dueValue != null) {
      due = dueValue is String ? _date(dueValue) : null;
      if (due == null || due.isBefore(first) || due.isAfter(last)) return null;
    }

    final minutes = map['minutes'];
    if (minutes != null &&
        (minutes is! int ||
            minutes < aiMinTaskMinutes ||
            minutes > aiMaxTaskMinutes)) {
      return null;
    }

    final exam = map['exam'];
    if (exam != null && (exam is! String || exam.length > aiMaxTitleChars)) {
      return null;
    }

    final uncertain = map['uncertain'];
    if (uncertain is! List || !uncertain.every(aiUncertainFields.contains)) {
      return null;
    }

    result.add(
      AiParsedTask(
        title: title,
        kind: EveningTaskKind.values.byName(kindName as String),
        due: due,
        minutes: minutes == null ? null : roundToFive(minutes as int),
        examName: exam as String?,
        uncertain: {
          for (final name in uncertain)
            AiTaskField.values.byName(name as String),
        },
      ),
    );
  }
  return result;
}

AiEstimate? parseAiEstimate(String response) {
  final map = _decode(response, {'minutes', 'low', 'high', 'reason'});
  if (map == null) return null;
  final minutes = map['minutes'];
  final low = map['low'];
  final high = map['high'];
  final reason = map['reason'];
  if (minutes is! int || low is! int || high is! int || reason is! String) {
    return null;
  }
  for (final value in [minutes, low, high]) {
    if (value < aiMinTaskMinutes || value > aiMaxEstimateMinutes) return null;
  }
  if (minutes < low || minutes > high) return null;
  final line = reason.trim();
  if (line.isEmpty ||
      line.length > aiMaxReasonChars ||
      line.contains('\n') ||
      hasForbiddenPhrase(line)) {
    return null;
  }
  return AiEstimate(
    minutes: roundToFive(minutes),
    low: roundToFive(low),
    high: roundToFive(high),
    reason: line,
  );
}

/// The parts of one task, in order. [source] is the original title.
List<AiPart>? parseAiSplit(
  String response, {
  required String source,
  required int totalMinutes,
}) {
  final root = _decode(response, {'parts'});
  final list = root?['parts'];
  if (list is! List || list.length < aiMinParts || list.length > aiMaxParts) {
    return null;
  }

  final byOrder = <int, AiPart>{};
  var sum = 0;
  for (final item in list) {
    final map = _exact(item, {'title', 'minutes', 'order'});
    if (map == null) return null;
    final title = _title(map['title'], source);
    final minutes = map['minutes'];
    final order = map['order'];
    if (title == null || minutes is! int || order is! int) return null;
    if (minutes < aiMinPartMinutes || minutes > aiMaxPartMinutes) return null;
    if (order < 1 || order > list.length || byOrder.containsKey(order)) {
      return null;
    }
    byOrder[order] = AiPart(title: title, minutes: minutes);
    sum += minutes;
  }
  // Within 10% of the original, counted in whole numbers.
  if ((sum - totalMinutes).abs() * 10 > totalMinutes) return null;
  return [for (var i = 1; i <= list.length; i++) byOrder[i]!];
}

/// The explanation, if it passes [isSafeExplanation] against [facts].
String? parseAiExplanation(String response, List<String> facts) {
  final summary = _decode(response, {'summary'})?['summary'];
  if (summary is! String || !isSafeExplanation(summary, facts)) return null;
  return summary.trim();
}

bool parseAiConnectionTest(String response) =>
    _decode(response, {'ok'})?['ok'] == true;
