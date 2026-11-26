/// Reading a typed birth date, the age it gives, and what follows from the age
/// (CLAUDE.md sections 16 and 19). The age is only what the user typed; the
/// app has no way to check it.
library;

/// A year above this was typed in the Buddhist calendar.
const int _buddhistYearsAbove = 2400;
const int _buddhistOffset = 543;
const int _earliestBirthYear = 1900;
const int adultAge = 18;

enum BirthDateProblem {
  /// Not day/month/4-digit year.
  format,
  noSuchDay,
  future,
  tooLongAgo,
}

/// Both null means nothing was typed.
class BirthDateInput {
  final DateTime? date;
  final BirthDateProblem? problem;

  const BirthDateInput({this.date, this.problem});
}

BirthDateInput parseBirthDate(String text, {required DateTime now}) {
  const badFormat = BirthDateInput(problem: BirthDateProblem.format);
  final clean = text.trim();
  if (clean.isEmpty) return const BirthDateInput();

  // A number keypad has no "/", so 8 digits are day, month, year too.
  final match =
      RegExp(r'^(\d{2})(\d{2})(\d{4})$').firstMatch(clean) ??
      RegExp(
        r'^(\d{1,2})\s*[/.\- ]\s*(\d{1,2})\s*[/.\- ]\s*(\d{4})$',
      ).firstMatch(clean);
  if (match == null) return badFormat;

  final day = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  var year = int.parse(match[3]!);
  if (year > _buddhistYearsAbove) year -= _buddhistOffset;

  final date = DateTime(year, month, day);
  // DateTime rolls "31/4" over into May.
  if (date.year != year || date.month != month || date.day != day) {
    return const BirthDateInput(problem: BirthDateProblem.noSuchDay);
  }
  if (date.isAfter(DateTime(now.year, now.month, now.day))) {
    return const BirthDateInput(problem: BirthDateProblem.future);
  }
  if (year < _earliestBirthYear) {
    return const BirthDateInput(problem: BirthDateProblem.tooLongAgo);
  }
  return BirthDateInput(date: date);
}

/// Day/month/Buddhist year, the way it is typed.
String formatBirthDate(DateTime date) =>
    '${date.day}/${date.month}/${date.year + _buddhistOffset}';

int ageOn(DateTime birth, DateTime now) {
  final beforeBirthday =
      now.month < birth.month ||
      (now.month == birth.month && now.day < birth.day);
  return now.year - birth.year - (beforeBirthday ? 1 : 0);
}

bool isAdultOn(DateTime birth, DateTime now) => ageOn(birth, now) >= adultAge;

enum AiAgeState {
  /// The birth date is under 18: nothing about AI is shown.
  hidden,

  /// No birth date, and the age group is under 18.
  blocked,

  /// No birth date; the user chose 18 or over. Warn before switching AI on.
  adultUnconfirmed,
  adultByBirthDate;

  bool get mayUse =>
      this == AiAgeState.adultUnconfirmed ||
      this == AiAgeState.adultByBirthDate;
}

AiAgeState aiAgeState({
  required DateTime? birthDate,
  required bool choseAdult,
  required DateTime now,
}) {
  if (birthDate != null) {
    return isAdultOn(birthDate, now)
        ? AiAgeState.adultByBirthDate
        : AiAgeState.hidden;
  }
  return choseAdult ? AiAgeState.adultUnconfirmed : AiAgeState.blocked;
}

/// Hours of sleep to aim for, in minutes.
typedef SleepTarget = ({int min, int max});

/// The recommended target (CLAUDE.md section 3).
SleepTarget defaultSleepTarget({required bool isAdult}) =>
    isAdult ? (min: 7 * 60, max: 9 * 60) : (min: 8 * 60, max: 10 * 60);

/// A target the user changed themselves is never touched.
SleepTarget targetAfterAgeChange({
  required SleepTarget current,
  required bool wasAdult,
  required bool isAdult,
}) => current == defaultSleepTarget(isAdult: wasAdult)
    ? defaultSleepTarget(isAdult: isAdult)
    : current;
