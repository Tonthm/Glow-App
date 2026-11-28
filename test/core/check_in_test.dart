import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/sleep_calculator.dart';

const settings = SleepSettings(
  targetMinMinutes: 480, // 8h
  targetMaxMinutes: 600, // 10h
  fallAsleepMinutes: 15,
);

DateTime d(int y, int m, int day, [int h = 0, int min = 0]) =>
    DateTime(y, m, day, h, min);

void main() {
  group('classifyCheckIn', () {
    test('sleeping exactly the target minimum is enough', () {
      // lights off 22:00, wake 06:15 -> awake span 8h15m - 15m fall-asleep = 8h.
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 23, 22, 0),
        actualWakeAt: d(2026, 11, 24, 6, 15),
        plannedBedtime: d(2026, 11, 23, 22, 0),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.result, CheckInResult.enough);
      expect(outcome.sleepDuration, const Duration(hours: 8));
      expect(outcome.onTime, isTrue);
    });

    test('short of minimum by exactly 60 minutes is almost enough', () {
      // target min 8h; sleeping 7h is exactly 60 min short.
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 23, 23, 0),
        actualWakeAt: d(2026, 11, 24, 6, 15),
        plannedBedtime: d(2026, 11, 23, 22, 0),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.result, CheckInResult.almostEnough);
    });

    test('short of minimum by more than 60 minutes is not enough', () {
      // sleeping 6h59m -> 61 min short of the 8h minimum.
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 23, 23, 1),
        actualWakeAt: d(2026, 11, 24, 6, 15),
        plannedBedtime: d(2026, 11, 23, 22, 0),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.result, CheckInResult.notEnough);
    });

    test('sleeping more than the target maximum is over', () {
      // lights off 20:00, wake 06:30 -> 10h15m awake span - 15m = 10h exactly
      // at the max; push wake 1 min later to go over.
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 23, 20, 0),
        actualWakeAt: d(2026, 11, 24, 6, 31),
        plannedBedtime: d(2026, 11, 23, 21, 50),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.result, CheckInResult.over);
    });

    test('lights off within 45 minutes of plan is on time', () {
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 23, 22, 30),
        actualWakeAt: d(2026, 11, 24, 6, 45),
        plannedBedtime: d(2026, 11, 23, 21, 50),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.onTime, isTrue);
    });

    test('lights off 46 minutes from plan is not on time', () {
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 23, 22, 36),
        actualWakeAt: d(2026, 11, 24, 6, 51),
        plannedBedtime: d(2026, 11, 23, 21, 50),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.onTime, isFalse);
    });

    test('sleeping past midnight into the next calendar day works', () {
      // lights off 00:30 (after midnight), wake 08:45.
      final outcome = classifyCheckIn(
        lightsOffAt: d(2026, 11, 24, 0, 30),
        actualWakeAt: d(2026, 11, 24, 8, 45),
        plannedBedtime: d(2026, 11, 24, 0, 30),
        settings: settings,
        pressedInBed: true,
      );
      expect(outcome.result, CheckInResult.enough);
      expect(outcome.sleepDuration, const Duration(hours: 8));
    });
  });

  test('without pressing in bed, a night is never on time', () {
    final outcome = classifyCheckIn(
      lightsOffAt: d(2026, 11, 23, 22, 0),
      actualWakeAt: d(2026, 11, 24, 6, 15),
      plannedBedtime: d(2026, 11, 23, 22, 0),
      settings: settings,
      pressedInBed: false,
    );
    expect(outcome.result, CheckInResult.enough);
    expect(outcome.onTime, isFalse);
  });

  group('check-in window', () {
    test('window opens 2 hours before planned wake', () {
      final plannedWake = d(2026, 11, 24, 6, 35);
      expect(
        isCheckInWindowOpen(
          plannedWakeTime: plannedWake,
          now: d(2026, 11, 24, 4, 35),
        ),
        isTrue,
      );
      expect(
        isCheckInWindowOpen(
          plannedWakeTime: plannedWake,
          now: d(2026, 11, 24, 4, 34),
        ),
        isFalse,
      );
    });

    test('window closes at 14:00 the day after the wake date', () {
      final plannedWake = d(2026, 11, 24, 6, 35);
      expect(
        isCheckInWindowOpen(
          plannedWakeTime: plannedWake,
          now: d(2026, 11, 25, 14, 0),
        ),
        isTrue,
      );
      expect(
        isCheckInWindowOpen(
          plannedWakeTime: plannedWake,
          now: d(2026, 11, 25, 14, 1),
        ),
        isFalse,
      );
    });
  });

  group('wakeTimeAnswer', () {
    final wakeDate = DateTime(2026, 12, 1);
    final planned = DateTime(2026, 12, 1, 6, 35);
    WakeTimeAnswer at(int day, int hour, int minute, [int second = 0]) =>
        wakeTimeAnswer(
          wakeDate: wakeDate,
          plannedWakeTime: planned,
          now: DateTime(2026, 12, day, hour, minute, second),
        );

    test('around the planned time, the press is the wake time', () {
      expect(at(1, 4, 35), WakeTimeAnswer.pressTime);
      expect(at(1, 6, 35), WakeTimeAnswer.pressTime);
      // Two hours after, to the end of that minute.
      expect(at(1, 8, 35, 59), WakeTimeAnswer.pressTime);
    });

    test('later that day, the user is asked', () {
      expect(at(1, 8, 36), WakeTimeAnswer.askSameDay);
      expect(at(1, 23, 59), WakeTimeAnswer.askSameDay);
    });

    test('the next day, only the user can say', () {
      expect(at(2, 0, 0), WakeTimeAnswer.askNextDay);
      expect(at(2, 9, 0), WakeTimeAnswer.askNextDay);
    });
  });

  group('resolveCheckInTimes', () {
    final wakeDate = d(2026, 11, 23);

    test('lights off before midnight belongs to the evening before', () {
      final times = resolveCheckInTimes(
        wakeDate: wakeDate,
        lightsOffHour: 21,
        lightsOffMinute: 50,
        wakeHour: 6,
        wakeMinute: 35,
      );
      expect(times.lightsOffAt, d(2026, 11, 22, 21, 50));
      expect(times.wakeAt, d(2026, 11, 23, 6, 35));
    });

    test('lights off after midnight belongs to the wake date', () {
      final times = resolveCheckInTimes(
        wakeDate: wakeDate,
        lightsOffHour: 0,
        lightsOffMinute: 30,
        wakeHour: 6,
        wakeMinute: 35,
      );
      expect(times.lightsOffAt, d(2026, 11, 23, 0, 30));
      expect(times.wakeAt.difference(times.lightsOffAt).inMinutes, 365);
    });
  });

  group('actualSleepDuration', () {
    test('subtracts the time it takes to fall asleep', () {
      expect(
        actualSleepDuration(
          lightsOffAt: d(2026, 11, 22, 21, 50),
          wakeAt: d(2026, 11, 23, 6, 35),
          fallAsleepMinutes: 15,
        ),
        const Duration(hours: 8, minutes: 30),
      );
    });

    test('never goes negative', () {
      expect(
        actualSleepDuration(
          lightsOffAt: d(2026, 11, 23, 6, 30),
          wakeAt: d(2026, 11, 23, 6, 35),
          fallAsleepMinutes: 15,
        ),
        Duration.zero,
      );
    });
  });
}
