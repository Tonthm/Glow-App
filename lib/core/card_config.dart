/// The student card: what can be put on it, what it costs, and how the
/// avatar's face follows the latest night. Card colors are the blankets in
/// economy_config.dart, so everything bought before the card still counts.
library;

import 'check_in.dart';

enum CardDecorKind { logo, frame, sticker }

class CardDecor {
  /// Stable: saved in OwnedItems and on the card.
  final String id;
  final CardDecorKind kind;
  final String name;

  /// 0 means everyone has it.
  final int priceCoins;

  const CardDecor(this.id, this.kind, this.name, this.priceCoins);

  bool get isFree => priceCoins == 0;
}

const String defaultLogoId = 'logo_moon';
const String defaultFrameId = 'frame_plain';
const String defaultAvatarId = 'avatar_cloud';

const List<CardDecor> cardLogos = [
  CardDecor(defaultLogoId, CardDecorKind.logo, 'พระจันทร์', 0),
  CardDecor('logo_star', CardDecorKind.logo, 'ดาว', 0),
  CardDecor('logo_cloud', CardDecorKind.logo, 'เมฆ', 0),
  CardDecor('logo_comet', CardDecorKind.logo, 'ดาวหาง', 60),
  CardDecor('logo_planet', CardDecorKind.logo, 'ดาวเคราะห์', 80),
  CardDecor('logo_sparkles', CardDecorKind.logo, 'ประกายดาว', 100),
];

const List<CardDecor> cardFrames = [
  CardDecor(defaultFrameId, CardDecorKind.frame, 'เส้นเรียบ', 0),
  CardDecor('frame_double', CardDecorKind.frame, 'เส้นคู่', 70),
  CardDecor('frame_dots', CardDecorKind.frame, 'จุดไข่ปลา', 90),
  CardDecor('frame_stars', CardDecorKind.frame, 'มุมดาว', 120),
];

const List<CardDecor> cardStickers = [
  CardDecor('sticker_star', CardDecorKind.sticker, 'ดาวยิ้ม', 40),
  CardDecor('sticker_moon', CardDecorKind.sticker, 'จันทร์เสี้ยว', 40),
  CardDecor('sticker_cloud', CardDecorKind.sticker, 'เมฆนุ่ม', 50),
  CardDecor('sticker_heart', CardDecorKind.sticker, 'หัวใจ', 50),
  CardDecor('sticker_zzz', CardDecorKind.sticker, 'งีบ', 60),
  CardDecor('sticker_comet', CardDecorKind.sticker, 'ดาวหาง', 70),
];

const List<CardDecor> allCardDecor = [
  ...cardLogos,
  ...cardFrames,
  ...cardStickers,
];

CardDecor? cardDecorById(String id) {
  for (final decor in allCardDecor) {
    if (decor.id == id) return decor;
  }
  return null;
}

/// All avatars are free.
const Map<String, String> cardAvatars = {
  defaultAvatarId: 'เมฆ',
  'avatar_moon': 'พระจันทร์',
  'avatar_star': 'ดาว',
  'avatar_planet': 'ดาวเคราะห์',
};

const int maxCardStickers = 3;

const int maxCardNameLength = 24;
const int maxCardSchoolLength = 32;
const int maxCardClassLength = 12;

/// The saved list of stickers on the card. Unknown ids and repeats are
/// dropped.
List<String> parseStickerIds(String saved) {
  final result = <String>[];
  for (final id in saved.split(',')) {
    if (result.length == maxCardStickers) break;
    if (cardDecorById(id)?.kind == CardDecorKind.sticker &&
        !result.contains(id)) {
      result.add(id);
    }
  }
  return result;
}

String encodeStickerIds(List<String> ids) => ids.join(',');

/// Puts [id] on the card, or takes it off. A full card replaces its oldest
/// sticker.
List<String> toggleSticker(List<String> current, String id) {
  if (current.contains(id)) {
    return [
      for (final other in current)
        if (other != id) other,
    ];
  }
  final result = [...current, id];
  return result.length > maxCardStickers
      ? result.sublist(result.length - maxCardStickers)
      : result;
}

/// The avatar's face. There is deliberately no sad face: a short night just
/// looks sleepy (CLAUDE.md section 9).
enum AvatarMood { calm, rested, sleepy }

/// [latest] is the result of the most recent check-in, null before the first.
AvatarMood avatarMoodFor(CheckInResult? latest) => switch (latest) {
  null => AvatarMood.calm,
  CheckInResult.enough || CheckInResult.over => AvatarMood.rested,
  CheckInResult.almostEnough || CheckInResult.notEnough => AvatarMood.sleepy,
};
