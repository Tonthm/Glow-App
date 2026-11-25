import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/fire.dart';

void main() {
  group('determineFireEffect', () {
    test('a schedule-predicted red night is always unaffected', () {
      for (final result in [
        null,
        CheckInResult.enough,
        CheckInResult.notEnough,
        CheckInResult.over,
      ]) {
        expect(
          determineFireEffect(isRedNightFromSchedule: true, result: result),
          NightFireEffect.unaffected,
        );
      }
    });

    test('enough check-in result increases fire', () {
      expect(
        determineFireEffect(
          isRedNightFromSchedule: false,
          result: CheckInResult.enough,
        ),
        NightFireEffect.enough,
      );
    });

    test('almost-enough and over leave fire unaffected', () {
      expect(
        determineFireEffect(
          isRedNightFromSchedule: false,
          result: CheckInResult.almostEnough,
        ),
        NightFireEffect.unaffected,
      );
      expect(
        determineFireEffect(
          isRedNightFromSchedule: false,
          result: CheckInResult.over,
        ),
        NightFireEffect.unaffected,
      );
    });

    test('not-enough and no check-in both count as missed', () {
      expect(
        determineFireEffect(
          isRedNightFromSchedule: false,
          result: CheckInResult.notEnough,
        ),
        NightFireEffect.missed,
      );
      expect(
        determineFireEffect(isRedNightFromSchedule: false, result: null),
        NightFireEffect.missed,
      );
    });
  });

  group('applyNightFireEffect: climbing every level', () {
    test('points 0 -> 1 -> 3 -> 7 -> 14 -> 30 climb every named level', () {
      var state = FireState.initial;
      final expectedLevelsAtEachPoint = <int, int>{
        1: 1,
        3: 2,
        7: 3,
        14: 4,
        30: 5,
      };
      for (var i = 1; i <= 30; i++) {
        state = applyNightFireEffect(state, NightFireEffect.enough);
        expect(state.points, i);
        if (expectedLevelsAtEachPoint.containsKey(i)) {
          expect(state.level, expectedLevelsAtEachPoint[i]);
        }
      }
      expect(state.level, maxFireLevel);
      expect(state.maxLevelEverReached, maxFireLevel);
      expect(state.currentStreak, 30);
      expect(state.longestStreak, 30);
    });
  });

  group('applyNightFireEffect: dropping from each level', () {
    test('dropping without a shield resets to the previous level\'s floor', () {
      final cases = <int, int>{
        1: 0, // ประกาย -> ถ่าน
        3: 1, // เปลวเล็ก -> ประกาย
        7: 3, // ไฟลุก -> เปลวเล็ก
        14: 7, // ไฟโชน -> ไฟลุก
        30: 14, // ไฟสีฟ้า -> ไฟโชน
      };
      for (final entry in cases.entries) {
        final startPoints = entry.key;
        final expectedPoints = entry.value;
        var state = FireState(
          points: startPoints,
          level: fireLevelForPoints(startPoints),
          shields: 0,
          maxLevelEverReached: fireLevelForPoints(startPoints),
          currentStreak: 5,
          longestStreak: 5,
        );
        state = applyNightFireEffect(state, NightFireEffect.missed);
        expect(
          state.points,
          expectedPoints,
          reason: 'dropping from $startPoints points',
        );
        expect(state.level, fireLevelForPoints(expectedPoints));
        expect(state.currentStreak, 0);
        expect(state.maxLevelEverReached, fireLevelForPoints(startPoints));
      }
    });

    test('dropping from level 0 (ถ่าน) stays at level 0', () {
      final state = applyNightFireEffect(
        FireState.initial,
        NightFireEffect.missed,
      );
      expect(state.level, 0);
      expect(state.points, 0);
    });
  });

  group('shields', () {
    test(
      'a missed night with a shield held consumes it instead of dropping',
      () {
        var state = FireState.initial.copyWith(
          points: 7,
          level: 3,
          shields: 1,
          currentStreak: 5,
        );
        state = applyNightFireEffect(state, NightFireEffect.missed);
        expect(state.shields, 0);
        expect(state.level, 3);
        expect(state.points, 7);
        expect(
          state.currentStreak,
          5,
        ); // streak untouched when shield absorbs it
      },
    );

    test('using a shield twice in one week drains down to a real drop', () {
      var state = FireState.initial.copyWith(points: 7, level: 3, shields: 2);
      state = applyNightFireEffect(state, NightFireEffect.missed);
      expect(state.shields, 1);
      expect(state.level, 3); // still protected
      state = applyNightFireEffect(state, NightFireEffect.missed);
      expect(state.shields, 0);
      expect(state.level, 3); // second shield absorbs this miss too
      state = applyNightFireEffect(state, NightFireEffect.missed);
      expect(state.shields, 0);
      expect(state.level, 2); // out of shields, now it actually drops
      expect(state.points, fireLevelThresholds[2]);
    });

    test('free Monday shield is capped at maxShields', () {
      var state = FireState.initial.copyWith(shields: maxShields);
      state = grantFreeShield(state);
      expect(state.shields, maxShields);

      state = FireState.initial.copyWith(shields: maxShields - 1);
      state = grantFreeShield(state);
      expect(state.shields, maxShields);
    });

    test('buying a shield fails once at the cap', () {
      final full = FireState.initial.copyWith(shields: maxShields);
      expect(buyShield(full), isNull);

      final notFull = FireState.initial.copyWith(shields: maxShields - 1);
      expect(buyShield(notFull)!.shields, maxShields);
    });
  });

  group('no check-in past the window', () {
    test('is treated the same as a not-enough check-in for fire purposes', () {
      expect(
        determineFireEffect(isRedNightFromSchedule: false, result: null),
        determineFireEffect(
          isRedNightFromSchedule: false,
          result: CheckInResult.notEnough,
        ),
      );
    });
  });
}
