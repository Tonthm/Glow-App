import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_explain_guard.dart';
import 'package:glow/core/task_reminders.dart';

DateTime _at(int day, int hour, [int minute = 0]) =>
    DateTime(2026, 11, day, hour, minute);

/// Bed at 21:50 and up at 06:35 every night from the 25th.
final _nights = [
  for (var day = 25; day <= 35; day++)
    SleepWindow(bedtime: _at(day, 21, 50), wake: _at(day + 1, 6, 35)),
];

void main() {
  final now = _at(26, 12);

  group('never in the way of sleep', () {
    DateTime? clamp(DateTime at) =>
        clampToSleep(at, nights: _nights, now: now);

    test('a time before bedtime stays', () {
      expect(clamp(_at(26, 18)), _at(26, 18));
      expect(clamp(_at(26, 21, 50)), _at(26, 21, 50));
      expect(clamp(_at(27, 6, 35)), _at(27, 6, 35));
      expect(clamp(_at(27, 7, 45)), _at(27, 7, 45));
    });

    test('a time after bedtime comes back to putting the phone down', () {
      expect(clamp(_at(26, 21, 51)), _at(26, 20, 50));
      expect(clamp(_at(26, 22, 45)), _at(26, 20, 50));
      expect(clamp(_at(27, 3)), _at(26, 20, 50));
      expect(clamp(_at(27, 6, 34)), _at(26, 20, 50));
    });

    test('it is dropped if that moment has passed', () {
      expect(
        clampToSleep(_at(26, 23), nights: _nights, now: _at(26, 21)),
        isNull,
      );
      expect(clamp(_at(26, 11)), isNull);
    });

    test('it is dropped where the nights are not known', () {
      expect(
        clampToSleep(
          DateTime(2027, 3, 1, 18),
          nights: _nights,
          now: now,
        ),
        isNull,
      );
    });

    test('no result is ever inside a night, whatever the time asked', () {
      for (var minutes = 0; minutes < 5 * 24 * 60; minutes += 7) {
        final result = clamp(now.add(Duration(minutes: minutes)));
        if (result == null) continue;
        expect(
          _nights.any(
            (n) => result.isAfter(n.bedtime) && result.isBefore(n.wake),
          ),
          isFalse,
          reason: '$result',
        );
      }
    });

    test('an early bedtime moves an evening reminder before it', () {
      // A night that starts at 17:30.
      final early = [
        SleepWindow(bedtime: _at(26, 17, 30), wake: _at(27, 4)),
      ];
      expect(
        clampToSleep(_at(26, 18), nights: early, now: now),
        _at(26, 16, 30),
      );
    });
  });

  group('what is reminded', () {
    final classes = [
      UpcomingClass(title: 'คณิต', start: _at(27, 8)),
      UpcomingClass(title: 'ติวค่ำ', start: _at(27, 23)),
    ];
    final deadlines = [
      UpcomingDeadline(title: 'รายงาน', due: _at(28, 0)),
      UpcomingDeadline(title: 'การบ้าน', due: _at(28, 0)),
    ];

    List<TaskReminder> build({int? classLead, bool due = false}) =>
        taskReminders(
          classes: classes,
          deadlines: deadlines,
          nights: _nights,
          now: now,
          beforeClassMinutes: classLead,
          deadlinesOn: due,
        );

    test('nothing unless asked for', () {
      expect(build(), isEmpty);
    });

    test('before each class, held back from the night', () {
      final result = build(classLead: 15);
      expect(result.map((r) => (r.title, r.at)), [
        ('อีก 15 นาทีเริ่มคาบ คณิต', _at(27, 7, 45)),
        // 22:45 would be after bedtime.
        ('คาบ ติวค่ำ เริ่ม 23:00', _at(27, 20, 50)),
      ]);
    });

    test('deadlines the evening before, one reminder for the day', () {
      final result = build(due: true);
      expect(result.single.at, _at(27, 18));
      expect(result.single.title, 'พรุ่งนี้มีงานต้องส่ง 2 งาน');
      expect(result.single.body, 'การบ้าน, รายงาน');
    });

    test('ids stay the same for the same thing', () {
      final first = build(classLead: 15, due: true);
      final again = build(classLead: 30, due: true);
      expect(again.map((r) => r.uid).toSet(), first.map((r) => r.uid).toSet());
      expect(first.map((r) => r.uid).toSet(), hasLength(first.length));
    });

    test('in time order, and never about sleeping less', () {
      final result = build(classLead: 60, due: true);
      for (var i = 1; i < result.length; i++) {
        expect(result[i].at.isBefore(result[i - 1].at), isFalse);
      }
      for (final reminder in result) {
        expect(
          hasForbiddenPhrase('${reminder.title} ${reminder.body}'),
          isFalse,
        );
      }
    });
  });
}
