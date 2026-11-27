import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/sleep_calculator.dart';
import 'package:glow/core/sleep_cycles.dart';

/// Wake 06:30 on Tuesday 2026-12-01.
final _wake = DateTime(2026, 12, 1, 6, 30);

DateTime _monday(int hour, int minute) => DateTime(2026, 11, 30, hour, minute);

/// Bedtime that gives [sleep] minutes of sleep after 15 minutes to drop off.
DateTime _bedFor(int sleep) => _wake.subtract(Duration(minutes: sleep + 15));

DateTime _align(int sleep, {int cycle = 90, int targetMax = 540}) =>
    alignToCycles(
      wakeTime: _wake,
      bedtime: _bedFor(sleep),
      fallAsleepMinutes: 15,
      targetMaxMinutes: targetMax,
      cycleMinutes: cycle,
    );

int _sleep(DateTime bedtime) => plannedSleepMinutes(
  wakeTime: _wake,
  bedtime: bedtime,
  fallAsleepMinutes: 15,
);

NightPlanDraft _night(int day, DateTime bedtime, {DateTime? wake}) =>
    NightPlanDraft(
      wakeDate: DateTime(2026, 12, day),
      wakeTime: wake ?? DateTime(2026, 12, day, 6, 30),
      bedtime: bedtime,
      wakeWasCapped: false,
      bedtimeWasCapped: false,
      isPreExamNight: false,
    );

