/// Turns spoken Thai into schedule items using hand-written rules (CLAUDE.md
/// section 11, no AI).
///
/// The text is scanned for day and time phrases. Whatever is left between
/// them becomes the subject names.
library;

import 'schedule_models.dart';

/// Parts of an item the review screen should highlight for checking.
enum ParsedField { day, start, end, title }

/// One recognised item. Weekly items have [weekday]; one-off items have
/// [date]. Holidays have no times.
class ParsedScheduleItem {
  final String title;
  final int? weekday;
  final DateTime? date;
  final int? startMinutes;
  final int? endMinutes;
  final ItemKind kind;
  final Set<ParsedField> uncertain;

  const ParsedScheduleItem({
    required this.title,
    required this.kind,
    required this.uncertain,
    this.weekday,
    this.date,
    this.startMinutes,
    this.endMinutes,
  });
}

class ThaiScheduleParseResult {
  final List<ParsedScheduleItem> items;

  /// Text that couldn't be turned into an item, shown to the user as is.
  final List<String> unparsed;

  const ThaiScheduleParseResult({required this.items, required this.unparsed});
}

const _endOfDay = 23 * 60 + 59;

// ---------------------------------------------------------------- numbers

const _digitWords = {
  'ศูนย์': 0,
  'หนึ่ง': 1,
  'นึง': 1,
  'เอ็ด': 1,
  'สอง': 2,
  'สาม': 3,
  'สี่': 4,
  'ห้า': 5,
  'หก': 6,
  'เจ็ด': 7,
  'แปด': 8,
  'เก้า': 9,
};

const _unit = 'หนึ่ง|นึง|สอง|สาม|สี่|ห้า|หก|เจ็ด|แปด|เก้า';

/// A number as digits or Thai words, 0-59.
const _number =
    r'(?:\d{1,2}|(?:ยี่|สาม|สี่|ห้า)?สิบ(?:เอ็ด|'
    '$_unit'
    r')?|'
    '$_unit'
    r'|ศูนย์)';

int _numberValue(String text) {
  final digits = int.tryParse(text);
  if (digits != null) return digits;
  final ten = text.indexOf('สิบ');
  if (ten < 0) return _digitWords[text]!;
  final before = text.substring(0, ten);
  final after = text.substring(ten + 'สิบ'.length);
  final tens = before.isEmpty
      ? 1
      : before == 'ยี่'
      ? 2
      : _digitWords[before]!;
  return tens * 10 + (after.isEmpty ? 0 : _digitWords[after]!);
}

// ---------------------------------------------------------------- times

class _Time {
  final int minutes;
  final bool uncertain;
  const _Time(this.minutes, {this.uncertain = false});
}

/// "ครึ่ง" or "N นาที" after an hour.
const _suffix = '(?:\\s*(?:(ครึ่ง)|($_number)\\s*นาที))?';

final _timePattern = RegExp(
  [
    // 1: midnight, 2: noon
    r'(เที่ยงคืน)',
    r'(เที่ยง(?:วัน|ตรง)?)',
    // 3: ตีสาม
    'ตี\\s*($_number)',
    // 4: บ่ายโมง, 5: บ่ายสอง(โมง)
    r'(บ่าย\s*โมง)',
    'บ่าย\\s*($_number)(?:\\s*โมง)?(?:\\s*เย็น)?',
    // 6: สามทุ่ม
    '($_number)\\s*ทุ่ม',
    // 7: hour + โมง, 8: เช้า or เย็น
    '($_number)\\s*โมง(?:\\s*(เช้า|เย็น))?',
    // 9: สิบสามนาฬิกา
    '($_number)\\s*นาฬิกา',
    // 10, 11: 8.30 / 08:30
    r'(?<![\d.:])(\d{1,2})\s*[.:]\s*(\d{2})(?![\d])(?:\s*(?:น\.|นาฬิกา))?',
  ].map((p) => '(?:$p)').join('|'),
);

final _suffixPattern = RegExp('^$_suffix(?:\\s*ตรง)?');

