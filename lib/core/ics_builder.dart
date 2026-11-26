/// Builds the iCalendar file used for reminders on the web version (CLAUDE.md
/// section 17). Pure: times and counters come in, text goes out.
library;

import 'dart:convert';

import 'reminder_messages.dart';

/// [reminder] is a deadline or class reminder, with its own words.
enum IcsEventKind { putPhoneDown, bedtime, checkIn, reminder }

const Duration _eventLength = Duration(minutes: 5);
const Duration _checkInAfterWake = Duration(minutes: 30);
const int _maxLineBytes = 75;

const _titles = {
  IcsEventKind.putPhoneDown: 'Glow · วางมือถือ',
  IcsEventKind.bedtime: 'Glow · ถึงเวลานอน',
  IcsEventKind.checkIn: 'Glow · เช็กอิน',
};

const _messages = {
  IcsEventKind.putPhoneDown: putPhoneDownMessages,
  IcsEventKind.bedtime: bedtimeMessages,
  IcsEventKind.checkIn: checkInMessages,
};

/// One night's planned times, in the phone's local time.
class IcsNight {
  final DateTime wakeDate;
  final DateTime notifyTime;
  final DateTime bedtime;
  final DateTime wakeTime;

  const IcsNight({
    required this.wakeDate,
    required this.notifyTime,
    required this.bedtime,
    required this.wakeTime,
  });
}

/// A reminder from outside the sleep plan, already at a time that doesn't
/// cut into it (core/task_reminders).
class IcsExtra {
  final String uid;
  final DateTime start;
  final String title;
  final String message;

  const IcsExtra({
    required this.uid,
    required this.start,
    required this.title,
    required this.message,
  });
}

class IcsEvent {
  /// Only for [IcsEventKind.reminder].
  final String? title;
  final String? message;
  final String uid;
  final IcsEventKind kind;
  final DateTime wakeDate;
  final DateTime start;

  const IcsEvent({
    required this.uid,
    required this.kind,
    required this.wakeDate,
    required this.start,
    this.title,
    this.message,
  });
}

class IcsCalendar {
  final String text;
  final List<IcsEvent> events;

  /// The SEQUENCE counters to store for next time.
  final Map<String, int> sequences;

  const IcsCalendar({
    required this.text,
    required this.events,
    required this.sequences,
  });
}

String _two(int n) => n.toString().padLeft(2, '0');

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}${_two(d.month)}${_two(d.day)}';

/// The same night and kind always get the same id, so importing again updates
/// the event instead of adding another.
String icsUid(DateTime wakeDate, IcsEventKind kind) =>
    'glow-${_day(wakeDate)}-${kind.name}@glow.app';

/// UTC in iCalendar form, e.g. "20261122T144500Z".
String icsUtc(DateTime time) {
  final utc = time.toUtc();
  return '${_day(utc)}T${_two(utc.hour)}${_two(utc.minute)}'
      '${_two(utc.second)}Z';
}

String escapeIcsText(String text) => text
    .replaceAll(r'\', r'\\')
    .replaceAll(';', r'\;')
    .replaceAll(',', r'\,')
    .replaceAll(RegExp(r'\r\n|\r|\n'), r'\n');

/// Folds [line] so no piece is over 75 bytes. It only breaks between whole
/// characters: a Thai letter is 3 bytes in UTF-8 and must not be cut.
String foldIcsLine(String line) {
  final result = StringBuffer();
  var bytes = 0;
  for (final rune in line.runes) {
    final character = String.fromCharCode(rune);
    final size = utf8.encode(character).length;
    if (bytes + size > _maxLineBytes) {
      result.write('\r\n ');
      // The space that marks a continuation counts too.
      bytes = 1;
    }
    result.write(character);
    bytes += size;
  }
  return result.toString();
}

/// The events due after [now] for the reminders in [enabled].
List<IcsEvent> icsEvents({
  required List<IcsNight> nights,
  required Set<IcsEventKind> enabled,
  required DateTime now,
  List<IcsExtra> extras = const [],
}) {
  return [
      for (final extra in extras)
        IcsEvent(
          uid: extra.uid,
          kind: IcsEventKind.reminder,
          wakeDate: DateTime(
            extra.start.year,
            extra.start.month,
            extra.start.day,
          ),
          start: extra.start,
          title: extra.title,
          message: extra.message,
        ),
      for (final night in nights)
        for (final kind in IcsEventKind.values)
          if (kind != IcsEventKind.reminder && enabled.contains(kind))
            IcsEvent(
              uid: icsUid(night.wakeDate, kind),
              kind: kind,
              wakeDate: night.wakeDate,
              start: switch (kind) {
                IcsEventKind.putPhoneDown => night.notifyTime,
                IcsEventKind.bedtime => night.bedtime,
                IcsEventKind.checkIn => night.wakeTime.add(_checkInAfterWake),
                IcsEventKind.reminder => throw StateError('not a night'),
              },
            ),
    ].where((e) => e.start.isAfter(now)).toList()
    ..sort((a, b) => a.start.compareTo(b.start));
}

/// The message depends only on the date, so building again gives the same one.
String _messageFor(IcsEvent event) {
  final messages = _messages[event.kind]!;
  final dayNumber = DateTime.utc(
    event.wakeDate.year,
    event.wakeDate.month,
    event.wakeDate.day,
  ).difference(DateTime.utc(2020)).inDays;
  return messages[dayNumber % messages.length];
}

/// [sequences] holds each event's last SEQUENCE. A new event starts at 0, and
/// one built before gets the next number.
IcsCalendar buildIcs({
  required List<IcsNight> nights,
  required Set<IcsEventKind> enabled,
  required Map<String, int> sequences,
  required DateTime now,
  List<IcsExtra> extras = const [],
}) {
  final events = icsEvents(
    nights: nights,
    enabled: enabled,
    now: now,
    extras: extras,
  );
  final updated = {...sequences};
  final lines = <String>[
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Glow//Sleep reminders//TH',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    'X-WR-CALNAME:Glow',
  ];
  for (final event in events) {
    final previous = updated[event.uid];
    final sequence = previous == null ? 0 : previous + 1;
    updated[event.uid] = sequence;
    final title = escapeIcsText(
      event.title == null ? _titles[event.kind]! : 'Glow · ${event.title}',
    );
    final message = escapeIcsText(event.message ?? _messageFor(event));
    lines.addAll([
      'BEGIN:VEVENT',
      'UID:${event.uid}',
      'SEQUENCE:$sequence',
      'DTSTAMP:${icsUtc(now)}',
      'DTSTART:${icsUtc(event.start)}',
      'DTEND:${icsUtc(event.start.add(_eventLength))}',
      'SUMMARY:$title',
      'DESCRIPTION:$message',
      'BEGIN:VALARM',
      'ACTION:DISPLAY',
      'DESCRIPTION:$title',
      'TRIGGER:PT0M',
      'END:VALARM',
      'END:VEVENT',
    ]);
  }
  lines.add('END:VCALENDAR');
  return IcsCalendar(
    text: '${lines.map(foldIcsLine).join('\r\n')}\r\n',
    events: events,
    sequences: updated,
  );
}
