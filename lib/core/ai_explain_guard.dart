/// Checks text written by the AI before the user sees it (CLAUDE.md section
/// 16). Anything that fails is dropped; it is never edited into shape.
library;

import 'thai_schedule_parser.dart';

const int aiExplanationMaxChars = 300;

/// Nothing the app shows may nudge the user to sleep later or less.
const List<String> aiForbiddenPhrases = [
  'นอนดึก',
  'อดนอน',
  'โต้รุ่ง',
  'เลื่อนเวลานอน',
  'ลดเวลานอน',
  'นอนน้อย',
  'นอนช้า',
  'เข้านอนช้า',
  'เลื่อนเวลาเข้านอน',
  'เลื่อนเวลาวางมือถือ',
  'ไม่ต้องนอน',
  'ถ่างตา',
];

/// True if [text] has a banned phrase, even with spaces slipped inside it.
bool hasForbiddenPhrase(String text) {
  final packed = text.replaceAll(RegExp('[\\s​]+'), '');
  return aiForbiddenPhrases.any(packed.contains);
}

/// Nothing about sleep cycles is ever sent to the AI, so anything it says
/// about them is made up. This includes claims about waking refreshed.
const List<String> aiCyclePhrases = [
  'รอบการนอน',
  'รอบนอน',
  'วงจรการนอน',
  'หลับลึก',
  'ตื่นสดชื่น',
  'ตื่นมาสดชื่น',
  'ตื่นอย่างสดชื่น',
];

final _sleepStageName = RegExp(r'\bn?rem\b', caseSensitive: false);

bool _talksAboutSleepCycles(String text) {
  final packed = text.replaceAll(RegExp(r'\s+'), '');
  return aiCyclePhrases.any(packed.contains) || _sleepStageName.hasMatch(text);
}

const _thaiDigits = '๐๑๒๓๔๕๖๗๘๙';

String _toArabicDigits(String text) {
  var result = text;
  for (var i = 0; i < _thaiDigits.length; i++) {
    result = result.replaceAll(_thaiDigits[i], '$i');
  }
  return result;
}

/// A number spelled out in words right before a unit, e.g. "สี่สิบนาที".
final _spelledAmount = RegExp(
  '($thaiNumberPattern)\\s*(?:นาที|ชั่วโมง|ชม|งาน|ข้อ|หน้า|วัน|โมง|ทุ่ม)',
);

/// Every number in [text]: digits, plus spelled-out amounts.
Set<String> numbersIn(String text) {
  final normalized = _toArabicDigits(text);
  return {
    for (final m in RegExp(r'\d+(?:\.\d+)?').allMatches(normalized)) m[0]!,
    for (final m in _spelledAmount.allMatches(normalized))
      '${thaiNumberValue(m[1]!)}',
  };
}

/// True if [summary] uses only numbers found in [facts], has no banned
/// phrase, and is at most [aiExplanationMaxChars] long.
bool isSafeExplanation(String summary, List<String> facts) {
  final text = summary.trim();
  if (text.isEmpty || text.length > aiExplanationMaxChars) return false;
  if (hasForbiddenPhrase(text) || _talksAboutSleepCycles(text)) return false;
  final allowed = numbersIn(facts.join('\n'));
  return numbersIn(text).every(allowed.contains);
}
