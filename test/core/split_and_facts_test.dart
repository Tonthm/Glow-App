import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_explain_guard.dart';
import 'package:glow/core/ai_validators.dart';
import 'package:glow/core/evening_facts.dart';
import 'package:glow/core/evening_planner.dart';
import 'package:glow/core/split_scheduler.dart';

DateTime day(int d) => DateTime(2026, 11, d);

List<AiPart> parts(List<int> minutes) => [
  for (var i = 0; i < minutes.length; i++)
    AiPart(title: 'ช่วง ${i + 1}', minutes: minutes[i]),
];

List<DateTime> dates(List<ScheduledPart> result) => [
  for (final p in result) p.date,
];

void main() {
  test('an AI explanation may not talk about sleep cycles', () {
    const facts = ['งานทั้งหมดวางลงในเย็นนี้ได้พอดี'];
    for (final claim in [
      'นอนครบรอบการนอนพอดี',
      'จะได้ ตื่น สดชื่น',
      'ช่วงหลับลึกสำคัญมาก',
      'มีเวลาให้ REM',
      'ช่วง NREM ก็พอ',
    ]) {
      expect(
        isSafeExplanation('งานวางลงได้พอดี $claim', facts),
        isFalse,
        reason: claim,
      );
    }
    // Words that only look alike are fine.
    expect(isSafeExplanation('Remember งานวางลงได้พอดี', facts), isTrue);
  });

  group('scheduleParts', () {
    test('one part per evening when there is no deadline', () {
      final result = scheduleParts(
        parts: parts([45, 45, 45]),
        firstEvening: day(23),
      )!;
      expect(dates(result), [day(23), day(24), day(25)]);
    });

    test('shares parts evenly before the due date, in order', () {
      final result = scheduleParts(
        parts: parts([30, 30, 30, 30]),
        firstEvening: day(23),
        due: day(25),
      )!;
      expect(dates(result), [day(23), day(23), day(24), day(24)]);
    });

    test('puts only a short last part on the night before an exam', () {
      final result = scheduleParts(
        parts: parts([60, 60, 30]),
        firstEvening: day(23),
        examDate: day(26),
      )!;
      expect(result.last.date, day(25));
      expect(result.last.part.minutes, lessThanOrEqualTo(30));
      expect(result.take(2).every((p) => p.date.isBefore(day(25))), isTrue);
    });

    test('keeps long parts off the night before an exam', () {
      final result = scheduleParts(
        parts: parts([60, 60, 60]),
        firstEvening: day(23),
        examDate: day(26),
      )!;
      expect(result.every((p) => p.date.isBefore(day(25))), isTrue);
    });

    test('gives up when only the night before an exam is left', () {
      expect(
        scheduleParts(
          parts: parts([60, 60]),
          firstEvening: day(23),
          examDate: day(24),
        ),
        isNull,
      );
    });
  });

  group('facts', () {
    const tasks = [
      PlannerTask(
        id: 1,
        title: 'เลข',
        minutes: 30,
        kind: EveningTaskKind.other,
      ),
    ];

    test('overflow and exam facts come first and pass the guard', () {
      final plan = EveningPlan(
        start: DateTime(2026, 11, 23, 17),
        end: DateTime(2026, 11, 23, 20, 45),
        blocks: const [],
        overflow: const {1: 40},
        postponedForRedNight: const [],
      );
      final facts = buildEveningFacts(
        plan: plan,
        tasks: tasks,
        eveningDate: day(23),
        redNight: false,
        examTomorrow: true,
      );
      expect(facts.first.kind, EveningFactKind.overflow);
      expect(facts[1].kind, EveningFactKind.examTomorrow);
      final sentences = [for (final f in facts) f.sentence];
      expect(isSafeExplanation(templateExplanation(facts), sentences), isTrue);
    });

    test('every kind of fact has a safe template', () {
      for (final kind in EveningFactKind.values) {
        final sentence = EveningFact(
          kind,
          task: 'ก',
          otherTask: 'ข',
          minutes: 10,
          count: 2,
        ).sentence;
        expect(sentence, isNotEmpty);
        expect(hasForbiddenPhrase(sentence), isFalse);
        expect(sentence, isNot(contains('null')));
      }
    });
  });
}
