import 'check_in.dart';
import 'economy_config.dart';

/// One night's inputs for quest evaluation, per CLAUDE.md section 8.
class QuestNightInput {
  final DateTime wakeDate;
  final CheckInResult? result;
  final bool onTime;
  final bool usedShield;

  const QuestNightInput({
    required this.wakeDate,
    required this.result,
    required this.onTime,
    required this.usedShield,
  });
}

/// A night "passes" a quest only if it was ครบ and didn't need a shield to
/// get there (section 7: "คืนที่ใช้โล่ไม่นับเป็นคืนที่ผ่านเควส").
bool nightPassesDaily(QuestNightInput night) =>
    night.result == CheckInResult.enough && !night.usedShield;

bool nightPassesOnTime(QuestNightInput night) =>
    nightPassesDaily(night) && night.onTime;

/// Coins for the daily "นอนครบ" quest plus its "ตรงเวลา" bonus, for one
/// night (section 8).
int dailyQuestCoins(QuestNightInput night) {
  if (!nightPassesDaily(night)) return 0;
  return EconomyConfig.dailyCompleteCoins +
      (night.onTime ? EconomyConfig.dailyOnTimeBonusCoins : 0);
}

/// How many nights in [weekNights] (expected: the 7 nights Mon..Sun of one
/// calendar week) pass the on-time bar for the weekly "ตรงเวลา 5 ใน 7"
/// quest.
int weeklyOnTimeCount(List<QuestNightInput> weekNights) =>
    weekNights.where(nightPassesOnTime).length;

const int weeklyOnTimeQuestTarget = 5;

bool weeklyOnTimeQuestComplete(List<QuestNightInput> weekNights) =>
    weeklyOnTimeCount(weekNights) >= weeklyOnTimeQuestTarget;

/// Groups sorted, deduplicated exam dates into periods — runs where every
/// exam is within [maxGapDays] of the previous one, mirroring exam mode's
/// own "opens when an exam is within 7 days, closes after the last" rule
/// (section 4) so "ครบทุกคืนก่อนสอบ" spans a whole exam stretch even if it
/// crosses a calendar-week boundary.
List<List<DateTime>> groupExamPeriods(
  List<DateTime> sortedExamDates, {
  int maxGapDays = 7,
}) {
  if (sortedExamDates.isEmpty) return [];
  final periods = <List<DateTime>>[
    [sortedExamDates.first],
  ];
  for (var i = 1; i < sortedExamDates.length; i++) {
    final gap = sortedExamDates[i].difference(sortedExamDates[i - 1]).inDays;
    if (gap <= maxGapDays) {
      periods.last.add(sortedExamDates[i]);
    } else {
      periods.add([sortedExamDates[i]]);
    }
  }
  return periods;
}

/// Whether every pre-exam night in one exam period (section 8: the night
/// before each exam date, deduplicated — two exams on the same day share
/// one pre-exam night) was ครบ.
bool examPeriodAllNightsComplete({
  required List<DateTime> examDatesInPeriod,
  required bool Function(DateTime wakeDate) isNightComplete,
}) {
  final preExamWakeDates = examDatesInPeriod
      .map((e) => DateTime(e.year, e.month, e.day))
      .toSet();
  return preExamWakeDates.every(isNightComplete);
}

/// Coins for the "สัปดาห์สอบ: คืนก่อนสอบ" quest — per complete pre-exam
/// night in the period, deduplicated the same way.
int examPeriodCoins({
  required List<DateTime> examDatesInPeriod,
  required bool Function(DateTime wakeDate) isNightComplete,
}) {
  final preExamWakeDates = examDatesInPeriod
      .map((e) => DateTime(e.year, e.month, e.day))
      .toSet();
  final completeCount = preExamWakeDates.where(isNightComplete).length;
  return completeCount * EconomyConfig.preExamNightCoins;
}
