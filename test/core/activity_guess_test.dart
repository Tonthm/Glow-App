import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/activity_guess.dart';
import 'package:glow/core/routine_config.dart';
import 'package:glow/core/schedule_models.dart';

ScheduleEntry entry(
  String title,
  int from,
  int to, {
  ItemKind kind = ItemKind.classSession,
}) => ScheduleEntry(
  title: title,
  kind: kind,
  start: DateTime(2026, 11, 23, from),
  end: DateTime(2026, 11, 23, to),
);

void main() {
  group('guessActivities', () {
    test('3 hours of class or more means a sitting day', () {
      expect(guessActivities([entry('เลข', 8, 11)]), {DayActivityKind.sitting});
      expect(guessActivities([entry('เลข', 8, 10), entry('เคมี', 13, 14)]), {
        DayActivityKind.sitting,
      });
      expect(guessActivities([entry('เลข', 8, 10)]), isEmpty);
    });

    test('activities do not count toward class hours', () {
      expect(
        guessActivities([entry('ประชุม', 8, 14, kind: ItemKind.activity)]),
        isEmpty,
      );
    });

    test('sport words in a class or activity name', () {
      for (final name in [
        'ฟุตบอล',
        'ซ้อมบาส',
        'แบดมินตัน',
        'วอลเลย์',
        'กีฬาสี',
        'พละ',
      ]) {
        expect(guessActivities([entry(name, 16, 17)]), {
          DayActivityKind.sport,
        }, reason: name);
      }
    });

    test('running and weights, in Thai or English', () {
      expect(guessActivities([entry('ชมรมวิ่ง', 16, 17)]), {
        DayActivityKind.running,
      });
      for (final name in ['ยิม', 'เล่นเวท', 'Fitness']) {
        expect(guessActivities([entry(name, 16, 17)]), {
          DayActivityKind.lifting,
        }, reason: name);
      }
    });

    test('several signals add up', () {
      expect(guessActivities([entry('เลข', 8, 12), entry('พละ', 13, 14)]), {
        DayActivityKind.sitting,
        DayActivityKind.sport,
      });
    });

    test('an empty day guesses nothing', () {
      expect(guessActivities([]), isEmpty);
    });
  });

  group('activityCardFrom', () {
    final day = DateTime(2026, 11, 23);

    test('from the end of the last appointment', () {
      expect(
        activityCardFrom(day, [entry('เลข', 8, 12), entry('ซ้อม', 17, 19)]),
        DateTime(2026, 11, 23, 19),
      );
    });

    test('from 16:00 on a day with nothing on', () {
      expect(activityCardFrom(day, []), DateTime(2026, 11, 23, 16));
    });
  });
}
