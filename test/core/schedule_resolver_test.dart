import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/schedule_models.dart';
import 'package:glow/core/schedule_resolver.dart';

void main() {
  group('resolveScheduleForDate', () {
    test('weekly class only appears within the term range', () {
      final weekly = [
        const WeeklyEntry(
          title: 'เรียน',
          dayOfWeek: DateTime.monday,
          startMinutes: 8 * 60,
          endMinutes: 10 * 60,
          kind: ItemKind.classSession,
        ),
      ];

      final beforeTerm = resolveScheduleForDate(
        date: DateTime(2026, 11, 9), // a Monday before term start
        weeklyEntries: weekly,
        oneTimeEntries: const [],
        termStart: DateTime(2026, 11, 16),
        termEnd: DateTime(2026, 12, 31),
      );
      expect(beforeTerm, isEmpty);

      final duringTerm = resolveScheduleForDate(
        date: DateTime(2026, 11, 23),
        weeklyEntries: weekly,
        oneTimeEntries: const [],
        termStart: DateTime(2026, 11, 16),
        termEnd: DateTime(2026, 12, 31),
      );
      expect(duringTerm, hasLength(1));
    });

    test('holiday cancels weekly class sessions that day', () {
      final weekly = [
        const WeeklyEntry(
          title: 'เรียน',
          dayOfWeek: DateTime.monday,
          startMinutes: 8 * 60,
          endMinutes: 10 * 60,
          kind: ItemKind.classSession,
        ),
      ];
      final oneTime = [
        OneTimeEntry(
          title: 'วันหยุด',
          date: DateTime(2026, 11, 23),
          kind: ItemKind.holiday,
        ),
      ];

      final result = resolveScheduleForDate(
        date: DateTime(2026, 11, 23),
        weeklyEntries: weekly,
        oneTimeEntries: oneTime,
      );
      expect(result, isEmpty);
    });

    test('holiday does not cancel a weekly activity, only class sessions', () {
      final weekly = [
        const WeeklyEntry(
          title: 'ชมรม',
          dayOfWeek: DateTime.monday,
          startMinutes: 16 * 60,
          endMinutes: 17 * 60,
          kind: ItemKind.activity,
        ),
      ];
      final oneTime = [
        OneTimeEntry(
          title: 'วันหยุด',
          date: DateTime(2026, 11, 23),
          kind: ItemKind.holiday,
        ),
      ];

      final result = resolveScheduleForDate(
        date: DateTime(2026, 11, 23),
        weeklyEntries: weekly,
        oneTimeEntries: oneTime,
      );
      expect(result, hasLength(1));
      expect(result.first.title, 'ชมรม');
    });

    test('an exam overlapping a normal class slot wins over the class', () {
      final weekly = [
        const WeeklyEntry(
          title: 'เรียน',
          dayOfWeek: DateTime.monday,
          startMinutes: 8 * 60,
          endMinutes: 10 * 60,
          kind: ItemKind.classSession,
        ),
      ];
      final oneTime = [
        OneTimeEntry(
          title: 'สอบคณิต',
          date: DateTime(2026, 11, 23),
          startMinutes: 9 * 60,
          endMinutes: 11 * 60,
          kind: ItemKind.exam,
        ),
      ];

      final result = resolveScheduleForDate(
        date: DateTime(2026, 11, 23),
        weeklyEntries: weekly,
        oneTimeEntries: oneTime,
      );
      expect(result, hasLength(1));
      expect(result.first.title, 'สอบคณิต');
      expect(result.first.kind, ItemKind.exam);
    });

    test('a non-overlapping one-time item coexists with weekly classes', () {
      final weekly = [
        const WeeklyEntry(
          title: 'เรียน',
          dayOfWeek: DateTime.monday,
          startMinutes: 8 * 60,
          endMinutes: 10 * 60,
          kind: ItemKind.classSession,
        ),
      ];
      final oneTime = [
        OneTimeEntry(
          title: 'นัดหมอ',
          date: DateTime(2026, 11, 23),
          startMinutes: 14 * 60,
          endMinutes: 15 * 60,
          kind: ItemKind.activity,
        ),
      ];

      final result = resolveScheduleForDate(
        date: DateTime(2026, 11, 23),
        weeklyEntries: weekly,
        oneTimeEntries: oneTime,
      );
      expect(result, hasLength(2));
    });
  });
}
