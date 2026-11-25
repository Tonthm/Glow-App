import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/evening_planner.dart';
import 'package:glow/core/quests.dart';
import 'package:glow/core/widget_content.dart';

DateTime at(int hour, [int minute = 0]) => DateTime(2026, 11, 23, hour, minute);

WidgetNight night({DateTime? pressedAt, bool checkedIn = false}) => WidgetNight(
  bedtime: at(21, 50),
  wakeTime: DateTime(2026, 11, 24, 6, 35),
  pressedAt: pressedAt,
  checkedIn: checkedIn,
);

WidgetContent build({
  WidgetNight? tonight,
  List<EveningBlock> blocks = const [],
  DateTime? now,
  int passed = 3,
  QuestMode mode = QuestMode.normal,
  int fire = 2,
}) => buildWidgetContent(
  now: now ?? at(19),
  tonight: tonight,
  eveningBlocks: blocks,
  weeklyPassCount: passed,
  mode: mode,
  fireLevel: fire,
);

EveningBlock block(String title, DateTime from, DateTime to) =>
    EveningBlock(kind: BlockKind.task, start: from, end: to, title: title);

void main() {
  test('before the press: bedtime and wake time', () {
    final content = build(tonight: night());
    expect(content.headline, 'เข้านอน 21:50');
    expect(content.subtitle, 'ตื่น 06:35');
  });

  test('after the press: good night with the wake time', () {
    final content = build(tonight: night(pressedAt: at(21, 40)));
    expect(content.headline, 'ฝันดี');
    expect(content.subtitle, 'ตื่น 06:35');
    expect(content.nowLine, isEmpty);
  });

  test('after check-in the night shown is the next one', () {
    final content = build(tonight: night(checkedIn: false));
    expect(content.headline, startsWith('เข้านอน'));
    // A night that has been checked in is over: no more "ฝันดี".
    final done = build(tonight: night(pressedAt: at(21), checkedIn: true));
    expect(done.headline, 'เช็กอินแล้ว');
  });

  test('no plan yet asks to open the app', () {
    final content = build(tonight: null);
    expect(content.headline, 'เปิด Glow');
    expect(content.dots, isEmpty);
  });

  test('weekly progress dots, capped at five', () {
    expect(build(tonight: night()).dots, '●●●○○ 3/5');
    expect(build(tonight: night(), passed: 7).dots, '●●●●● 5/5');
  });

  test('the night mode is named', () {
    expect(build(tonight: night()).modeLine, 'โหมดปกติ');
    expect(
      build(tonight: night(), mode: QuestMode.minimum).modeLine,
      'โหมดขั้นต่ำ',
    );
  });

  test('the current and next evening blocks', () {
    final content = build(
      tonight: night(),
      now: at(19, 10),
      blocks: [
        block('พัก', at(18), at(18, 30)),
        block('การบ้านเลข', at(19), at(19, 40)),
        block('อาบน้ำ', at(20), at(20, 20)),
      ],
    );
    expect(content.nowLine, 'ตอนนี้: การบ้านเลข ถึง 19:40');
    expect(content.nextLine, 'ถัดไป 20:00: อาบน้ำ');
  });

  test('between blocks only the next one is shown', () {
    final content = build(
      tonight: night(),
      now: at(19, 50),
      blocks: [block('อาบน้ำ', at(20), at(20, 20))],
    );
    expect(content.nowLine, isEmpty);
    expect(content.nextLine, 'ถัดไป 20:00: อาบน้ำ');
  });
}
