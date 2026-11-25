import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/economy_config.dart';
import 'package:glow/core/quests.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

QuestNightInput _night(
  DateTime wakeDate, {
  CheckInResult? result = CheckInResult.enough,
  bool onTime = true,
  bool usedShield = false,
}) => QuestNightInput(
  wakeDate: wakeDate,
  result: result,
  onTime: onTime,
  usedShield: usedShield,
);

void main() {
  group('dailyQuestCoins', () {
    test('ครบ + ตรงเวลา earns the base plus the bonus', () {
      final night = _night(d(2026, 11, 23));
      expect(
        dailyQuestCoins(night),
        EconomyConfig.dailyCompleteCoins + EconomyConfig.dailyOnTimeBonusCoins,
      );
    });

    test('ครบ but not ตรงเวลา earns only the base', () {
      final night = _night(d(2026, 11, 23), onTime: false);
      expect(dailyQuestCoins(night), EconomyConfig.dailyCompleteCoins);
    });

    test('notEnough earns nothing', () {
      final night = _night(d(2026, 11, 23), result: CheckInResult.notEnough);
      expect(dailyQuestCoins(night), 0);
    });

    test('a shield-protected night earns nothing, even if marked enough', () {
      final night = _night(d(2026, 11, 23), usedShield: true);
      expect(nightPassesDaily(night), isFalse);
      expect(dailyQuestCoins(night), 0);
    });
  });

  group('weekly ตรงเวลา 5/7 quest', () {
    test('a week passing exactly 5 of 7 nights completes the quest', () {
      final monday = d(2026, 11, 16);
      final week = [
        for (var i = 0; i < 7; i++)
          _night(monday.add(Duration(days: i)), onTime: i < 5),
      ];
      expect(weeklyOnTimeCount(week), 5);
      expect(weeklyOnTimeQuestComplete(week), isTrue);
    });

    test('a week passing only 4 of 7 nights does not complete the quest', () {
      final monday = d(2026, 11, 16);
      final week = [
        for (var i = 0; i < 7; i++)
          _night(monday.add(Duration(days: i)), onTime: i < 4),
      ];
      expect(weeklyOnTimeCount(week), 4);
      expect(weeklyOnTimeQuestComplete(week), isFalse);
    });

    test('a shield-covered night does not count toward the weekly 5/7', () {
      final monday = d(2026, 11, 16);
      // 5 nights look on-time, but one of those 5 used a shield, so it
      // should not count — leaving only 4 genuine passes.
      final week = [
        _night(monday, onTime: true, usedShield: true),
        _night(monday.add(const Duration(days: 1)), onTime: true),
        _night(monday.add(const Duration(days: 2)), onTime: true),
        _night(monday.add(const Duration(days: 3)), onTime: true),
        _night(monday.add(const Duration(days: 4)), onTime: true),
        _night(monday.add(const Duration(days: 5)), onTime: false),
        _night(monday.add(const Duration(days: 6)), onTime: false),
      ];
      expect(weeklyOnTimeCount(week), 4);
      expect(weeklyOnTimeQuestComplete(week), isFalse);
    });
  });

  group('exam period grouping', () {
    test('an exam period spanning two calendar weeks stays one period', () {
      // Sunday the 22nd and the following Wednesday the 26th are 4 days
      // apart and cross a Monday week boundary, but the gap is well
      // within the 7-day exam-mode window so they must group together.
      final examDates = [d(2026, 11, 22), d(2026, 11, 26)];
      final periods = groupExamPeriods(examDates);
      expect(periods, [examDates]);
    });

    test('exams more than 7 days apart form separate periods', () {
      final examDates = [d(2026, 11, 10), d(2026, 11, 25)];
      final periods = groupExamPeriods(examDates);
      expect(periods, [
        [d(2026, 11, 10)],
        [d(2026, 11, 25)],
      ]);
    });

    test('all pre-exam nights complete across a cross-week period grants the reward', () {
      final period = [d(2026, 11, 22), d(2026, 11, 26)];
      bool isComplete(DateTime wakeDate) => true;
      expect(
        examPeriodAllNightsComplete(
          examDatesInPeriod: period,
          isNightComplete: isComplete,
        ),
        isTrue,
      );
      expect(
        examPeriodCoins(examDatesInPeriod: period, isNightComplete: isComplete),
        2 * EconomyConfig.preExamNightCoins,
      );
    });

    test('one missed pre-exam night in the period breaks the all-complete reward', () {
      final period = [d(2026, 11, 22), d(2026, 11, 26)];
      bool isComplete(DateTime wakeDate) => wakeDate != d(2026, 11, 26);
      expect(
        examPeriodAllNightsComplete(
          examDatesInPeriod: period,
          isNightComplete: isComplete,
        ),
        isFalse,
      );
      expect(
        examPeriodCoins(examDatesInPeriod: period, isNightComplete: isComplete),
        EconomyConfig.preExamNightCoins,
      );
    });

    test('two exams on the same day share one pre-exam night', () {
      final period = [d(2026, 11, 22), d(2026, 11, 22)];
      var callCount = 0;
      bool isComplete(DateTime wakeDate) {
        callCount++;
        return true;
      }
      expect(
        examPeriodCoins(examDatesInPeriod: period, isNightComplete: isComplete),
        EconomyConfig.preExamNightCoins,
      );
      expect(callCount, 1);
    });
  });
}