/// Reads the time matched at [match]; null if the numbers make no sense.
_Time? _readTime(RegExpMatch match) {
  _Time? hour(int h, {bool uncertain = false}) =>
      h >= 0 && h < 24 ? _Time(h * 60, uncertain: uncertain) : null;

  if (match[1] != null) return const _Time(0);
  if (match[2] != null) return const _Time(12 * 60);
  if (match[3] != null) {
    final n = _numberValue(match[3]!);
    return n >= 1 && n <= 5 ? hour(n) : null;
  }
  if (match[4] != null) return hour(13);
  if (match[5] != null) {
    final n = _numberValue(match[5]!);
    return n >= 1 && n <= 6 ? hour(n + 12) : null;
  }
  if (match[6] != null) {
    final n = _numberValue(match[6]!);
    return n >= 1 && n <= 5 ? hour(n + 18) : null;
  }
  if (match[7] != null) {
    final n = _numberValue(match[7]!);
    switch (match[8]) {
      case 'เช้า':
        // "สองโมงเช้า" is the old way of saying 08:00.
        return n <= 5 ? hour(n + 6, uncertain: true) : hour(n);
      case 'เย็น':
        return n >= 1 && n <= 6 ? hour(n + 12) : hour(n);
      default:
        // Bare "สองโมง" is read as the afternoon, but flagged.
        if (n >= 1 && n <= 5) return hour(n + 12, uncertain: true);
        return hour(n, uncertain: n == 6);
    }
  }
  if (match[9] != null) return hour(_numberValue(match[9]!));
  final h = int.parse(match[10]!);
  final m = int.parse(match[11]!);
  return h < 24 && m < 60 ? _Time(h * 60 + m) : null;
}

// ---------------------------------------------------------------- tokens

sealed class _Token {
  final int from;
  final int to;
  const _Token(this.from, this.to);
}

class _TimeToken extends _Token {
  final _Time start;
  final _Time? end;
  const _TimeToken(super.from, super.to, this.start, [this.end]);
}

class _DayToken extends _Token {
  final List<int> weekdays;
  final DateTime? date;
  final bool uncertain;
  const _DayToken(
    super.from,
    super.to, {
    this.weekdays = const [],
    this.date,
    this.uncertain = false,
  });
}

const _monthNames = [
  r'มกราคม|มกรา|ม\.ค\.',
  r'กุมภาพันธ์|กุมภา|ก\.พ\.',
  r'มีนาคม|มีนา|มี\.ค\.',
  r'เมษายน|เมษา|เม\.ย\.',
  r'พฤษภาคม|พฤษภา|พ\.ค\.',
  r'มิถุนายน|มิถุนา|มิ\.ย\.',
  r'กรกฎาคม|กรกฎา|ก\.ค\.',
  r'สิงหาคม|สิงหา|ส\.ค\.',
  r'กันยายน|กันยา|ก\.ย\.',
  r'ตุลาคม|ตุลา|ต\.ค\.',
  r'พฤศจิกายน|พฤศจิกา|พ\.ย\.',
  r'ธันวาคม|ธันวา|ธ\.ค\.',
];

final _datePattern = RegExp(
  '(?:วันที่\\s*)?(?<![\\d.:])($_number)\\s*(?:'
  '${_monthNames.map((m) => '($m)').join('|')})',
);

final _relativePattern = RegExp('(พรุ่งนี้|มะรืน(?:นี้)?|วันนี้)');

/// Full names, then abbreviations. An abbreviation must stand alone: "พ." is
/// not the start of "พ.ย." (November) or "พ.ค." (May).
const _alone = r'(?![ก-๙]{1,2}\.)';
const _weekdayPatterns = [
  r'จันทร์|(?<![ก-๙.])จ\.'
      '$_alone',
  r'อังคาร|(?<![ก-๙.])อ\.'
      '$_alone',
  r'พุธ|(?<![ก-๙.])พ\.'
      '$_alone',
  r'พฤหัส(?:บดี)?|(?<![ก-๙.])พฤ\.'
      '$_alone',
  r'ศุกร์|(?<![ก-๙.])ศ\.'
      '$_alone',
  r'เสาร์|(?<![ก-๙.])ส\.'
      '$_alone',
  r'อาทิตย์|(?<![ก-๙.])อา\.'
      '$_alone',
];

final _oneWeekday = '(?:วัน\\s*)?(?:${_weekdayPatterns.join('|')})';

final _weekdayPattern = RegExp(
  '(ทุก\\s*วัน(?!\\s*(?:${_weekdayPatterns.join('|')})))|'
  '(?<!พระ)($_oneWeekday)',
);

final _dayRangeJoin = RegExp(r'^\s*(?:ถึง|-|–|จนถึง)\s*$');
final _dayListJoin = RegExp(r'^\s*(?:กับ|และ|,)?\s*$');
final _timeRangeJoin = RegExp(r'^\s*(?:จนถึง|ถึง|จน|-|–|~)\s*(?:เวลา\s*)?$');

