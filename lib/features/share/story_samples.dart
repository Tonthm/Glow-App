/// Made-up nights for checking the shared picture by eye. Only the debug
/// gallery and the tests use them; nothing here touches the database.
library;

import '../../core/check_in.dart';
import '../../core/sleep_calculator.dart';
import '../../core/story_share.dart';

/// The target the made-up verdicts are judged against.
const _target = SleepSettings(targetMinMinutes: 480, targetMaxMinutes: 600);

/// Hours slept in minutes, for each kind of night.
const int _full = 495;
const int _slightly = 440;
const int _short = 335;

enum StorySample {
  allFullWeek('7 คืนครบทั้งหมด'),
  allShortWeek('7 คืนแดงทั้งหมด'),
  mixedWeek('ผสมสี มีคืนไม่มีข้อมูล'),
  mixedMonth('30 คืนผสม'),
  acrossMidnight('เข้านอนข้ามเที่ยงคืน');

  final String label;
  const StorySample(this.label);

  /// The nights ending on [now]'s date.
  List<StoryNight> nights(DateTime now) {
    StoryNight? make(int ago, int? slept, {int wakeMinutes = 6 * 60 + 30}) {
      if (slept == null) return null;
      final date = DateTime(now.year, now.month, now.day - ago);
      final wake = DateTime(
        date.year,
        date.month,
        date.day,
        0,
        wakeMinutes,
      );
      final lightsOff = DateTime(
        date.year,
        date.month,
        date.day,
        0,
        wakeMinutes - slept - 15,
      );
      final outcome = classifyCheckIn(
        lightsOffAt: lightsOff,
        actualWakeAt: wake,
        plannedBedtime: lightsOff,
        settings: _target,
        pressedInBed: true,
      );
      return StoryNight(
        wakeDate: date,
        lightsOffAt: lightsOff,
        wakeAt: wake,
        result: outcome.result,
      );
    }

    // Newest first.
    const mixed = [_full, _slightly, _full, null, _short, _full, _slightly];
    final made = switch (this) {
      allFullWeek => [for (var i = 0; i < 7; i++) make(i, _full + i * 4)],
      allShortWeek => [for (var i = 0; i < 7; i++) make(i, _short - i * 6)],
      mixedWeek => [for (var i = 0; i < 7; i++) make(i, mixed[i])],
      mixedMonth => [
        for (var i = 0; i < 30; i++)
          make(i, i % 11 == 9 ? null : mixed[(i * 3) % 7]),
      ],
      // Lights off from 23:15 to 00:45.
      acrossMidnight => [
        for (var i = 0; i < 7; i++)
          make(i, _full, wakeMinutes: 8 * 60 + [-15, 75, 0, 60, 15, 45, 30][i]),
      ],
    };
    return made.nonNulls.toList();
  }
}
