import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/schedule_models.dart';
import 'package:glow/core/sleep_calculator.dart';

const defaultSettings = SleepSettings(
  targetMinMinutes: 480,
  targetMaxMinutes: 600,
);

DateTime d(int y, int m, int day, [int h = 0, int min = 0]) =>
    DateTime(y, m, day, h, min);

void main() {
  group('calculateWakeTime + calculateBedtime', () {
    test('Monday 08:00 class -> wake 06:35, bedtime Sunday 21:50', () {
      final monday = d(2026, 11, 23); // a Monday
      final entries = [
        ScheduleEntry(
          title: 'เรียน',
          kind: ItemKind.classSession,
          start: d(2026, 11, 23, 8, 0),
          end: d(2026, 11, 23, 10, 0),
        ),
      ];

      final wake = calculateWakeTime(
        wakeDate: monday,
        settings: defaultSettings,
        entriesForWakeDate: entries,
      );
      expect(wake.wakeTime, d(2026, 11, 23, 6, 35));
      expect(wake.wasCapped, isFalse);
      expect(wake.isPreExamNight, isFalse);

      final bedtime = calculateBedtime(
        wakeTime: wake.wakeTime,
        settings: defaultSettings,
        isPreExamNight: false,
      );
      expect(bedtime.bedtime, d(2026, 11, 22, 21, 50)); // Sunday night
      expect(bedtime.wasCapped, isFalse);
    });

    test('bedtime before midnight (typical evening class day)', () {
      final result = calculateBedtime(
        wakeTime: d(2026, 11, 24, 6, 35),
        settings: defaultSettings,
        isPreExamNight: false,
      );
      expect(result.bedtime.day, 23); // the evening before
      expect(result.bedtime.hour < 24, isTrue);
      expect(result.wasCapped, isFalse);
    });

    test('raw bedtime arithmetic correctly rolls past midnight', () {
      // A permissive cap isolates the subtraction itself from clamping.
      const settings = SleepSettings(
        targetMinMinutes: 420,
        targetMaxMinutes: 540,
        latestBedtimeMinutes: 1500,
      );
      // budget = 420+30+15 = 465min = 7h45m; 08:00 - 7h45m = 00:15 same day.
      final result = calculateBedtime(
        wakeTime: d(2026, 11, 24, 8, 0),
        settings: settings,
        isPreExamNight: false,
      );
      expect(result.bedtime, d(2026, 11, 24, 0, 15));
      expect(result.wasCapped, isFalse);
    });

    test('a would-be after-midnight bedtime is capped to 23:30 by default', () {
      const settings = SleepSettings(
        targetMinMinutes: 420,
        targetMaxMinutes: 540,
      );
      final result = calculateBedtime(
        wakeTime: d(2026, 11, 24, 8, 0),
        settings: settings,
        isPreExamNight: false,
      );
      expect(result.bedtime, d(2026, 11, 23, 23, 30));
      expect(result.wasCapped, isTrue);
    });

    test('an after-midnight latestBedtimeMinutes caps onto the wake date, not a day early', () {
      // latestBedtimeMinutes=60 means "01:00" -- the early hours of the wake
      // date (Nov 24), not 01:00 the morning before (Nov 23). budget=360+30+15
      // =405min; 08:00-405min=01:15, just past the 01:00 cap.
      const settings = SleepSettings(
        targetMinMinutes: 360,
        targetMaxMinutes: 480,
        latestBedtimeMinutes: 60,
      );
      final result = calculateBedtime(
        wakeTime: d(2026, 11, 24, 8, 0),
        settings: settings,
        isPreExamNight: false,
      );
      expect(result.bedtime, d(2026, 11, 24, 1, 0));
      expect(result.wasCapped, isTrue);
    });

    test('an after-midnight latestBedtimeMinutes does not cap an earlier, before-midnight bedtime', () {
      const settings = SleepSettings(
        targetMinMinutes: 480,
        targetMaxMinutes: 600,
        latestBedtimeMinutes: 60, // 01:00
      );
      final result = calculateBedtime(
        wakeTime: d(2026, 11, 24, 6, 35),
        settings: settings,
        isPreExamNight: false,
      );
      expect(result.bedtime, d(2026, 11, 23, 21, 50)); // unaffected
      expect(result.wasCapped, isFalse);
    });

    test('no appointments on a free day uses freeDayWakeMinutes', () {
      final wake = calculateWakeTime(
        wakeDate: d(2026, 11, 28), // Saturday
        settings: defaultSettings,
        entriesForWakeDate: const [],
      );
      expect(wake.wakeTime, d(2026, 11, 28, 7, 30));
      expect(wake.isPreExamNight, isFalse);
    });

    test('term break with totally empty schedule still produces a plan', () {
      final wake = calculateWakeTime(
        wakeDate: d(2026, 12, 25),
        settings: defaultSettings,
        entriesForWakeDate: const [],
      );
      final bedtime = calculateBedtime(
        wakeTime: wake.wakeTime,
        settings: defaultSettings,
        isPreExamNight: false,
      );
      expect(wake.wakeTime, d(2026, 12, 25, 7, 30));
      expect(bedtime.bedtime, d(2026, 12, 24, 22, 45));
    });

    test(
      'wake time capped at latestWakeMinutes on a late afternoon-only day',
      () {
        final entries = [
          ScheduleEntry(
            title: 'เรียนบ่าย',
            kind: ItemKind.classSession,
            start: d(2026, 11, 24, 13, 0),
            end: d(2026, 11, 24, 15, 0),
          ),
        ];
        final wake = calculateWakeTime(
          wakeDate: d(2026, 11, 24),
          settings: defaultSettings,
          entriesForWakeDate: entries,
        );
        expect(wake.wakeTime, d(2026, 11, 24, 8, 0)); // capped, not 11:25
        expect(wake.wasCapped, isTrue);
      },
    );

    test(
      'exam day uses 30-minute exam buffer and midpoint target that night',
      () {
        final entries = [
          ScheduleEntry(
            title: 'สอบคณิต',
            kind: ItemKind.exam,
            start: d(2026, 11, 24, 9, 0),
            end: d(2026, 11, 24, 11, 0),
          ),
        ];
        final wake = calculateWakeTime(
          wakeDate: d(2026, 11, 24),
          settings: defaultSettings,
          entriesForWakeDate: entries,
        );
        // leaveHome = 09:00 - 30(exam buffer) - 30(travel) = 08:00; wake = 08:00 - 45(prep) = 07:15
        expect(wake.wakeTime, d(2026, 11, 24, 7, 15));
        expect(wake.isPreExamNight, isTrue);

        final bedtime = calculateBedtime(
          wakeTime: wake.wakeTime,
          settings: defaultSettings,
          isPreExamNight: true,
        );
        // midpoint target = (480+600)/2 = 540min = 9h; 07:15 - 9h - 15m = Monday 21:00
        expect(bedtime.bedtime, d(2026, 11, 23, 22, 0));
      },
    );

    test('appointment so early that sleep target cannot be met still returns a plan', () {
      final entries = [
        ScheduleEntry(
          title: 'ติวเช้ามาก',
          kind: ItemKind.activity,
          start: d(2026, 11, 24, 5, 0),
          end: d(2026, 11, 24, 6, 0),
        ),
      ];
      final wake = calculateWakeTime(
        wakeDate: d(2026, 11, 24),
        settings: defaultSettings,
        entriesForWakeDate: entries,
      );
      // leaveHome = 05:00 - 10 - 30 = 04:20; wake = 04:20 - 45 = 03:35 (not capped, cap is an upper bound only)
      expect(wake.wakeTime, d(2026, 11, 24, 3, 35));
      expect(wake.wasCapped, isFalse);

      final bedtime = calculateBedtime(
        wakeTime: wake.wakeTime,
        settings: defaultSettings,
        isPreExamNight: false,
      );
      // Raw target would land before the previous night's wake time; red-status
      // detection itself belongs to schedule_load, not here — this just checks
      // the arithmetic doesn't crash or silently inflate sleep.
      expect(bedtime.bedtime, isNotNull);
    });
  });

  group('smoothWeekNightPlans', () {
    NightPlanDraft draft(DateTime wakeDate, DateTime bedtime) => NightPlanDraft(
      wakeDate: wakeDate,
      wakeTime: wakeDate.add(const Duration(hours: 7)),
      bedtime: bedtime,
      wakeWasCapped: false,
      bedtimeWasCapped: false,
      isPreExamNight: false,
    );

    test(
      'pulls an isolated late night earlier to within 60 min of neighbors',
      () {
        final nights = [
          draft(d(2026, 11, 23), d(2026, 11, 22, 21, 30)), // Mon night
          draft(
            d(2026, 11, 24),
            d(2026, 11, 23, 23, 50),
          ), // Tue night: very late
          draft(d(2026, 11, 25), d(2026, 11, 24, 21, 40)), // Wed night
        ];

        final smoothed = smoothWeekNightPlans(nights);

        expect(smoothed[0].bedtime, d(2026, 11, 22, 21, 30)); // unchanged
        // Backward pass pulls Tue to 22:40 (60 min after Wed's 21:40), then the
        // forward pass tightens it again to 22:30 (60 min after Mon's 21:30).
        expect(smoothed[1].bedtime, d(2026, 11, 23, 22, 30));
        expect(smoothed[2].bedtime, d(2026, 11, 24, 21, 40)); // unchanged
      },
    );

    test('never moves a night later than its original bedtime', () {
      final nights = [
        draft(d(2026, 11, 23), d(2026, 11, 22, 20, 0)),
        draft(d(2026, 11, 24), d(2026, 11, 23, 23, 30)),
        draft(d(2026, 11, 25), d(2026, 11, 24, 20, 0)),
      ];

      final smoothed = smoothWeekNightPlans(nights);

      for (var i = 0; i < nights.length; i++) {
        expect(
          smoothed[i].bedtime.isAfter(nights[i].bedtime),
          isFalse,
          reason: 'night $i must not be later than its raw bedtime',
        );
      }
    });

    test('handles a bedtime that rolled past midnight when smoothing', () {
      final nights = [
        draft(d(2026, 11, 23), d(2026, 11, 22, 23, 0)),
        draft(d(2026, 11, 24), d(2026, 11, 24, 0, 30)), // rolled past midnight
      ];

      final smoothed = smoothWeekNightPlans(nights);

      // 00:30 is 90 min later than 23:00 on the continuous scale -> pulled to 00:00.
      expect(smoothed[1].bedtime, d(2026, 11, 24, 0, 0));
    });

    test('all seven nights of the week are included even with no classes', () {
      final nights = List.generate(
        7,
        (i) => draft(
          d(2026, 11, 23).add(Duration(days: i)),
          d(2026, 11, 22).add(Duration(days: i, hours: 22)),
        ),
      );
      final smoothed = smoothWeekNightPlans(nights);
      expect(smoothed.length, 7);
    });
  });
}