int _weekdayOf(String text) {
  for (var i = 0; i < _weekdayPatterns.length; i++) {
    if (RegExp(_weekdayPatterns[i]).hasMatch(text)) return i + 1;
  }
  throw StateError('not a weekday: $text');
}

bool _overlaps(List<_Token> tokens, int from, int to) =>
    tokens.any((t) => from < t.to && t.from < to);

List<_DayToken> _findDates(String text, DateTime today) {
  final tokens = <_DayToken>[];
  for (final match in _datePattern.allMatches(text)) {
    final day = _numberValue(match[1]!);
    var month = 0;
    for (var m = 1; m <= 12; m++) {
      if (match[m + 1] != null) month = m;
    }
    // The next time that date comes around.
    var date = DateTime(today.year, month, day);
    if (date.isBefore(today)) date = DateTime(today.year + 1, month, day);
    final valid = date.month == month && date.day == day;
    tokens.add(
      _DayToken(
        match.start,
        match.end,
        date: valid ? date : today,
        uncertain: !valid,
      ),
    );
  }
  for (final match in _relativePattern.allMatches(text)) {
    final word = match[1]!;
    final offset = word == 'วันนี้'
        ? 0
        : word == 'พรุ่งนี้'
        ? 1
        : 2;
    tokens.add(
      _DayToken(
        match.start,
        match.end,
        date: DateTime(today.year, today.month, today.day + offset),
      ),
    );
  }
  return tokens;
}

/// Weekday names, joining "จันทร์ถึงศุกร์" into a range and "จันทร์ พุธ"
/// into a list.
List<_DayToken> _findWeekdays(String text) {
  final tokens = <_DayToken>[];
  var rangeAllowed = false;
  for (final match in _weekdayPattern.allMatches(text)) {
    if (match[1] != null) {
      tokens.add(
        _DayToken(match.start, match.end, weekdays: [1, 2, 3, 4, 5, 6, 7]),
      );
      rangeAllowed = false;
      continue;
    }
    final day = _weekdayOf(match[2]!);
    final previous = tokens.isEmpty ? null : tokens.last;
    if (previous != null && rangeAllowed) {
      final between = text.substring(previous.to, match.start);
      if (_dayRangeJoin.hasMatch(between)) {
        final first = previous.weekdays.last;
        final span = (day - first) % 7;
        tokens.last = _DayToken(
          previous.from,
          match.end,
          weekdays: [
            ...previous.weekdays,
            for (var i = 1; i <= span; i++) (first - 1 + i) % 7 + 1,
          ],
        );
        continue;
      }
      if (_dayListJoin.hasMatch(between)) {
        tokens.last = _DayToken(
          previous.from,
          match.end,
          weekdays: [...previous.weekdays, day],
        );
        continue;
      }
    }
    tokens.add(_DayToken(match.start, match.end, weekdays: [day]));
    rangeAllowed = true;
  }
  return tokens;
}

/// Times, pairing "X ถึง Y" into one token.
List<_TimeToken> _findTimes(String text, List<_Token> taken) {
  final singles = <_TimeToken>[];
  var consumed = 0;
  for (final match in _timePattern.allMatches(text)) {
    if (match.start < consumed || _overlaps(taken, match.start, match.end)) {
      continue;
    }
    var time = _readTime(match);
    if (time == null) continue;
    var end = match.end;
    // Clock digits already carry their minutes.
    if (match[10] == null && match[1] == null) {
      final suffix = _suffixPattern.firstMatch(text.substring(end))!;
      final extra = suffix[1] != null
          ? 30
          : suffix[2] != null
          ? _numberValue(suffix[2]!)
          : 0;
      time = _Time(time.minutes + extra, uncertain: time.uncertain);
      end += suffix.end;
    }
    consumed = end;
    singles.add(_TimeToken(match.start, end, time));
  }

  final ranges = <_TimeToken>[];
  for (var i = 0; i < singles.length; i++) {
    final first = singles[i];
    if (i + 1 < singles.length &&
        _timeRangeJoin.hasMatch(
          text.substring(first.to, singles[i + 1].from),
        )) {
      final second = singles[++i];
      ranges.add(_TimeToken(first.from, second.to, first.start, second.start));
      continue;
    }
    // "9-11 โมง": the first number has no unit of its own.
    final bare = RegExp(r'(?<![\d.:])(\d{1,2})\s*(?:ถึง|-|–)\s*$')
        .firstMatch(text.substring(0, first.from));
    if (bare != null && !_overlaps(taken, bare.start, first.from)) {
      final hour = int.parse(bare[1]!);
      if (hour < 24) {
        ranges.add(
          _TimeToken(
            bare.start,
            first.to,
            _Time(hour * 60, uncertain: true),
            first.start,
          ),
        );
        continue;
      }
    }
    ranges.add(first);
  }
  return ranges;
}

