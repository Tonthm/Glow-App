import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/economy_config.dart';
import 'package:glow/core/quests.dart';
import 'package:glow/core/schedule_load.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

QuestNightInput _night(
  DateTime wakeDate, {
  CheckInResult? result = CheckInResult.enough,
  bool onTime = true,
  bool usedShield = false,
  QuestMode mode = QuestMode.normal,
}) => QuestNightInput(
  mode: mode,
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
      expect(nightPasses(night), isFalse);
      expect(dailyQuestCoins(night), 0);
    });
  });

  group('weekly 5/7 quest', () {
    test('a week passing exactly 5 of 7 nights completes the quest', () {
      final monday = d(2026, 11, 16);
      final week = [
        for (var i = 0; i < 7; i++)
          _night(monday.add(Duration(days: i)), onTime: i < 5),
      ];
      expect(weeklyPassCount(week), 5);
      expect(weeklyQuestComplete(week), isTrue);
    });

    test('a week passing only 4 of 7 nights does not complete the quest', () {
      final monday = d(2026, 11, 16);
      final week = [
        for (var i = 0; i < 7; i++)
          _night(monday.add(Duration(days: i)), onTime: i < 4),
      ];
      expect(weeklyPassCount(week), 4);
      expect(weeklyQuestComplete(week), isFalse);
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
      expect(weeklyPassCount(week), 4);
      expect(weeklyQuestComplete(week), isFalse);
    });
  });

  group('quest mode', () {
    test('follows the evening load', () {
      QuestMode mode(EveningLoadLevel load, {bool tired = false}) =>
          questModeFor(load: load, lowEnergy: tired);
      expect(mode(EveningLoadLevel.normal), QuestMode.normal);
      expect(mode(EveningLoadLevel.yellow), QuestMode.light);
      expect(mode(EveningLoadLevel.red), QuestMode.minimum);
      expect(mode(EveningLoadLevel.normal, tired: true), QuestMode.minimum);
    });

    test('minimum mode only asks to sleep on plan', () {
      final night = _night(
        d(2026, 11, 23),
        result: CheckInResult.notEnough,
        mode: QuestMode.minimum,
      );
      expect(nightPasses(night), isTrue);
      expect(dailyQuestCoins(night), EconomyConfig.sleepOnPlanCoins);
    });

    test('minimum mode off plan earns nothing, even with enough sleep', () {
      final night = _night(
        d(2026, 11, 23),
        onTime: false,
        mode: QuestMode.minimum,
      );
      expect(nightPasses(night), isFalse);
      expect(dailyQuestCoins(night), 0);
    });

    test('light mode keeps the normal sleep quests', () {
      final night = _night(d(2026, 11, 23), mode: QuestMode.light);
      expect(dailyQuestCoins(night), 15);
    });

    test('a normal night that was not enough does not pass', () {
      final night = _night(d(2026, 11, 23), result: CheckInResult.notEnough);
      expect(nightPasses(night), isFalse);
    });

    test('no check-in never passes, in any mode', () {
      for (final mode in QuestMode.values) {
        final night = _night(d(2026, 11, 23), result: null, mode: mode);
        expect(nightPasses(night), isFalse);
        expect(dailyQuestCoins(night), 0);
      }
    });

    test('two red nights can still pass 5 of 7', () {
      final monday = d(2026, 11, 16);
      final week = [
        for (var i = 0; i < 7; i++)
          i < 2
              ? _night(
                  monday.add(Duration(days: i)),
                  result: CheckInResult.notEnough,
                  mode: QuestMode.minimum,
                )
              : _night(monday.add(Duration(days: i)), onTime: i < 5),
      ];
      expect(weeklyPassCount(week), 5);
      expect(weeklyQuestComplete(week), isTrue);
    });

    test('the stretching quest does not exist in minimum mode', () {
      expect(routineQuestCoins(QuestMode.normal), 5);
      expect(routineQuestCoins(QuestMode.light), 5);
      expect(routineQuestCoins(QuestMode.minimum), 0);
    });
  });

  group('วันนี้หมดแรง', () {
    final lockTime = DateTime(2026, 11, 23, 20, 50);

    test('can be switched before the plan locks', () {
      expect(
        canChangeLowEnergy(
          now: DateTime(2026, 11, 23, 20, 49),
          lockTime: lockTime,
          usedOnOtherNightsThisWeek: 0,
        ),
        isTrue,
      );
    });

    test('cannot be switched once the plan locks', () {
      expect(
        canChangeLowEnergy(
          now: lockTime,
          lockTime: lockTime,
          usedOnOtherNightsThisWeek: 0,
        ),
        isFalse,
      );
    });

    test('is limited to one night a week; cancelling gives it back', () {
      bool can(int used) => canChangeLowEnergy(
        now: DateTime(2026, 11, 24, 12),
        lockTime: DateTime(2026, 11, 24, 20, 50),
        usedOnOtherNightsThisWeek: used,
      );
      expect(can(1), isFalse);
      // After cancelling on the other night nothing is used again.
      expect(can(0), isTrue);
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

    test(
      'one missed pre-exam night in the period breaks the all-complete reward',
      () {
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
          examPeriodCoins(
            examDatesInPeriod: period,
            isNightComplete: isComplete,
          ),
          EconomyConfig.preExamNightCoins,
        );
      },
    );

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
