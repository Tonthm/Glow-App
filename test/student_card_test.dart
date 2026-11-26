import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/card_config.dart';
import 'package:glow/core/economy_config.dart';
import 'package:glow/data/database.dart';
import 'package:glow/features/card/my_card.dart';
import 'package:glow/features/room/blanket_color.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:glow/theme/widgets/student_card.dart';
import 'package:material_ui/material_ui.dart';

const _profile = CardProfileRow(
  id: 0,
  displayName: 'ชื่อจริงของฉัน',
  school: 'โรงเรียนของฉัน',
  classYear: 'ม.5',
  avatarId: 'avatar_moon',
  logoId: 'logo_planet',
  frameId: 'frame_stars',
  stickerIds: 'sticker_star,sticker_zzz,sticker_heart',
);

StudentCard _card({bool showDetails = true, String? color}) => studentCardFrom(
  profile: _profile,
  equippedColorId: color,
  fireLevel: 3,
  firePoints: 9,
  mood: AvatarMood.rested,
  showDetails: showDetails,
);

void main() {
  test('words are readable on every card color', () {
    final colors = [
      const Color(defaultBlanketColor),
      for (final c in EconomyConfig.blankets) Color(c.colorValue),
      for (final c in EconomyConfig.fireLevelRewardBlankets.values)
        Color(c.colorValue),
      Color(EconomyConfig.examPeriodRewardBlanket.colorValue),
    ];
    for (final color in colors) {
      final a = cardTextColor(color).computeLuminance();
      final b = color.computeLuminance();
      final contrast = (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
      expect(contrast, greaterThanOrEqualTo(4.5), reason: '$color');
    }
  });

  test('a card without details carries nothing personal', () {
    final card = _card(showDetails: false);
    expect(card.name, '');
    expect(card.school, '');
    expect(card.classYear, '');
    // The decorations stay.
    expect(card.logoId, 'logo_planet');
    expect(card.stickerIds, hasLength(3));
  });

  // The smallest phone width the app is tested on, then a wider one. A layout
  // that doesn't fit fails the test.
  for (final width in [288.0, 400.0]) {
    testWidgets('a full card fits at $width wide, with big phone text', (
      tester,
    ) async {
      for (final theme in [GlowAppTheme.light(), GlowAppTheme.dark()]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
              child: Center(
                child: SizedBox(width: width, child: _card()),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('ชื่อจริงของฉัน'), findsOneWidget);
        expect(find.textContaining('9 แต้ม'), findsOneWidget);
      }
    });
  }
}
