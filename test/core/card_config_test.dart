import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/card_config.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/economy_config.dart';

void main() {
  test('every decoration and color id is different', () {
    final ids = [
      for (final decor in allCardDecor) decor.id,
      ...cardAvatars.keys,
      for (final color in EconomyConfig.blankets) color.id,
      for (final color in EconomyConfig.fireLevelRewardBlankets.values)
        color.id,
      EconomyConfig.examPeriodRewardBlanket.id,
    ];
    expect(ids.toSet().length, ids.length);
  });

  test('the starting logo and frame are free', () {
    expect(cardDecorById(defaultLogoId)!.isFree, isTrue);
    expect(cardDecorById(defaultFrameId)!.isFree, isTrue);
    expect(cardAvatars, contains(defaultAvatarId));
  });

  test('saved stickers drop unknown ids, repeats and extras', () {
    expect(parseStickerIds(''), isEmpty);
    expect(
      parseStickerIds('sticker_moon,gone,logo_star,sticker_moon,sticker_zzz'),
      ['sticker_moon', 'sticker_zzz'],
    );
    expect(
      parseStickerIds('sticker_star,sticker_moon,sticker_cloud,sticker_heart'),
      ['sticker_star', 'sticker_moon', 'sticker_cloud'],
    );
  });

  test('a sticker goes on, comes off, and a full card drops the oldest', () {
    expect(toggleSticker([], 'a'), ['a']);
    expect(toggleSticker(['a', 'b'], 'a'), ['b']);
    expect(toggleSticker(['a', 'b', 'c'], 'd'), ['b', 'c', 'd']);
  });

  test('the avatar looks rested or sleepy, never sad', () {
    expect(avatarMoodFor(null), AvatarMood.calm);
    expect(avatarMoodFor(CheckInResult.enough), AvatarMood.rested);
    expect(avatarMoodFor(CheckInResult.over), AvatarMood.rested);
    expect(avatarMoodFor(CheckInResult.almostEnough), AvatarMood.sleepy);
    expect(avatarMoodFor(CheckInResult.notEnough), AvatarMood.sleepy);
    expect(AvatarMood.values, hasLength(3));
  });
}
