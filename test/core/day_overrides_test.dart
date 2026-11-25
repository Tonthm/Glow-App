import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/day_overrides.dart';
import 'package:glow/core/sleep_calculator.dart';

const base = SleepSettings(targetMinMinutes: 480, targetMaxMinutes: 600);
final monday = DateTime(2026, 11, 23);

void main() {
  test('travel time can differ by weekday', () {
    final overrides = {DateTime.monday: 60};
    expect(settingsFor(base, monday, overrides).travelMinutes, 60);
    expect(
      settingsFor(base, DateTime(2026, 11, 24), overrides).travelMinutes,
      base.travelMinutes,
    );
  });

  test('a shorter prep time applies to that night only', () {
    final changed = settingsFor(base, monday, const {}, prepOverride: 20);
    expect(changed.prepMinutes, 20);
    expect(changed.travelMinutes, base.travelMinutes);
    expect(settingsFor(base, monday, const {}).prepMinutes, base.prepMinutes);
  });

  test('overrides survive being saved as text', () {
    const overrides = {1: 60, 5: 0};
    expect(parseTravelOverrides(encodeTravelOverrides(overrides)), overrides);
    expect(parseTravelOverrides(''), isEmpty);
  });

  test('damaged text is ignored rather than crashing', () {
    expect(parseTravelOverrides('x,9:10,2:abc,3:25'), {3: 25});
  });
}
