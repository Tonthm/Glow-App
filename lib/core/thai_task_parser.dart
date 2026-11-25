/// "การบ้านเลขสี่สิบนาทีส่งพรุ่งนี้" → a task for tonight (CLAUDE.md section
/// 14). Rules only; days are read the same way as in the timetable parser.
library;

import 'evening_planner.dart';
import 'thai_schedule_parser.dart';

class ParsedTask {
  final String title;

  /// Estimated minutes in 5-minute steps, or null if none was said.
  final int? minutes;
  final DateTime? due;
  final EveningTaskKind kind;

  const ParsedTask({
    required this.title,
    required this.kind,
    this.minutes,
    this.due,
  });
}

const _hourWord = r'(?:ชั่วโมง|ชม\.?)';

final _durationPattern = RegExp(
  '(?:(?:ใช้เวลา|ประมาณ)\\s*)*(?:'
  // 1: "ครึ่งชั่วโมง"
  '(ครึ่ง\\s*$_hourWord)|'
  // 2: hours, optionally 3: "ครึ่ง", or 4: extra minutes
  '(?:($thaiNumberPattern)\\s*)?(?<hour>$_hourWord)(?:นึง)?'
  '(?:\\s*(?:(ครึ่ง)|($thaiNumberPattern)\\s*นาที))?|'
  // 5: minutes only
  '($thaiNumberPattern)\\s*นาที'
  ')',
);

final _sentWord = RegExp(r'(?:กำหนด)?ส่ง\s*');
final _filler = RegExp(r'(?:^|\s+)(?:ครับ|ค่ะ|คะ|นะ|ใช้เวลา|ประมาณ)(?=\s|$)');

ParsedTask parseSpokenTask(String input, {required DateTime now}) {
  var text = normalizeThaiSpeech(input);

  int? minutes;
  final duration = _durationPattern.firstMatch(text);
  if (duration != null) {
    if (duration[1] != null) {
      minutes = 30;
    } else if (duration.namedGroup('hour') != null) {
      final hours = duration[2] == null ? 1 : thaiNumberValue(duration[2]!);
      minutes = hours * 60;
      if (duration[4] != null) minutes += 30;
      if (duration[5] != null) minutes += thaiNumberValue(duration[5]!);
    } else {
      minutes = thaiNumberValue(duration[6]!);
    }
    // Estimates move in 5-minute steps.
    minutes = (minutes / 5).round() * 5;
    if (minutes < 5) minutes = 5;
    text = _cut(text, duration.start, duration.end);
  }

  // A due date is a day phrase said with "ส่ง", before or after it.
  DateTime? due;
  for (final day in findThaiDates(text, now)) {
    final before = text.substring(0, day.from);
    final sentBefore = RegExp(r'(?:กำหนด)?ส่ง\s*(?:วัน)?\s*$')
        .firstMatch(before);
    final sentAfter = _sentWord.matchAsPrefix(
      text,
      day.to + (text.substring(day.to).startsWith(' ') ? 1 : 0),
    );
    if (sentBefore == null && sentAfter == null) continue;
    due = day.date;
    text = _cut(text, sentBefore?.start ?? day.from, sentAfter?.end ?? day.to);
    break;
  }

  final title = text
      .replaceAll(_filler, ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  return ParsedTask(
    title: title,
    minutes: minutes,
    due: due,
    kind: guessTaskKind(title),
  );
}

EveningTaskKind guessTaskKind(String title) {
  if (title.contains('สอบ')) return EveningTaskKind.examStudy;
  if (title.contains('การบ้าน') || title.contains('ใบงาน')) {
    return EveningTaskKind.homework;
  }
  return title.startsWith('อ่าน')
      ? EveningTaskKind.reading
      : EveningTaskKind.other;
}

String _cut(String text, int from, int to) =>
    '${text.substring(0, from)} ${text.substring(to)}'
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
