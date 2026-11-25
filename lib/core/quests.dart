import 'check_in.dart';
import 'economy_config.dart';
import 'schedule_load.dart';

/// A night's quest mode (CLAUDE.md section 8). Stored by index.
enum QuestMode { normal, light, minimum }

/// Red nights from the schedule, or "วันนี้หมดแรง", cut the night down to one
/// quest; a busy (yellow) evening only shortens the stretching.
QuestMode questModeFor({
  required EveningLoadLevel load,
  required bool lowEnergy,
}) {
  if (lowEnergy || load == EveningLoadLevel.red) return QuestMode.minimum;
  return load == EveningLoadLevel.yellow ? QuestMode.light : QuestMode.normal;
}

/// One night's inputs for quest evaluation.
class QuestNightInput {
  final DateTime wakeDate;

  /// Null when there was no check-in.
  final CheckInResult? result;

  /// Pressed "เข้านอนแล้ว" and lights off within 45 minutes of the plan. In
  /// minimum mode this is the whole quest, "หลับตามแผน".
  final bool onTime;
  final bool usedShield;
  final QuestMode mode;

  const QuestNightInput({
    required this.wakeDate,
    required this.result,
    required this.onTime,
    required this.usedShield,
    this.mode = QuestMode.normal,
  });
}

/// "คืนที่ผ่าน": ครบ and on time, or in minimum mode just on time. A night
/// that needed a shield never passes.
bool nightPasses(QuestNightInput night) {
  if (night.usedShield || night.result == null || !night.onTime) return false;
  return night.mode == QuestMode.minimum ||
      night.result == CheckInResult.enough;
}

/// Coins for one night's sleep quests.
int dailyQuestCoins(QuestNightInput night) {
  if (night.usedShield || night.result == null) return 0;
  if (night.mode == QuestMode.minimum) {
    return night.onTime ? EconomyConfig.sleepOnPlanCoins : 0;
  }
  if (night.result != CheckInResult.enough) return 0;
  return EconomyConfig.dailyCompleteCoins +
      (night.onTime ? EconomyConfig.dailyOnTimeBonusCoins : 0);
}

/// The stretching quest exists in normal and light mode only. It has no
/// effect on fire or on passing nights.
int routineQuestCoins(QuestMode mode) =>
    mode == QuestMode.minimum ? 0 : EconomyConfig.routineCoins;

/// How many of [weekNights] (one Monday-to-Sunday week) passed.
int weeklyPassCount(List<QuestNightInput> weekNights) =>
    weekNights.where(nightPasses).length;

const int weeklyQuestTarget = 5;

bool weeklyQuestComplete(List<QuestNightInput> weekNights) =>
    weeklyPassCount(weekNights) >= weeklyQuestTarget;

/// "วันนี้หมดแรง": once per Monday-to-Sunday week.
const int lowEnergyPerWeek = 1;

/// Can be switched on or off only before the night's plan locks, and only if
/// this week's use isn't already spent on another night.
bool canChangeLowEnergy({
  required DateTime now,
  required DateTime lockTime,
  required int usedOnOtherNightsThisWeek,
}) => now.isBefore(lockTime) && usedOnOtherNightsThisWeek < lowEnergyPerWeek;

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
