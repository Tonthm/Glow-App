import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/calendar_events.dart';

CalendarEvent event(
  String id,
  String title,
  DateTime start, {
  Duration length = const Duration(hours: 1),
  bool allDay = false,
  bool repeatsWeekly = false,
}) => CalendarEvent(
  eventId: id,
  title: title,
  start: start,
  end: start.add(length),
  allDay: allDay,
  repeatsWeekly: repeatsWeekly,
);

void main() {
  final monday = DateTime(2026, 11, 23, 8);

  group('guessEventKind', () {
    test('exam words win, in Thai and English, any case', () {
      for (final title in ['สอบกลางภาค', 'Midterm Math', 'FINAL', 'Exam 2']) {
        expect(
          guessEventKind(event('1', title, monday, repeatsWeekly: true)),
          ImportKind.exam,
          reason: title,
        );
      }
    });

    test('a weekly repeat is a class, anything else an activity', () {
      expect(
        guessEventKind(event('1', 'คณิต', monday, repeatsWeekly: true)),
        ImportKind.classSession,
      );
      expect(guessEventKind(event('1', 'ดูหนัง', monday)), ImportKind.activity);
    });
  });

  group('collapseWeeklyRepeats', () {
    test('keeps one entry per weekly series and weekday', () {
      final collapsed = collapseWeeklyRepeats([
        for (var week = 0; week < 5; week++) ...[
          event(
            'math',
            'คณิต',
            monday.add(Duration(days: 7 * week)),
            repeatsWeekly: true,
          ),
          event(
            'math',
            'คณิต',
            monday.add(Duration(days: 7 * week + 2)),
            repeatsWeekly: true,
          ),
        ],
      ]);
      expect(collapsed.map((e) => e.start.weekday), [1, 3]);
    });

    test('leaves non-weekly events alone', () {
      final events = [
        event('a', 'นัด', monday),
        event('a', 'นัด', monday.add(const Duration(days: 7))),
      ];
      expect(collapseWeeklyRepeats(events), hasLength(2));
    });
  });

  group('minutesOfDay', () {
    test('an event ending past midnight is cut off at 23:59', () {
      final late = event(
        '1',
        'ค่าย',
        DateTime(2026, 11, 23, 22),
        length: const Duration(hours: 4),
      );
      expect(importMinutes(late), (start: 22 * 60, end: 23 * 60 + 59));
    });
  });
}
