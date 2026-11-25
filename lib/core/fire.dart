import 'check_in.dart';

/// Fire levels per CLAUDE.md section 7, index = level, value = points
/// required to be *at* that level ("แต้มไฟที่ต้องมี").
const List<int> fireLevelThresholds = [0, 1, 3, 7, 14, 30];

const List<String> fireLevelNames = [
  'ถ่าน',
  'ประกาย',
  'เปลวเล็ก',
  'ไฟลุก',
  'ไฟโชน',
  'ไฟสีฟ้า',
];

const int maxFireLevel = 5;
const int maxShields = 2;

int fireLevelForPoints(int points) {
  var level = 0;
  for (var i = 0; i < fireLevelThresholds.length; i++) {
    if (points >= fireLevelThresholds[i]) level = i;
  }
  return level;
}

class FireState {
  final int points;
  final int level;
  final int shields;
  final int maxLevelEverReached;
  final int currentStreak;
  final int longestStreak;

  const FireState({
    required this.points,
    required this.level,
    required this.shields,
    required this.maxLevelEverReached,
    required this.currentStreak,
    required this.longestStreak,
  });

  static const initial = FireState(
    points: 0,
    level: 0,
    shields: 0,
    maxLevelEverReached: 0,
    currentStreak: 0,
    longestStreak: 0,
  );

  FireState copyWith({
    int? points,
    int? level,
    int? shields,
    int? maxLevelEverReached,
    int? currentStreak,
    int? longestStreak,
  }) {
    return FireState(
      points: points ?? this.points,
      level: level ?? this.level,
      shields: shields ?? this.shields,
      maxLevelEverReached: maxLevelEverReached ?? this.maxLevelEverReached,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}

/// How one night's check-in (or lack of it) affects fire, per section 7's
/// outcome table — already collapsed to the 3 effects fire cares about.
enum NightFireEffect { enough, unaffected, missed }

/// Maps a night's check-in result (or null if no check-in happened) to its
/// fire effect, per CLAUDE.md sections 6-7. A night the app flagged red
/// ahead of time from the schedule is always unaffected, regardless of the
/// actual check-in ("ไม่ลดไฟและไม่เพิ่มไฟ") — checked before [result].
NightFireEffect determineFireEffect({
  required bool isRedNightFromSchedule,
  required CheckInResult? result,
}) {
  if (isRedNightFromSchedule) return NightFireEffect.unaffected;
  if (result == null) return NightFireEffect.missed;
  switch (result) {
    case CheckInResult.enough:
      return NightFireEffect.enough;
    case CheckInResult.almostEnough:
    case CheckInResult.over:
      return NightFireEffect.unaffected;
    case CheckInResult.notEnough:
      return NightFireEffect.missed;
  }
}

/// Applies one night's [effect] to [state], per section 7:
/// - enough: +1 point, streak +1, level/max-level recomputed
/// - unaffected: no change (เกือบครบ/เกิน/red-from-schedule)
/// - missed with a shield held: shield auto-consumed, nothing else changes
/// - missed with no shield: drop one level, points reset to that level's
///   threshold, streak resets to 0
FireState applyNightFireEffect(FireState state, NightFireEffect effect) {
  switch (effect) {
    case NightFireEffect.enough:
      final newPoints = state.points + 1;
      final newLevel = fireLevelForPoints(newPoints);
      final newStreak = state.currentStreak + 1;
      return state.copyWith(
        points: newPoints,
        level: newLevel,
        maxLevelEverReached: newLevel > state.maxLevelEverReached
            ? newLevel
            : state.maxLevelEverReached,
        currentStreak: newStreak,
        longestStreak: newStreak > state.longestStreak
            ? newStreak
            : state.longestStreak,
      );
    case NightFireEffect.unaffected:
      return state;
    case NightFireEffect.missed:
      if (state.shields > 0) {
        return state.copyWith(shields: state.shields - 1);
      }
      final newLevel = state.level == 0 ? 0 : state.level - 1;
      return state.copyWith(
        level: newLevel,
        points: fireLevelThresholds[newLevel],
        currentStreak: 0,
      );
  }
}

/// Grants the free Monday shield (section 7), capped at [maxShields] held.
FireState grantFreeShield(FireState state) {
  if (state.shields >= maxShields) return state;
  return state.copyWith(shields: state.shields + 1);
}

/// Buys one extra shield with coins (section 7's 1-per-week purchase cap is
/// enforced by the caller/wallet, not here). Returns null if already full.
FireState? buyShield(FireState state) {
  if (state.shields >= maxShields) return null;
  return state.copyWith(shields: state.shields + 1);
}
