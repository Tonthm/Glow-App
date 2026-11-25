/// What the home screen widgets show (CLAUDE.md section 15). Clock times
/// only, no countdowns: Android limits how often a widget can update.
library;

import 'evening_planner.dart';
import 'quests.dart';

class WidgetNight {
  final DateTime bedtime;
  final DateTime wakeTime;
  final DateTime? pressedAt;
  final bool checkedIn;

  const WidgetNight({
    required this.bedtime,
    required this.wakeTime,
    this.pressedAt,
    this.checkedIn = false,
  });
}

class WidgetContent {
  final String headline;
  final String subtitle;
  final String dots;
  final String modeLine;
  final String nowLine;
  final String nextLine;
  final int fireLevel;

  const WidgetContent({
    required this.headline,
    required this.subtitle,
    this.dots = '',
    this.modeLine = '',
    this.nowLine = '',
    this.nextLine = '',
    this.fireLevel = 0,
  });

  Map<String, String> toMap() => {
    'headline': headline,
    'subtitle': subtitle,
    'dots': dots,
    'mode': modeLine,
    'now': nowLine,
    'next': nextLine,
    'fire': '$fireLevel',
  };
}

String _clock(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:'
    '${t.minute.toString().padLeft(2, '0')}';

const _modeNames = {
  QuestMode.normal: 'โหมดปกติ',
  QuestMode.light: 'โหมดเบา',
  QuestMode.minimum: 'โหมดขั้นต่ำ',
};

WidgetContent buildWidgetContent({
  required DateTime now,
  required WidgetNight? tonight,
  required List<EveningBlock> eveningBlocks,
  required int weeklyPassCount,
  required QuestMode mode,
  required int fireLevel,
}) {
  if (tonight == null) {
    return WidgetContent(
      headline: 'เปิด Glow',
      subtitle: 'เพื่อดูเวลานอน',
      fireLevel: fireLevel,
    );
  }
  final passed = weeklyPassCount.clamp(0, weeklyQuestTarget);
  final dots =
      '${'●' * passed}${'○' * (weeklyQuestTarget - passed)} '
      '$passed/$weeklyQuestTarget';
  final asleep = tonight.pressedAt != null;

  var nowLine = '';
  var nextLine = '';
  if (!asleep) {
    for (final block in eveningBlocks) {
      if (!block.start.isAfter(now) && block.end.isAfter(now)) {
        nowLine = 'ตอนนี้: ${block.title} ถึง ${_clock(block.end)}';
      } else if (block.start.isAfter(now)) {
        nextLine = 'ถัดไป ${_clock(block.start)}: ${block.title}';
        break;
      }
    }
  }

  return WidgetContent(
    headline: tonight.checkedIn
        ? 'เช็กอินแล้ว'
        : asleep
        ? 'ฝันดี'
        : 'เข้านอน ${_clock(tonight.bedtime)}',
    subtitle: 'ตื่น ${_clock(tonight.wakeTime)}',
    dots: dots,
    modeLine: _modeNames[mode]!,
    nowLine: nowLine,
    nextLine: nextLine,
    fireLevel: fireLevel,
  );
}
