import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/birth_date.dart';

void main() {
  final now = DateTime(2026, 11, 26, 21, 30);

  DateTime? date(String text) => parseBirthDate(text, now: now).date;
  BirthDateProblem? problem(String text) =>
      parseBirthDate(text, now: now).problem;

  group('typing a birth date', () {
    test('reads day/month/year', () {
      expect(date('5/3/2008'), DateTime(2008, 3, 5));
      expect(date('05/03/2008'), DateTime(2008, 3, 5));
    });

    test('a year above 2400 is a Buddhist year', () {
      expect(date('5/3/2551'), DateTime(2008, 3, 5));
      expect(date('31/12/2549'), DateTime(2006, 12, 31));
    });

    test('also takes - . and spaces, or 8 digits from a number keypad', () {
      for (final text in [
        '5-3-2551',
        '5.3.2551',
        ' 5 / 3 / 2551 ',
        '5 3 2551',
        '05032551',
      ]) {
        expect(date(text), DateTime(2008, 3, 5), reason: text);
      }
    });

    test('empty means no birth date, not a mistake', () {
      final result = parseBirthDate('  ', now: now);
      expect(result.date, isNull);
      expect(result.problem, isNull);
    });

    test('needs a 4-digit year in the right shape', () {
      for (final text in ['5/3/51', '5/3', 'abc', '5032551', '1/2/3/2551']) {
        expect(problem(text), BirthDateProblem.format, reason: text);
      }
    });

    test('rejects days that do not exist', () {
      for (final text in ['31/4/2551', '0/1/2551', '1/13/2551', '29/2/2550']) {
        expect(problem(text), BirthDateProblem.noSuchDay, reason: text);
      }
    });

    test('knows leap years in both calendars', () {
      expect(date('29/2/2551'), DateTime(2008, 2, 29));
      expect(date('29/2/2000'), DateTime(2000, 2, 29));
      expect(problem('29/2/1900'), BirthDateProblem.noSuchDay);
    });

    test('rejects the future but takes today', () {
      expect(date('26/11/2026'), DateTime(2026, 11, 26));
      expect(problem('27/11/2026'), BirthDateProblem.future);
      expect(problem('1/1/2570'), BirthDateProblem.future);
    });

    test('rejects an age no one has', () {
      expect(problem('1/1/1899'), BirthDateProblem.tooLongAgo);
      // Between the two calendars: neither a sensible year.
      expect(problem('1/1/2400'), BirthDateProblem.future);
    });

    test('shows a date back in Buddhist years', () {
      expect(formatBirthDate(DateTime(2008, 3, 5)), '5/3/2551');
    });
  });

  group('age', () {
    test('goes up on the birthday, not before', () {
      final birth = DateTime(2008, 11, 27);
      expect(ageOn(birth, DateTime(2026, 11, 26, 23, 59)), 17);
      expect(ageOn(birth, DateTime(2026, 11, 27)), 18);
      expect(isAdultOn(birth, DateTime(2026, 11, 26)), isFalse);
      expect(isAdultOn(birth, DateTime(2026, 11, 27)), isTrue);
    });

    test('born on 29 February grows older on 1 March in other years', () {
      final birth = DateTime(2008, 2, 29);
      expect(ageOn(birth, DateTime(2026, 2, 28)), 17);
      expect(ageOn(birth, DateTime(2026, 3, 1)), 18);
      expect(ageOn(birth, DateTime(2028, 2, 29)), 20);
    });
  });

  group('who may see the AI assistant', () {
    AiAgeState state(DateTime? birth, {bool choseAdult = false}) =>
        aiAgeState(birthDate: birth, choseAdult: choseAdult, now: now);

    test('a birth date under 18 hides it, whatever was chosen', () {
      expect(state(DateTime(2010, 1, 1)), AiAgeState.hidden);
      expect(state(DateTime(2010, 1, 1), choseAdult: true), AiAgeState.hidden);
    });

    test('an adult birth date allows it', () {
      expect(state(DateTime(2000, 1, 1)), AiAgeState.adultByBirthDate);
    });

    test('with no birth date the age group decides, with a warning', () {
      expect(state(null), AiAgeState.blocked);
      expect(state(null, choseAdult: true), AiAgeState.adultUnconfirmed);
      expect(AiAgeState.blocked.mayUse, isFalse);
      expect(AiAgeState.hidden.mayUse, isFalse);
      expect(AiAgeState.adultUnconfirmed.mayUse, isTrue);
      expect(AiAgeState.adultByBirthDate.mayUse, isTrue);
    });
  });

  group('sleep target when the age group changes', () {
    test('follows the new age if the user never changed it', () {
      expect(
        targetAfterAgeChange(
          current: (min: 480, max: 600),
          wasAdult: false,
          isAdult: true,
        ),
        (min: 420, max: 540),
      );
    });

    test('is left alone if the user set their own', () {
      expect(
        targetAfterAgeChange(
          current: (min: 495, max: 600),
          wasAdult: false,
          isAdult: true,
        ),
        (min: 495, max: 600),
      );
    });

    test('stays the same within one age group', () {
      expect(
        targetAfterAgeChange(
          current: (min: 420, max: 540),
          wasAdult: true,
          isAdult: true,
        ),
        (min: 420, max: 540),
      );
    });
  });
}
