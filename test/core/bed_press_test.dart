import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/bed_press.dart';

void main() {
  // Sunday evening 20:50 reminder, Monday 06:35 wake.
  final notify = DateTime(2026, 11, 22, 20, 50);
  final wake = DateTime(2026, 11, 23, 6, 35);

  bool press(DateTime now) =>
      canPressInBed(now: now, notifyTime: notify, plannedWakeTime: wake);

  test('opens 2 hours before the put-the-phone-down reminder', () {
    expect(press(DateTime(2026, 11, 22, 18, 49)), isFalse);
    expect(press(DateTime(2026, 11, 22, 18, 50)), isTrue);
  });

  test('pressing late, even after midnight, is never blocked', () {
    expect(press(DateTime(2026, 11, 23, 1, 30)), isTrue);
    expect(press(DateTime(2026, 11, 23, 4, 35)), isTrue);
  });

  test('closes 2 hours before the planned wake time', () {
    expect(press(DateTime(2026, 11, 23, 4, 36)), isFalse);
  });

  test('can be undone for 15 minutes, then not', () {
    final at = DateTime(2026, 11, 22, 21, 50);
    bool undo(int minutes) => canUndoInBed(
      pressedAt: at,
      now: at.add(Duration(minutes: minutes)),
    );
    expect(undo(0), isTrue);
    expect(undo(15), isTrue);
    expect(undo(16), isFalse);
  });
}
