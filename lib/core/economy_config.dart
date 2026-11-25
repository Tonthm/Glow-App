/// Single place for every coin price and reward amount in the game economy
/// (CLAUDE.md section 9: "ราคาเป็นค่าเริ่มต้น เก็บไว้ในไฟล์ config ที่เดียว
/// จะได้ปรับง่าย"), extended to cover quest rewards (section 8) too so
/// there's exactly one file to tune the whole economy from.
class EconomyConfig {
  // Section 6: every check-in, regardless of result.
  static const int checkInCoins = 5;

  // Section 8: quests.
  static const int dailyCompleteCoins = 10;
  static const int dailyOnTimeBonusCoins = 5;
  static const int weeklyOnTimeQuestCoins = 50;
  static const int preExamNightCoins = 30;

  // Section 9: shop.
  static const int shieldPriceCoins = 80;

  /// 15 blanket colors, cheapest to priciest (section 9: "ประมาณ 15–20 สี
  /// ไล่ราคาจากถูกไปแพง"). id is a stable key (used for ownership rows and
  /// theming), colorValue is the ARGB swatch shown in the shop/room.
  static const List<BlanketConfig> blankets = [
    BlanketConfig('blanket_dawn_pink', 0xFFF6C9D0, 60),
    BlanketConfig('blanket_sand', 0xFFE8D5B5, 60),
    BlanketConfig('blanket_sage', 0xFFB8CDB0, 65),
    BlanketConfig('blanket_sky', 0xFFAFD4E8, 70),
    BlanketConfig('blanket_lilac', 0xFFCBB8E8, 75),
    BlanketConfig('blanket_coral', 0xFFF2A8A0, 80),
    BlanketConfig('blanket_butter', 0xFFF0DD9A, 85),
    BlanketConfig('blanket_mint', 0xFF9FDCC8, 90),
    BlanketConfig('blanket_periwinkle', 0xFF9FB0E8, 95),
    BlanketConfig('blanket_terracotta', 0xFFD88A6E, 100),
    BlanketConfig('blanket_plum', 0xFF9B6B96, 110),
    BlanketConfig('blanket_forest', 0xFF4F7A61, 120),
    BlanketConfig('blanket_navy', 0xFF3B4C7A, 130),
    BlanketConfig('blanket_charcoal', 0xFF4A4A4A, 140),
    BlanketConfig('blanket_gold', 0xFFD4AF37, 150),
  ];

  /// Granted once, the first time fire ever reaches level 1..5 — not sold
  /// in the shop (section 9: "สีผ้าห่มพิเศษ...จากการถึงระดับไฟใหม่ครั้งแรก").
  static const Map<int, BlanketConfig> fireLevelRewardBlankets = {
    1: BlanketConfig('blanket_spark', 0xFFFFE08A, 0),
    2: BlanketConfig('blanket_ember', 0xFFFFB07A, 0),
    3: BlanketConfig('blanket_flame', 0xFFFF8A5C, 0),
    4: BlanketConfig('blanket_blaze', 0xFFFF6A3D, 0),
    5: BlanketConfig('blanket_blue_flame', 0xFF6AB0FF, 0),
  };

  /// Granted once per exam period on "ครบทุกคืนก่อนสอบ" (section 8) — also
  /// not sold.
  static const BlanketConfig examPeriodRewardBlanket = BlanketConfig(
    'blanket_exam_star',
    0xFFFFFFFF,
    0,
  );
}

class BlanketConfig {
  final String id;
  final int colorValue;
  final int priceCoins;

  const BlanketConfig(this.id, this.colorValue, this.priceCoins);
}
