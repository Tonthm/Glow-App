/// Checks what the AI read from a picture of a timetable, before the user
/// sees it (CLAUDE.md section 16, job 5). Unlike the other jobs, one bad
/// item is dropped by itself; the rest of the timetable is still useful.
/// Nothing is repaired or guessed.
library;

import 'dart:convert';

import 'ai_explain_guard.dart';
import 'subject_color.dart' show subjectKey;

const int maxImportItems = 80;
const int maxImportTitleChars = 100;
const int maxImportExtraChars = 60;
const int maxUnreadableLines = 10;
const int _maxUnreadableChars = 200;

/// Below this the whole item is marked to be checked.
const double lowConfidence = 0.7;

/// What counts as a believable class.
const int _earliestStart = 5 * 60;
const int _latestEnd = 23 * 60;
const int _shortestClass = 15;
const int _longestClass = 10 * 60;

enum ImportField { title, day, start, end, room, teacher }

class ImportedClass {
  final String title;

  /// 1 = Monday .. 7 = Sunday.
  final int day;
  final int startMinutes;
  final int endMinutes;

  /// Shown on the review page to help the user check; not saved.
  final String? room;
  final String? teacher;
  final double confidence;
  final Set<ImportField> uncertain;

  const ImportedClass({
    required this.title,
    required this.day,
    required this.startMinutes,
    required this.endMinutes,
    required this.confidence,
    this.room,
    this.teacher,
    this.uncertain = const {},
  });

  bool isUncertain(ImportField field) =>
      confidence < lowConfidence || uncertain.contains(field);
}

class TimetableReading {
  final List<ImportedClass> items;

  /// Text the model saw but couldn't turn into a class.
  final List<String> unreadable;

  /// How many items failed the checks. Their contents are never shown.
  final int dropped;

  const TimetableReading({
    required this.items,
    required this.unreadable,
    required this.dropped,
  });
}

// ---------- days and times ----------

const Map<String, int> _dayNames = {
  'จันทร์': 1, 'จ': 1, 'monday': 1, 'mon': 1,
  'อังคาร': 2, 'อ': 2, 'tuesday': 2, 'tue': 2, 'tues': 2,
  'พุธ': 3, 'พ': 3, 'wednesday': 3, 'wed': 3,
  'พฤหัสบดี': 4, 'พฤหัส': 4, 'พฤ': 4,
  'thursday': 4, 'thu': 4, 'thur': 4, 'thurs': 4,
  'ศุกร์': 5, 'ศ': 5, 'friday': 5, 'fri': 5,
  'เสาร์': 6, 'ส': 6, 'saturday': 6, 'sat': 6,
  'อาทิตย์': 7, 'อา': 7, 'sunday': 7, 'sun': 7,
};

/// Thai or English, in full or short; null if it isn't a day.
int? parseDayName(String text) {
  var name = text.trim().toLowerCase().replaceAll('.', '');
  if (name.startsWith('วัน')) name = name.substring(3).trim();
  return _dayNames[name];
}

const _thaiDigits = '๐๑๒๓๔๕๖๗๘๙';

/// Minutes after midnight from "08:30", "8.30 น.", "0830", "1:15 PM" and the
/// like; null if it isn't a time.
int? parseClock(String text) {
  var clean = text.trim().toLowerCase();
  for (var i = 0; i < _thaiDigits.length; i++) {
    clean = clean.replaceAll(_thaiDigits[i], '$i');
  }
  final match =
      RegExp(
        r'^(\d{1,2})(?:[:.](\d{2}))?\s*(a\.?m\.?|p\.?m\.?|น\.?)?$',
      ).firstMatch(clean) ??
      RegExp(r'^(\d{2})(\d{2})\s*(a\.?m\.?|p\.?m\.?|น\.?)?$').firstMatch(clean);
  if (match == null) return null;
  var hour = int.parse(match[1]!);
  final minute = int.parse(match[2] ?? '0');
  final suffix = match[3] ?? '';
  if (minute > 59) return null;
  if (suffix.startsWith('a') || suffix.startsWith('p')) {
    if (hour < 1 || hour > 12) return null;
    hour = hour % 12 + (suffix.startsWith('p') ? 12 : 0);
  }
  return hour > 23 ? null : hour * 60 + minute;
}

// ---------- the answer ----------

const Set<String> _itemKeys = {
  'title',
  'day',
  'start',
  'end',
  'room',
  'teacher',
  'confidence',
  'uncertain',
};

String? _extra(Object? value) {
  if (value is! String) return null;
  final text = value.trim();
  return text.isEmpty ||
          text.length > maxImportExtraChars ||
          hasForbiddenPhrase(text)
      ? null
      : text;
}

