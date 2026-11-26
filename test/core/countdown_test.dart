import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ai_explain_guard.dart';
import 'package:glow/core/countdown.dart';

void main() {
  final now = DateTime(2026, 11, 26, 14);

  CountdownSource exam(String title, DateTime date, {DateTime? ends}) =>
      CountdownSource(
        kind: CountdownKind.exam,
        title: title,
        date: date,
        endsAt: ends,
      );
  CountdownSource due(String title, DateTime date) => CountdownSource(
    kind: CountdownKind.deadline,
    title: title,
    date: date,
  );

  test('counts calendar days, nearest first, exams before deadlines', () {
    final result = countdowns([
      due('b', DateTime(2026, 11, 29)),
      exam('c', DateTime(2026, 12, 1)),
      exam('a', DateTime(2026, 11, 29)),
    ], now: now);
    expect(result.map((c) => (c.title, c.daysLeft)), [
      ('a', 3),
      ('b', 3),
      ('c', 5),
    ]);
  });

  test('late at night, tomorrow is still one day away', () {
    final result = countdowns([
      exam('a', DateTime(2026, 11, 27)),
    ], now: DateTime(2026, 11, 26, 23, 59));
    expect(result.single.daysLeft, 1);
  });

  test('leaves out the past and what is more than two weeks off', () {
    final result = countdowns([
      exam('past', DateTime(2026, 11, 25)),
      due('edge', DateTime(2026, 12, 10)),
      exam('far', DateTime(2026, 12, 11)),
    ], now: now);
    expect(result.map((c) => c.title), ['edge']);
  });

  test("today's exam goes once it has ended", () {
    final today = DateTime(2026, 11, 26);
    expect(
      countdowns([
        exam('over', today, ends: DateTime(2026, 11, 26, 11)),
        exam('ahead', today, ends: DateTime(2026, 11, 26, 16)),
        exam('no time', today),
      ], now: now).map((c) => c.title),
      ['ahead', 'no time'],
    );
  });

  test('shows at most three', () {
    final result = countdowns([
      for (var i = 1; i <= 6; i++) due('$i', DateTime(2026, 11, 26 + i)),
    ], now: now);
    expect(result.map((c) => c.title), ['1', '2', '3']);
  });

  test('words', () {
    expect(daysLeftLabel(0), 'วันนี้');
    expect(daysLeftLabel(1), 'พรุ่งนี้');
    expect(daysLeftLabel(3), 'อีก 3 วัน');
    expect(
      sleepReminder(CountdownKind.exam, 3),
      'สอบอีก 3 วัน เริ่มนอนตามแผนไว้',
    );
  });

  test('no message ever suggests sleeping later or less', () {
    // Also words the AI guard doesn't need but these must never use.
    const extra = ['อ่านทั้งคืน', 'ทั้งคืน', 'ดึก', 'เลื่อน', 'ยอมนอน'];
    for (final kind in CountdownKind.values) {
      for (var days = 0; days <= countdownDays; days++) {
        final message = sleepReminder(kind, days);
        expect(hasForbiddenPhrase(message), isFalse, reason: message);
        expect(extra.any(message.contains), isFalse, reason: message);
        // Every one points back to sleeping on plan.
        expect(message, contains('นอน'));
        expect(message, contains('แผน'));
      }
    }
  });
}