// ---------------------------------------------------------------- titles

final _leadingFiller = RegExp(
  r'^(?:(?:แล้วก็|แล้ว|และ|ต่อด้วย|กับ|ก็|มีเรียน|มี|เรียน|คาบ|เวลา|ตอน|ตั้งแต่|จาก)(?=\s|$)|วิชา|มี(?=สอบ)|[,\-–])\s*',
);
final _trailingFiller = RegExp(
  r'(?:^|\s+)(?:แล้วก็|แล้ว|และ|ต่อด้วย|มีเรียน|มี|เรียน|วิชา|เวลา|ตอน|ตั้งแต่|จาก|ครับ|ค่ะ|คะ|นะ|[,\-–])$',
);

String _cleanTitle(String fragment) {
  var title = fragment.replaceAll(RegExp(r'\s+'), ' ').trim();
  while (true) {
    final next = title
        .replaceFirst(_leadingFiller, '')
        .replaceFirst(_trailingFiller, '')
        .trim();
    if (next == title) return title;
    title = next;
  }
}

const _activityWords = ['ชมรม', 'ซ้อม', 'กิจกรรม', 'ประชุม', 'ทำงาน'];
final _holidayPattern = RegExp(r'งดเรียน|วันหยุด|หยุด');

// ------------------------------------------------- shared with the task parser

/// A number as digits or Thai words, as a regular-expression fragment.
const String thaiNumberPattern = _number;

int thaiNumberValue(String text) => _numberValue(text);

/// Thai digits to Arabic, and whitespace collapsed.
String normalizeThaiSpeech(String input) => _normalize(input);

/// Day phrases in [text] ("พรุ่งนี้", "วันศุกร์", "15 ธันวา") as dates. A
/// weekday name means its next occurrence, today included.
List<({int from, int to, DateTime date})> findThaiDates(
  String text,
  DateTime now,
) {
  final today = DateTime(now.year, now.month, now.day);
  final tokens = <_DayToken>[..._findDates(text, today)];
  for (final token in _findWeekdays(text)) {
    if (!_overlaps(tokens, token.from, token.to)) tokens.add(token);
  }
  tokens.sort((a, b) => a.from.compareTo(b.from));
  return [
    for (final t in tokens)
      if (!t.uncertain)
        (
          from: t.from,
          to: t.to,
          date:
              t.date ??
              DateTime(
                today.year,
                today.month,
                today.day + (t.weekdays.first - today.weekday + 7) % 7,
              ),
        ),
  ];
}

// ---------------------------------------------------------------- parsing

