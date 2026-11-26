import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/first_class.dart';
import 'package:glow/core/schedule_models.dart';
import 'package:glow/core/schedule_resolver.dart';
import 'package:glow/core/sleep_calculator.dart';

const _under18 = SleepSettings(targetMinMinutes: 480, targetMaxMinutes: 600);

WeeklyEntry _entry(ItemKind kind) => WeeklyEntry(
  title: 'x',
  dayOfWeek: DateTime.wednesday,
  startMinutes: 10 * 60,
  endMinutes: 11 * 60,
  kind: kind,
);

void main() {
  test('stands in on weekdays while there are no classes', () {
    final entries = withEarliestClass(const [], 8 * 60);
    expect(entries.map((e) => e.dayOfWeek), [1, 2, 3, 4, 5]);
    expect(entries.every((e) => e.startMinutes == 480), isTrue);
    expect(entries.every((e) => e.kind == ItemKind.classSession), isTrue);
  });

  test('gives the same night as the real class would (section 3)', () {
    final monday = DateTime(2026, 11, 30);
    final plan = calculateNightPlanDraft(
      wakeDate: monday,
      settings: _under18,
      entriesForWakeDate: resolveScheduleForDate(
        date: monday,
        weeklyEntries: withEarliestClass(const [], 8 * 60),
        oneTimeEntries: const [],
      ),
    );
    expect(plan.wakeTime, DateTime(2026, 11, 30, 6, 35));
    expect(plan.bedtime, DateTime(2026, 11, 29, 21, 50));
  });

  test('stops as soon as any real class is entered', () {
    final real = [_entry(ItemKind.classSession)];
    expect(withEarliestClass(real, 8 * 60), same(real));
  });

  test('a weekly activity is not a class, so it still stands in', () {
    final entries = withEarliestClass([_entry(ItemKind.activity)], 8 * 60);
    expect(entries, hasLength(6));
  });

  test('does nothing if no time was given', () {
    expect(withEarliestClass(const [], null), isEmpty);
  });

  test('a holiday cancels it like any class', () {
    final monday = DateTime(2026, 11, 30);
    final entries = resolveScheduleForDate(
      date: monday,
      weeklyEntries: withEarliestClass(const [], 8 * 60),
      oneTimeEntries: [
        OneTimeEntry(title: 'หยุด', date: monday, kind: ItemKind.holiday),
      ],
    );
    expect(entries, isEmpty);
  });
}
