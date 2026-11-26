import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/sleep_calculator.dart';
import 'package:glow/core/story_share.dart';

final now = DateTime(2026, 11, 27, 9);

/// The night that ends [ago] days before [now].
StoryNight night(
  int ago, {
  int offHour = 23,
  int offMinute = 0,
  int wakeHour = 6,
  int wakeMinute = 30,
  CheckInResult result = CheckInResult.enough,
}) {
  final wake = DateTime(now.year, now.month, now.day - ago);
  final times = resolveCheckInTimes(
    wakeDate: wake,
    lightsOffHour: offHour,
    lightsOffMinute: offMinute,
    wakeHour: wakeHour,
    wakeMinute: wakeMinute,
  );
  return StoryNight(
    wakeDate: wake,
    lightsOffAt: times.lightsOffAt,
    wakeAt: times.wakeAt,
    result: result,
  );
}

StorySummary build(
  List<StoryNight> nights,
  StoryView view, {
  int fallAsleep = 15,
}) => buildStory(nights, view, now: now, fallAsleepMinutes: fallAsleep);

void main() {
  group('dot colors', () {
    test('each saved result has its dot', () {
      expect(storyDotFor(CheckInResult.enough), StoryDot.full);
      expect(storyDotFor(CheckInResult.over), StoryDot.full);
      expect(storyDotFor(CheckInResult.almostEnough), StoryDot.slightlyShort);
      expect(storyDotFor(CheckInResult.notEnough), StoryDot.veryShort);
      expect(storyDotFor(null), StoryDot.none);
    });

    test('yellow ends where the check-in verdict says it does', () {
      const settings = SleepSettings(
        targetMinMinutes: 480,
        targetMaxMinutes: 600,
      );
      StoryDot dotAfter(int sleptMinutes) {
        final wake = DateTime(2026, 11, 27, 7);
        final outcome = classifyCheckIn(
          lightsOffAt: wake.subtract(Duration(minutes: sleptMinutes + 15)),
          actualWakeAt: wake,
          plannedBedtime: DateTime(2026, 11, 26, 22),
          settings: settings,
          pressedInBed: true,
        );
        return storyDotFor(outcome.result);
      }

      expect(dotAfter(480), StoryDot.full);
      expect(dotAfter(479), StoryDot.slightlyShort);
      expect(dotAfter(480 - slightlyShortMinutes), StoryDot.slightlyShort);
      expect(dotAfter(479 - slightlyShortMinutes), StoryDot.veryShort);
    });
  });

  group('which nights', () {
    test('seven and thirty nights end at the newest recorded one', () {
      final nights = [night(2), night(5)];
      final week = build(nights, StoryView.week);
      expect(week.cells, hasLength(7));
      expect(week.cells.last.wakeDate, DateTime(2026, 11, 25));
      expect(week.cells.first.wakeDate, DateTime(2026, 11, 19));
      final month = build(nights, StoryView.month);
      expect(month.cells, hasLength(30));
      expect(month.cells.first.wakeDate, DateTime(2026, 10, 27));
    });

    test('the window is rolling, not a calendar week or month', () {
      final week = build([night(0)], StoryView.week);
      // 27 Nov 2026 is a Friday, so the window starts on a Saturday.
      expect(week.cells.first.wakeDate.weekday, DateTime.saturday);
    });

    test('a night dated after today is ignored', () {
      final week = build([night(-1), night(1)], StoryView.week);
      expect(week.cells.last.wakeDate, DateTime(2026, 11, 26));
      expect(week.nightsWithData, 1);
    });

    test('nights older than the window are not counted', () {
      final week = build([night(0), night(7), night(40)], StoryView.week);
      expect(week.nightsWithData, 1);
      final month = build([night(0), night(7), night(40)], StoryView.month);
      expect(month.nightsWithData, 2);
    });

    test('dots follow the days in order, empty ones included', () {
      final week = build([
        night(0, result: CheckInResult.notEnough),
        night(2, result: CheckInResult.almostEnough),
        night(6),
      ], StoryView.week);
      expect(
        [for (final c in week.cells) c.dot],
        [
          StoryDot.full,
          StoryDot.none,
          StoryDot.none,
          StoryDot.none,
          StoryDot.slightlyShort,
          StoryDot.none,
          StoryDot.veryShort,
        ],
      );
    });

    test('the last night view is one night', () {
      final story = build([night(0), night(1)], StoryView.night);
      expect(story.cells, hasLength(1));
      expect(story.nightsWithData, 1);
      expect(story.isIncomplete, isFalse);
    });

    test('with nothing recorded there is nothing to share', () {
      for (final view in StoryView.values) {
        final story = build([], view);
        expect(story.canShare, isFalse);
        expect(story.sleep, isNull);
        expect(story.bedMinutes, isNull);
        expect(story.wakeMinutes, isNull);
        expect(story.cells, hasLength(view.nights));
        expect(story.cells.every((c) => c.dot == StoryDot.none), isTrue);
      }
    });
  });

  group('averages', () {
    test('hours use the app\'s own sleep time, less falling asleep', () {
      final one = night(0); // 23:00 to 06:30
      final story = build([one], StoryView.night);
      expect(
        story.sleep,
        actualSleepDuration(
          lightsOffAt: one.lightsOffAt,
          wakeAt: one.wakeAt,
          fallAsleepMinutes: 15,
        ),
      );
      expect(story.sleep, const Duration(hours: 7, minutes: 15));
      expect(
        build([one], StoryView.night, fallAsleep: 30).sleep,
        const Duration(hours: 7),
      );
    });

    test('nights without data are not counted as zero', () {
      final story = build([
        night(0, offHour: 23), // 7:15
        night(4, offHour: 22), // 8:15
      ], StoryView.week);
      expect(story.sleep, const Duration(hours: 7, minutes: 45));
      expect(story.nightsWithData, 2);
      expect(story.isIncomplete, isTrue);
    });

    test('23:30 and 00:30 average to midnight, not noon', () {
      final story = build([
        night(0, offHour: 23, offMinute: 30),
        night(1, offHour: 0, offMinute: 30),
      ], StoryView.week);
      expect(story.bedMinutes, 0);
    });

    test('an average just before midnight stays before it', () {
      final story = build([
        night(0, offHour: 23, offMinute: 0),
        night(1, offHour: 23, offMinute: 30),
        night(2, offHour: 0, offMinute: 15),
      ], StoryView.week);
      expect(story.bedMinutes, 23 * 60 + 35);
    });

    test('an average just after midnight stays after it', () {
      final story = build([
        night(0, offHour: 23, offMinute: 50),
        night(1, offHour: 1, offMinute: 10),
      ], StoryView.week);
      expect(story.bedMinutes, 30);
    });

    test('morning wake times, and a very late one', () {
      final story = build([
        night(0, wakeHour: 6, wakeMinute: 0),
        night(1, offHour: 3, wakeHour: 13, wakeMinute: 0),
      ], StoryView.week);
      expect(story.wakeMinutes, 9 * 60 + 30);
    });

    test('halves round to the nearest minute', () {
      final story = build([
        night(0, offHour: 23, offMinute: 0),
        night(1, offHour: 23, offMinute: 1),
      ], StoryView.week);
      expect(story.bedMinutes, 23 * 60 + 1);
    });

    test('thirty full nights', () {
      final story = build([
        for (var i = 0; i < 30; i++) night(i, offHour: i.isEven ? 22 : 0),
      ], StoryView.month);
      expect(story.nightsWithData, 30);
      expect(story.isIncomplete, isFalse);
      expect(story.bedMinutes, 23 * 60);
      expect(story.sleep, const Duration(hours: 7, minutes: 15));
    });
  });

  group('words on the picture', () {
    test('time slept and clock times', () {
      expect(storyDuration(const Duration(hours: 7, minutes: 5)), (7, 5));
      expect(storyClock(0), '00:00');
      expect(storyClock(23 * 60 + 5), '23:05');
    });

    test('"จาก N คืน" appears only when nights are missing', () {
      expect(build([night(0)], StoryView.week).missingNote, 'จาก 1 คืน');
      expect(
        build([
          for (var i = 0; i < 7; i++) night(i),
        ], StoryView.week).missingNote,
        isNull,
      );
      expect(build([night(0)], StoryView.night).missingNote, isNull);
    });

    test('day letters', () {
      expect(storyDayLetter(DateTime(2026, 11, 23)), 'จ');
      expect(storyDayLetter(DateTime(2026, 11, 26)), 'พฤ');
      expect(storyDayLetter(DateTime(2026, 11, 29)), 'อา');
    });
  });
}
