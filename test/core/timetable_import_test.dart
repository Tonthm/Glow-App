import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/timetable_import.dart';

Map<String, Object?> _item({
  Object? title = 'คณิต',
  Object? day = 'จันทร์',
  Object? start = '08:30',
  Object? end = '10:00',
  Object? room,
  Object? teacher,
  Object? confidence = 0.9,
  Object? uncertain = const <String>[],
}) => {
  'title': title,
  'day': day,
  'start': start,
  'end': end,
  'room': room,
  'teacher': teacher,
  'confidence': confidence,
  'uncertain': uncertain,
};

String _answer(List<Object?> items, [List<Object?> unreadable = const []]) =>
    jsonEncode({'items': items, 'unreadable': unreadable});

void main() {
  group('day names', () {
    test('Thai, in full and short', () {
      const names = {
        1: ['จันทร์', 'วันจันทร์', 'จ.', 'จ'],
        2: ['อังคาร', 'อ.', 'อ'],
        3: ['พุธ', 'พ.', 'พ'],
        4: ['พฤหัสบดี', 'พฤหัส', 'พฤ.', 'พฤ'],
        5: ['ศุกร์', 'ศ.'],
        6: ['เสาร์', 'ส.'],
        7: ['อาทิตย์', 'อา.', ' วันอาทิตย์ '],
      };
      for (final MapEntry(key: day, value: spellings) in names.entries) {
        for (final name in spellings) {
          expect(parseDayName(name), day, reason: name);
        }
      }
    });

    test('English, in full and short', () {
      const names = {
        1: ['Monday', 'MON', 'mon.'],
        2: ['Tuesday', 'Tue', 'Tues'],
        3: ['Wednesday', 'Wed'],
        4: ['Thursday', 'Thu', 'Thur', 'Thurs'],
        5: ['Friday', 'Fri'],
        6: ['Saturday', 'Sat'],
        7: ['Sunday', 'Sun'],
      };
      for (final MapEntry(key: day, value: spellings) in names.entries) {
        for (final name in spellings) {
          expect(parseDayName(name), day, reason: name);
        }
      }
    });

    test('anything else is not a day', () {
      for (final name in ['', 'วัน', 'x', 'monkey', 'จันทร', 'T', '1']) {
        expect(parseDayName(name), isNull, reason: name);
      }
    });
  });

  group('times', () {
    test('24-hour, with a colon, a dot, or nothing between', () {
      const times = {
        '08:30': 510,
        '8:30': 510,
        '8.30': 510,
        '0830': 510,
        '8.30 น.': 510,
        '13:00น': 780,
        '8': 480,
        '23:00': 1380,
        '๐๘.๓๐': 510,
      };
      for (final MapEntry(key: text, value: minutes) in times.entries) {
        expect(parseClock(text), minutes, reason: text);
      }
    });

    test('AM and PM', () {
      const times = {
        '8:30 AM': 510,
        '8:30am': 510,
        '1:15 PM': 795,
        '1 pm': 780,
        '12:00 PM': 720,
        '12:30 a.m.': 30,
      };
      for (final MapEntry(key: text, value: minutes) in times.entries) {
        expect(parseClock(text), minutes, reason: text);
      }
    });

    test('refuses what is not a time', () {
      for (final text in [
        '',
        'abc',
        '24:00',
        '8:60',
        '13:00 PM',
        '0 am',
        '8:3',
        '123456',
        '8-9',
      ]) {
        expect(parseClock(text), isNull, reason: text);
      }
    });
  });

  group("reading the model's answer", () {
    test('takes a good item, with its extras', () {
      final result = parseTimetable(
        _answer([
          _item(room: '321', teacher: 'ครูเอ', uncertain: ['end']),
        ]),
      )!;
      final item = result.items.single;
      expect(
        (item.title, item.day, item.startMinutes, item.endMinutes),
        ('คณิต', 1, 510, 600),
      );
      expect((item.room, item.teacher), ('321', 'ครูเอ'));
      expect(item.isUncertain(ImportField.end), isTrue);
      expect(item.isUncertain(ImportField.title), isFalse);
      expect(result.dropped, 0);
    });

    test('low confidence marks every field to be checked', () {
      final item = parseTimetable(
        _answer([_item(confidence: 0.4)]),
      )!.items.single;
      expect(ImportField.values.every(item.isUncertain), isTrue);
    });

    test('drops only the items that are wrong', () {
      final bad = [
        _item(title: '  '),
        _item(title: 'x' * 101),
        _item(day: 'someday'),
        _item(start: 'late'),
        _item(start: '10:00', end: '09:00'),
        _item(start: '10:00', end: '10:00'),
        // Not a believable class.
        _item(start: '02:00', end: '03:00'),
        _item(start: '22:00', end: '23:30'),
        _item(start: '08:00', end: '08:05'),
        _item(start: '06:00', end: '18:00'),
        _item(confidence: 2),
        _item(uncertain: ['colour']),
        {..._item(), 'extra': 1},
        _item()..remove('end'),
        'not an object',
        null,
      ];
      final result = parseTimetable(_answer([...bad, _item()]))!;
      expect(result.items, hasLength(1));
      expect(result.dropped, bad.length);
    });

    test('a class suggesting less sleep never gets through', () {
      final result = parseTimetable(
        _answer([_item(title: 'โต้รุ่งอ่านหนังสือ')], ['อดนอนกันเถอะ']),
      )!;
      expect(result.items, isEmpty);
      expect(result.unreadable, isEmpty);
    });

    test('repeats are cut to the surest one, in week order', () {
      final result = parseTimetable(
        _answer([
          _item(day: 'ศุกร์'),
          _item(title: 'Physics', confidence: 0.5),
          _item(title: ' physics ', confidence: 0.95),
        ]),
      )!;
      expect(result.items.map((i) => (i.day, i.confidence)), [
        (1, 0.95),
        (5, 0.9),
      ]);
      // A repeat isn't a mistake to tell the user about.
      expect(result.dropped, 0);
    });

    test('keeps a few short lines it could not read', () {
      final result = parseTimetable(
        _answer([], ['  ??  ', '', 7, 'x' * 300, for (var i = 0; i < 20; i++) '$i']),
      )!;
      expect(result.unreadable.first, '??');
      expect(result.unreadable.length, maxUnreadableLines);
      expect(result.unreadable.every((s) => s.length <= 200), isTrue);
    });

    test('refuses an answer in the wrong shape', () {
      for (final text in [
        'sorry',
        '[]',
        '{"items": []}',
        '{"items": {}, "unreadable": []}',
        '{"items": [], "unreadable": [], "note": "x"}',
        _answer(List.filled(maxImportItems + 1, _item())),
      ]) {
        expect(parseTimetable(text), isNull, reason: text);
      }
    });
  });

  group('classes already in the timetable', () {
    const existing = [
      ExistingClass(id: 1, title: 'คณิต', day: 1, start: 510, end: 600),
      ExistingClass(id: 2, title: 'ไทย', day: 1, start: 600, end: 660),
      ExistingClass(id: 3, title: 'อังกฤษ', day: 2, start: 510, end: 600),
    ];

    ImportedClass read(String title, int day, int start, int end) =>
        ImportedClass(
          title: title,
          day: day,
          startMinutes: start,
          endMinutes: end,
          confidence: 1,
        );

    test('finds the ones it overlaps, on the same day only', () {
      expect(
        overlapping(read('x', 1, 540, 630), existing).map((e) => e.id),
        [1, 2],
      );
      // Touching is not overlapping.
      expect(overlapping(read('x', 1, 660, 700), existing), isEmpty);
    });

    test('an overlap starts as "skip", so nothing is lost unasked', () {
      expect(defaultChoice(read('x', 1, 540, 630), existing), ImportChoice.skip);
      expect(defaultChoice(read('x', 3, 540, 630), existing), ImportChoice.add);
    });

    test('saving adds, skips, or replaces as chosen', () {
      final plan = importPlan([
        (read('a', 1, 540, 630), ImportChoice.replace),
        (read('b', 2, 510, 600), ImportChoice.skip),
        (read('c', 2, 510, 600), ImportChoice.add),
        (read('d', 1, 510, 560), ImportChoice.replace),
      ], existing);
      expect(plan.add.map((c) => c.title), ['a', 'c', 'd']);
      // Replaced once even if two new ones ask.
      expect(plan.removeIds, {1, 2});
    });
  });

  group('scoring against a hand-made answer', () {
    ImportedClass c(String title, int day, int start, int end) => ImportedClass(
      title: title,
      day: day,
      startMinutes: start,
      endMinutes: end,
      confidence: 1,
    );

    test('counts exact matches, misses and extras', () {
      final score = scoreReading(
        expected: [c('คณิต', 1, 510, 600), c('ไทย', 2, 510, 600)],
        read: [
          c(' คณิต ', 1, 510, 600),
          c('ไทย', 2, 510, 610),
          c('ผี', 3, 510, 600),
        ],
      );
      expect((score.correct, score.expected, score.extra), (1, 2, 2));
    });
  });
}