ImportedClass? _item(Object? value) {
  if (value is! Map<String, Object?> ||
      value.length != _itemKeys.length ||
      !_itemKeys.every(value.containsKey)) {
    return null;
  }
  final title = value['title'];
  final day = value['day'];
  final start = value['start'];
  final end = value['end'];
  final confidence = value['confidence'];
  final uncertain = value['uncertain'];
  final room = value['room'];
  final teacher = value['teacher'];
  if (title is! String ||
      day is! String ||
      start is! String ||
      end is! String ||
      confidence is! num ||
      uncertain is! List ||
      (room != null && room is! String) ||
      (teacher != null && teacher is! String)) {
    return null;
  }
  final name = title.trim();
  if (name.isEmpty ||
      name.length > maxImportTitleChars ||
      hasForbiddenPhrase(name)) {
    return null;
  }
  final weekday = parseDayName(day);
  final from = parseClock(start);
  final to = parseClock(end);
  if (weekday == null || from == null || to == null) return null;
  if (from < _earliestStart ||
      to > _latestEnd ||
      to - from < _shortestClass ||
      to - from > _longestClass) {
    return null;
  }
  if (confidence < 0 || confidence > 1) return null;
  final fields = <ImportField>{};
  for (final field in uncertain) {
    final known = ImportField.values.where((f) => f.name == field);
    if (known.isEmpty) return null;
    fields.add(known.first);
  }
  return ImportedClass(
    title: name,
    day: weekday,
    startMinutes: from,
    endMinutes: to,
    room: _extra(room),
    teacher: _extra(teacher),
    confidence: confidence.toDouble(),
    uncertain: fields,
  );
}

/// Null if the answer as a whole is in the wrong shape.
TimetableReading? parseTimetable(String response) {
  Object? root;
  try {
    root = jsonDecode(response);
  } on FormatException {
    return null;
  }
  if (root is! Map<String, Object?> ||
      root.length != 2 ||
      root['items'] is! List ||
      root['unreadable'] is! List) {
    return null;
  }
  final raw = root['items'] as List;
  if (raw.length > maxImportItems) return null;

  var dropped = 0;
  final byPlace = <(String, int, int, int), ImportedClass>{};
  for (final value in raw) {
    final item = _item(value);
    if (item == null) {
      dropped++;
      continue;
    }
    final place = (
      subjectKey(item.title),
      item.day,
      item.startMinutes,
      item.endMinutes,
    );
    final other = byPlace[place];
    if (other == null || item.confidence > other.confidence) {
      byPlace[place] = item;
    }
  }
  final items = byPlace.values.toList()
    ..sort((a, b) {
      final order = a.day.compareTo(b.day);
      return order != 0 ? order : a.startMinutes.compareTo(b.startMinutes);
    });

  final unreadable = <String>[
    for (final line in root['unreadable'] as List)
      if (line is String &&
          line.trim().isNotEmpty &&
          !hasForbiddenPhrase(line))
        line.trim().length > _maxUnreadableChars
            ? line.trim().substring(0, _maxUnreadableChars)
            : line.trim(),
  ];
  return TimetableReading(
    items: items,
    unreadable: unreadable.take(maxUnreadableLines).toList(),
    dropped: dropped,
  );
}

// ---------- classes already there ----------

class ExistingClass {
  final int id;
  final String title;
  final int day;
  final int start;
  final int end;

  const ExistingClass({
    required this.id,
    required this.title,
    required this.day,
    required this.start,
    required this.end,
  });
}

List<ExistingClass> overlapping(
  ImportedClass item,
  List<ExistingClass> existing,
) => [
  for (final e in existing)
    if (e.day == item.day &&
        e.start < item.endMinutes &&
        item.startMinutes < e.end)
      e,
];

enum ImportChoice { skip, replace, add }

/// Anything that clashes is skipped until the user says otherwise.
ImportChoice defaultChoice(ImportedClass item, List<ExistingClass> existing) =>
    overlapping(item, existing).isEmpty ? ImportChoice.add : ImportChoice.skip;

/// What saving does with the user's choices.
({List<ImportedClass> add, Set<int> removeIds}) importPlan(
  List<(ImportedClass, ImportChoice)> chosen,
  List<ExistingClass> existing,
) => (
  add: [
    for (final (item, choice) in chosen)
      if (choice != ImportChoice.skip) item,
  ],
  removeIds: {
    for (final (item, choice) in chosen)
      if (choice == ImportChoice.replace)
        for (final e in overlapping(item, existing)) e.id,
  },
);

// ---------- measuring accuracy ----------

/// An item is correct only if name, day, start and end all match.
({int correct, int expected, int extra}) scoreReading({
  required List<ImportedClass> expected,
  required List<ImportedClass> read,
}) {
  final left = [...read];
  var correct = 0;
  for (final want in expected) {
    final at = left.indexWhere(
      (got) =>
          subjectKey(got.title) == subjectKey(want.title) &&
          got.day == want.day &&
          got.startMinutes == want.startMinutes &&
          got.endMinutes == want.endMinutes,
    );
    if (at < 0) continue;
    left.removeAt(at);
    correct++;
  }
  return (correct: correct, expected: expected.length, extra: left.length);
}