ThaiScheduleParseResult parseThaiSchedule(
  String input, {
  required DateTime now,
}) {
  final text = _normalize(input);
  if (text.isEmpty) {
    return const ThaiScheduleParseResult(items: [], unparsed: []);
  }
  final today = DateTime(now.year, now.month, now.day);

  final days = <_Token>[..._findDates(text, today)];
  for (final token in _findWeekdays(text)) {
    if (!_overlaps(days, token.from, token.to)) days.add(token);
  }
  final times = _findTimes(text, days);

  if (times.isEmpty) {
    final holiday = _parseHoliday(text, days.cast<_DayToken>());
    return holiday == null
        ? ThaiScheduleParseResult(items: [], unparsed: [text])
        : ThaiScheduleParseResult(items: [holiday], unparsed: []);
  }

  final tokens = <_Token>[...days, ...times]
    ..sort((a, b) => a.from.compareTo(b.from));

  // The text before each time, and after the last one, with day phrases cut
  // out. A day phrase also splits the text.
  final fragments = List.generate(times.length + 1, (_) => <String>[]);
  var position = 0;
  var timeIndex = 0;
  for (final token in tokens) {
    fragments[timeIndex].add(text.substring(position, token.from));
    position = token.to;
    if (token is _TimeToken) timeIndex++;
  }
  fragments[timeIndex].add(text.substring(position));

  String join(List<String> parts) =>
      parts.map(_cleanTitle).where((p) => p.isNotEmpty).join(' ');

  // People say either "8 โมง คณิต" or "คณิต 8 โมง". A real name before the
  // first time means names come first.
  final leading = join(fragments.first);
  final namesComeFirst = leading.isNotEmpty && leading != 'สอบ';

  // Each time takes the day mentioned most recently, or failing that the
  // first one mentioned after it.
  final dayFor = <_DayToken?>[];
  _DayToken? current;
  for (final token in tokens) {
    if (token is _DayToken) {
      current = token;
      for (var i = 0; i < dayFor.length; i++) {
        dayFor[i] ??= token;
      }
    } else {
      dayFor.add(current);
    }
  }

  final items = <ParsedScheduleItem>[];
  final unparsed = <String>[];
  for (var i = 0; i < times.length; i++) {
    final own = namesComeFirst ? fragments[i] : fragments[i + 1];
    var title = join(own);
    var context = own.join(' ');
    if (!namesComeFirst && i == 0) context = '$leading $context';
    if (namesComeFirst && i == times.length - 1) {
      final trailing = join(fragments.last);
      if (title.isEmpty) {
        title = trailing;
        context = '$context $trailing';
      } else if (trailing.isNotEmpty) {
        unparsed.add(trailing);
      }
    }
    final isExam =
        context.contains('สอบ') || (times.length == 1 && text.contains('สอบ'));
    // A lone "สอบ" marks the type; it isn't a subject name.
    if (title == 'สอบ') title = '';
    title = title.replaceFirst(RegExp(r'^สอบ\s+(?=\S)'), '');

    items.addAll(_buildItems(times[i], dayFor[i], title, isExam, today));
  }
  return ThaiScheduleParseResult(items: items, unparsed: unparsed);
}

List<ParsedScheduleItem> _buildItems(
  _TimeToken time,
  _DayToken? day,
  String title,
  bool isExam,
  DateTime today,
) {
  final uncertain = <ParsedField>{
    if (time.start.uncertain) ParsedField.start,
    if (title.isEmpty) ParsedField.title,
  };

  final start = time.start.minutes;
  var end = time.end?.minutes;
  if (end == null) {
    end = start + 60;
    uncertain.add(ParsedField.end);
  } else {
    if (time.end!.uncertain) uncertain.add(ParsedField.end);
    if (end <= start) {
      uncertain.add(ParsedField.end);
      // Running up to midnight stops there. Anything else is a mistake, so
      // suggest an hour and let the user check it.
      end = end == 0 ? _endOfDay : start + 60;
    }
  }
  if (end > _endOfDay) end = _endOfDay;

  final isActivity = _activityWords.any(title.contains);

  ParsedScheduleItem item({int? weekday, DateTime? date, ItemKind? kind}) =>
      ParsedScheduleItem(
        title: title,
        weekday: weekday,
        date: date,
        startMinutes: start,
        endMinutes: end,
        kind:
            kind ??
            (isExam
                ? ItemKind.exam
                : date != null || isActivity
                ? ItemKind.activity
                : ItemKind.classSession),
        uncertain: {...uncertain},
      );

  if (day == null) {
    uncertain.add(ParsedField.day);
    return [isExam ? item(date: today) : item(weekday: today.weekday)];
  }
  if (day.uncertain) uncertain.add(ParsedField.day);
  if (day.date != null) return [item(date: day.date)];
  if (isExam) {
    // Exams happen once: take the next such weekday and ask to check it.
    uncertain.add(ParsedField.day);
    return [
      for (final weekday in day.weekdays)
        item(
          date: DateTime(
            today.year,
            today.month,
            today.day + (weekday - today.weekday + 6) % 7 + 1,
          ),
        ),
    ];
  }
  return [for (final weekday in day.weekdays) item(weekday: weekday)];
}

/// "พรุ่งนี้หยุด": a day plus a holiday word, with no times.
ParsedScheduleItem? _parseHoliday(String text, List<_DayToken> days) {
  final word = _holidayPattern.firstMatch(text);
  if (word == null || days.length != 1) return null;
  final day = days.single;
  if (day.date == null) return null;
  return ParsedScheduleItem(
    title: word[0] == 'หยุด' ? 'วันหยุด' : word[0]!,
    date: day.date,
    kind: ItemKind.holiday,
    uncertain: {if (day.uncertain) ParsedField.day},
  );
}

String _normalize(String input) {
  const thaiDigits = '๐๑๒๓๔๕๖๗๘๙';
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final char = String.fromCharCode(rune);
    final digit = thaiDigits.indexOf(char);
    buffer.write(digit >= 0 ? '$digit' : char);
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}
