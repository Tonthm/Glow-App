import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/ics_builder.dart';
import 'package:glow/core/web_reminders.dart';

/// Monday's night: asleep Sunday 21:50, awake Monday 06:35. UTC inputs keep
/// the expected text the same on any machine.
final night = IcsNight(
  wakeDate: DateTime(2026, 11, 23),
  notifyTime: DateTime.utc(2026, 11, 22, 20, 50),
  bedtime: DateTime.utc(2026, 11, 22, 21, 50),
  wakeTime: DateTime.utc(2026, 11, 23, 6, 35),
);

/// A bedtime after midnight.
final lateNight = IcsNight(
  wakeDate: DateTime(2026, 11, 24),
  notifyTime: DateTime.utc(2026, 11, 23, 23, 30),
  bedtime: DateTime.utc(2026, 11, 24, 0, 30),
  wakeTime: DateTime.utc(2026, 11, 24, 9),
);

final now = DateTime.utc(2026, 11, 22, 8);
const all = {...IcsEventKind.values};

IcsCalendar build({
  List<IcsNight>? nights,
  Set<IcsEventKind> enabled = all,
  Map<String, int> sequences = const {},
}) => buildIcs(
  nights: nights ?? [night],
  enabled: enabled,
  sequences: sequences,
  now: now,
);

String unfold(String text) => text.replaceAll('\r\n ', '');

int count(String text, String part) => part.allMatches(text).length;

void main() {
  test('has balanced blocks and only CRLF line breaks', () {
    final text = build().text;
    expect(text, startsWith('BEGIN:VCALENDAR\r\n'));
    expect(text, endsWith('END:VCALENDAR\r\n'));
    expect(count(text, 'BEGIN:VEVENT'), 3);
    expect(count(text, 'END:VEVENT'), 3);
    expect(count(text, 'BEGIN:VALARM'), 3);
    expect(count(text, 'END:VALARM'), 3);
    expect(count(text, 'TRIGGER:PT0M'), 3);
    expect(text.replaceAll('\r\n', ''), isNot(contains('\n')));
    expect(text.replaceAll('\r\n', ''), isNot(contains('\r')));
  });

  test('escapes commas, semicolons, backslashes, and line breaks', () {
    expect(escapeIcsText('a,b;c\\d\ne\r\nf'), r'a\,b\;c\\d\ne\nf');
  });

  test('folds Thai text without cutting a character', () {
    final line = 'DESCRIPTION:${'เข้านอนได้เลยนะ' * 12}';
    final folded = foldIcsLine(line);
    for (final piece in folded.split('\r\n')) {
      final bytes = utf8.encode(piece);
      expect(bytes.length, lessThanOrEqualTo(75));
      // Throws if a character was split between lines.
      expect(utf8.decode(bytes), piece);
    }
    expect(unfold(folded), line);
  });

  test('every line of a whole calendar fits in 75 bytes', () {
    for (final line in build().text.split('\r\n')) {
      expect(utf8.encode(line).length, lessThanOrEqualTo(75));
    }
  });

  test('keeps ids and raises the sequence when built again', () {
    final first = build();
    final second = build(sequences: first.sequences);
    expect(
      [for (final e in second.events) e.uid],
      [for (final e in first.events) e.uid],
    );
    expect(first.sequences.values.toSet(), {0});
    expect(second.sequences.values.toSet(), {1});
    expect(count(second.text, 'SEQUENCE:1\r\n'), 3);
  });

  test('gives the same text for the same input', () {
    expect(build().text, build().text);
  });

  test('writes UTC times, 5 minutes long', () {
    final text = unfold(build(enabled: {IcsEventKind.bedtime}).text);
    expect(text, contains('DTSTART:20261122T215000Z\r\n'));
    expect(text, contains('DTEND:20261122T215500Z\r\n'));
  });

  test('converts local times to UTC', () {
    final local = DateTime(2026, 11, 22, 21, 50);
    final utc = local.toUtc();
    expect(icsUtc(local), icsUtc(utc));
    expect(icsUtc(utc), endsWith('Z'));
  });

  test('puts check-in 30 minutes after waking', () {
    final events = build(enabled: {IcsEventKind.checkIn}).events;
    expect(events.single.start, DateTime.utc(2026, 11, 23, 7, 5));
  });

  test('a night after midnight keeps its wake date in the id', () {
    final events = build(
      nights: [lateNight],
      enabled: {IcsEventKind.bedtime},
    ).events;
    expect(events.single.uid, 'glow-20261124-bedtime@glow.app');
    expect(events.single.start, DateTime.utc(2026, 11, 24, 0, 30));
  });

  test('leaves out reminders that are off', () {
    final text = unfold(build(enabled: {IcsEventKind.bedtime}).text);
    expect(count(text, 'BEGIN:VEVENT'), 1);
    expect(text, isNot(contains('วางมือถือ\r\nDESCRIPTION')));
    expect(text, isNot(contains('เช็กอิน\r\n')));
  });

  test('no plan or past times make an empty calendar', () {
    expect(build(nights: []).events, isEmpty);
    final past = buildIcs(
      nights: [night],
      enabled: all,
      sequences: const {},
      now: DateTime.utc(2026, 12, 1),
    );
    expect(past.events, isEmpty);
    expect(past.text, contains('END:VCALENDAR'));
  });

  group('status', () {
    final events = build(nights: [night, lateNight]).events;
    final exported = exportedStarts(events);
    final until = events.last.start;

    CalendarReminderStatus status({
      List<IcsEvent>? current,
      DateTime? at,
      DateTime? covered,
    }) => calendarReminderStatus(
      exported: exported,
      coveredUntil: covered ?? until,
      current: current ?? events,
      now: at ?? now,
    );

    test('never added', () {
      expect(
        calendarReminderStatus(
          exported: const {},
          coveredUntil: null,
          current: events,
          now: now,
        ),
        CalendarReminderStatus.neverAdded,
      );
    });

    test('says when under two days are left', () {
      expect(
        status(at: until.subtract(const Duration(days: 3))),
        CalendarReminderStatus.upToDate,
      );
      expect(
        status(at: until.subtract(const Duration(days: 1))),
        CalendarReminderStatus.runningOut,
      );
    });

    test('notices a moved or switched-off reminder', () {
      expect(
        status(
          current: build(
            nights: [night, lateNight],
            enabled: {IcsEventKind.bedtime},
          ).events,
        ),
        CalendarReminderStatus.planChanged,
      );
      expect(
        status(current: build(nights: [lateNight]).events),
        CalendarReminderStatus.planChanged,
      );
    });
  });

  test('backup is overdue after 7 days', () {
    bool overdue(DateTime? last) => isBackupOverdue(
      lastBackupAt: last,
      startedAt: DateTime(2026, 11, 1),
      now: DateTime(2026, 11, 23),
    );
    expect(overdue(null), isTrue);
    expect(overdue(DateTime(2026, 11, 16)), isFalse);
    expect(overdue(DateTime(2026, 11, 15)), isTrue);
  });
}