void main() {
  test('counts cycles, with the part cycle left over', () {
    expect(cyclesInSleep(540, 90), 6);
    expect(cyclesInSleep(510, 90), closeTo(5.67, 0.01));
    expect(cyclesInSleep(560, 70), 8);
    expect(cyclesInSleep(600, 100), 6);
    expect(cyclesInSleep(0, 90), 0);
    expect(cyclesInSleep(-30, 90), 0);
  });

  test('the cycle length stays between 70 and 100 minutes', () {
    expect(defaultCycleMinutes, 90);
    expect(clampCycleMinutes(50), 70);
    expect(clampCycleMinutes(85), 85);
    expect(clampCycleMinutes(120), 100);
  });

  test('rounds up to six cycles inside the target', () {
    // 8.5 h planned, target at most 9 h: bedtime 21:45 becomes 21:15.
    expect(_bedFor(510), _monday(21, 45));
    expect(_align(510), _monday(21, 15));
    expect(_sleep(_align(510)), 540);
  });

  test('keeps the time when rounding up would pass the target', () {
    expect(_align(510, targetMax: 525), _monday(21, 45));
    expect(_align(510, cycle: 70), _monday(21, 45), reason: '560 > 540');
    expect(_align(510, cycle: 100), _monday(21, 45), reason: '600 > 540');
  });

  test('works with 70 and 100 minute cycles', () {
    expect(_align(510, cycle: 70, targetMax: 600), _monday(20, 55));
    expect(_align(510, cycle: 100, targetMax: 600), _monday(20, 15));
  });

  test('whole cycles stay where they are', () {
    // An adult's 7.5 h is already five cycles.
    expect(_align(450), _bedFor(450));
    expect(_align(540), _bedFor(540));
  });

  test('works across midnight', () {
    final wake = DateTime(2026, 12, 1, 8);
    // 00:30 with 7 h 15 min of sleep becomes 00:15 with 5 cycles.
    expect(
      alignToCycles(
        wakeTime: wake,
        bedtime: DateTime(2026, 12, 1, 0, 30),
        fallAsleepMinutes: 15,
        targetMaxMinutes: 540,
        cycleMinutes: 90,
      ),
      DateTime(2026, 12, 1, 0, 15),
    );
    // And a bedtime after midnight can move back into the evening before.
    expect(
      alignToCycles(
        wakeTime: wake,
        bedtime: DateTime(2026, 12, 1, 0, 15),
        fallAsleepMinutes: 15,
        targetMaxMinutes: 600,
        cycleMinutes: 100,
      ),
      DateTime(2026, 11, 30, 23, 25),
    );
  });

  test('never later and never less sleep, whatever the numbers', () {
    for (var sleep = 0; sleep <= 660; sleep += 5) {
      for (final cycle in [70, 85, 90, 100]) {
        for (final targetMax in [480, 540, 600]) {
          final aligned = _align(sleep, cycle: cycle, targetMax: targetMax);
          expect(aligned.isAfter(_bedFor(sleep)), isFalse);
          expect(_sleep(aligned), greaterThanOrEqualTo(sleep));
          if (aligned != _bedFor(sleep)) {
            expect(_sleep(aligned) % cycle, 0);
            expect(_sleep(aligned), lessThanOrEqualTo(targetMax));
          }
        }
      }
    }
  });

  test('no sleep at all is left alone', () {
    final late = _wake.subtract(const Duration(minutes: 10));
    expect(
      alignToCycles(
        wakeTime: _wake,
        bedtime: late,
        fallAsleepMinutes: 15,
        targetMaxMinutes: 540,
        cycleMinutes: 90,
      ),
      late,
    );
  });

  test('the night before an exam is rounded the same way', () {
    const settings = SleepSettings(targetMinMinutes: 480, targetMaxMinutes: 540);
    // The midpoint, 8.5 h, becomes six cycles.
    final bedtime = calculateBedtime(
      wakeTime: _wake,
      settings: settings,
      isPreExamNight: true,
    ).bedtime;
    expect(bedtime, _monday(21, 45));
    final week = alignWeekToCycles(
      [
        NightPlanDraft(
          wakeDate: DateTime(2026, 12),
          wakeTime: _wake,
          bedtime: bedtime,
          wakeWasCapped: false,
          bedtimeWasCapped: false,
          isPreExamNight: true,
        ),
      ],
      fallAsleepMinutes: 15,
      targetMaxMinutes: 540,
      cycleMinutes: 90,
    );
    expect(week.single.bedtime, _monday(21, 15));
    expect(week.single.isPreExamNight, isTrue);
    expect(week.single.wakeTime, _wake);
  });

  group('a week', () {
    // Minutes of each night's bedtime after 20:00 the evening before.
    List<int> minutesAfter8pm(List<NightPlanDraft> nights) => [
      for (final n in nights)
        n.bedtime
            .difference(
              DateTime(
                n.wakeDate.year,
                n.wakeDate.month,
                n.wakeDate.day - 1,
                20,
              ),
            )
            .inMinutes,
    ];

    test('is evened out again, only by moving nights earlier', () {
      final nights = [
        // 8.5 h: rounds to 9 h, 30 min earlier (20:00 + 105 -> + 75).
        _night(1, _monday(21, 45)),
        // A later night with room to move.
        _night(2, DateTime(2026, 12, 1, 22, 45), wake: DateTime(2026, 12, 2, 7)),
      ];
      final result = alignWeekToCycles(
        nights,
        fallAsleepMinutes: 15,
        targetMaxMinutes: 540,
        cycleMinutes: 90,
      );
      // Night 2 has 8 h: 9 h would be 21:45, inside the target.
      expect(minutesAfter8pm(result), [75, 105]);
      for (var i = 0; i < nights.length; i++) {
        expect(result[i].bedtime.isAfter(nights[i].bedtime), isFalse);
      }
    });

    test('never moves a night past the longest target', () {
      final nights = [
        _night(1, _monday(20, 0)),
        // Already 8 h 45 min: 15 more is all the target allows.
        _night(2, DateTime(2026, 12, 1, 21, 30)),
      ];
      final result = alignWeekToCycles(
        nights,
        fallAsleepMinutes: 15,
        targetMaxMinutes: 540,
        cycleMinutes: 100,
      );
      // 100-minute cycles round neither night. Evening out would put night
      // 2 at 21:00, but 21:15 is already 9 h; no earlier is allowed.
      expect(result[0].bedtime, _monday(20, 0));
      expect(result[1].bedtime, DateTime(2026, 12, 1, 21, 15));
    });

    test('a night already over the target is left alone', () {
      final nights = [
        _night(1, _monday(19, 0)),
        _night(2, DateTime(2026, 12, 1, 20, 0)),
      ];
      final result = alignWeekToCycles(
        nights,
        fallAsleepMinutes: 15,
        targetMaxMinutes: 540,
        cycleMinutes: 90,
      );
      expect(result[1].bedtime, nights[1].bedtime);
    });
  });

  test('says why bedtime moved', () {
    expect(
      cycleReason(shiftMinutes: 30, sleepMinutes: 540, cycleMinutes: 90),
      'เข้านอนเร็วขึ้น 30 นาทีเพื่อให้ครบ 6 รอบ',
    );
    // Moved by evening out the week, so not whole cycles.
    expect(
      cycleReason(shiftMinutes: 20, sleepMinutes: 530, cycleMinutes: 90),
      'เข้านอนเร็วขึ้น 20 นาที ให้ใกล้เคียงคืนข้าง ๆ',
    );
    expect(
      cycleReason(shiftMinutes: 0, sleepMinutes: 540, cycleMinutes: 90),
      isNull,
    );
  });

  test('writes a count, to one decimal when not whole', () {
    expect(cycleCountLabel(6), '6');
    expect(cycleCountLabel(5.666), '5.7');
    expect(cycleCountLabel(5.98), '6');
  });

  test('the bar is the time to drop off, then each cycle', () {
    final parts = cycleBarParts(
      fallAsleepMinutes: 15,
      sleepMinutes: 510,
      cycleMinutes: 90,
    );
    expect([for (final p in parts) p.minutes], [15, 90, 90, 90, 90, 90, 60]);
    expect(parts.first.fallingAsleep, isTrue);
    expect(parts.skip(1).any((p) => p.fallingAsleep), isFalse);
    expect(
      cycleBarParts(fallAsleepMinutes: 0, sleepMinutes: 180, cycleMinutes: 90),
      hasLength(2),
    );
  });

  test('averages cycles over the nights that have data', () {
    expect(averageCycles([540, 450], 90), 5.5);
    expect(averageCycles([], 90), isNull);
  });
}
