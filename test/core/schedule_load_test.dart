import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/schedule_load.dart';
import 'package:glow/core/schedule_models.dart';
import 'package:glow/core/sleep_calculator.dart';

const settings = SleepSettings(targetMinMinutes: 480, targetMaxMinutes: 600);

DateTime d(int y, int m, int day, [int h = 0, int min = 0]) =>
    DateTime(y, m, day, h, min);

void main() {
  group('classifyEveningLoad', () {
    test('no appointments that evening is always normal', () {
      final result = classifyEveningLoad(
        entriesForEveningDate: const [],
        plannedBedtime: d(2026, 11, 23, 21, 50),
        plannedWakeTime: d(2026, 11, 24, 6, 35),
        isPreExamNight: false,
        settings: settings,
      );
      expect(result.level, EveningLoadLevel.normal);
      expect(result.arriveHomeAt, isNull);
    });

    test('plenty of free evening is normal', () {
      final entries = [
        ScheduleEntry(
          title: 'เรียน',
          kind: ItemKind.classSession,
          start: d(2026, 11, 23, 8, 0),
          end: d(2026, 11, 23, 16, 0),
        ),
      ];
      // arrive home 16:30, notify at 20:50 (21:50 - 60) -> free 4h20m.
      final result = classifyEveningLoad(
        entriesForEveningDate: entries,
        plannedBedtime: d(2026, 11, 23, 21, 50),
        plannedWakeTime: d(2026, 11, 24, 6, 35),
        isPreExamNight: false,
        settings: settings,
      );
      expect(result.level, EveningLoadLevel.normal);
      expect(result.arriveHomeAt, d(2026, 11, 23, 16, 30));
    });

    test('tight evening under 120 minutes is yellow', () {
      final entries = [
        ScheduleEntry(
          title: 'ชมรม',
          kind: ItemKind.activity,
          start: d(2026, 11, 23, 18, 0),
          end: d(2026, 11, 23, 20, 0),
        ),
      ];
      // arrive home 20:30, notify at 20:50 -> free 20 min.
      final result = classifyEveningLoad(
        entriesForEveningDate: entries,
        plannedBedtime: d(2026, 11, 23, 21, 50),
        plannedWakeTime: d(2026, 11, 24, 6, 35),
        isPreExamNight: false,
        settings: settings,
      );
      expect(result.level, EveningLoadLevel.yellow);
    });

    test('exam mode raises the comfortable threshold to 180 minutes', () {
      final entries = [
        ScheduleEntry(
          title: 'ชมรม',
          kind: ItemKind.activity,
          start: d(2026, 11, 23, 16, 0),
          end: d(2026, 11, 23, 18, 0),
        ),
      ];
      // arrive home 18:30, pre-exam notify at 20:20 (21:50 - 90) -> free 1h50m (< 180).
      final result = classifyEveningLoad(
        entriesForEveningDate: entries,
        plannedBedtime: d(2026, 11, 23, 21, 50),
        plannedWakeTime: d(2026, 11, 24, 6, 35),
        isPreExamNight: true,
        settings: settings,
      );
      expect(result.level, EveningLoadLevel.yellow);
    });

    test('arriving home after planned bedtime is red', () {
      final entries = [
        ScheduleEntry(
          title: 'กิจกรรม',
          kind: ItemKind.activity,
          start: d(2026, 11, 23, 20, 0),
          end: d(2026, 11, 23, 22, 0),
        ),
      ];
      // arrive home 22:30, after the 21:50 planned bedtime.
      final result = classifyEveningLoad(
        entriesForEveningDate: entries,
        plannedBedtime: d(2026, 11, 23, 21, 50),
        plannedWakeTime: d(2026, 11, 24, 6, 35),
        isPreExamNight: false,
        settings: settings,
      );
      expect(result.level, EveningLoadLevel.red);
    });

    test('home in time for bedtime but not enough hours left is red', () {
      final entries = [
        ScheduleEntry(
          title: 'กิจกรรม',
          kind: ItemKind.activity,
          start: d(2026, 11, 23, 19, 0),
          end: d(2026, 11, 23, 21, 0),
        ),
      ];
      // arrive home 21:30 (before 21:50 bedtime), but wake 06:35 is only
      // 9h05m later - still >= min+15 here, so make wake earlier instead to
      // force a genuine shortfall below targetMin(480)+15 = 495 min.
      final result = classifyEveningLoad(
        entriesForEveningDate: entries,
        plannedBedtime: d(2026, 11, 23, 21, 50),
        plannedWakeTime: d(2026, 11, 24, 5, 0), // only 7h30m after arriving home
        isPreExamNight: false,
        settings: settings,
      );
      expect(result.level, EveningLoadLevel.red);
    });
  });

  group('exam mode', () {
    final today = DateTime(2026, 11, 25);

    test('is on from 7 days before an exam through the exam day', () {
      for (final days in [0, 1, 7]) {
        expect(
          isExamModeOn(
            date: today,
            examDates: [today.add(Duration(days: days))],
          ),
          isTrue,
          reason: '$days days ahead',
        );
      }
    });

    test('is off for far-off and past exams', () {
      expect(
        isExamModeOn(
          date: today,
          examDates: [DateTime(2026, 12, 3), DateTime(2026, 11, 24)],
        ),
        isFalse,
      );
    });
  });
}
