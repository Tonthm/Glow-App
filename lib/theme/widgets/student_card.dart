import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../../core/card_config.dart';
import '../../core/fire.dart';
import '../tokens.dart';
import 'card_art.dart';

/// The size the card is laid out at; it scales to the space it gets.
const Size studentCardSize = Size(344, 190);

/// Black or white, whichever reads better on [background].
Color cardTextColor(Color background) {
  final luminance = background.computeLuminance();
  final onWhiteText = 1.05 / (luminance + 0.05);
  final onBlackText = (luminance + 0.05) / 0.05;
  return onBlackText >= onWhiteText
      ? GlowCardArtColors.black
      : GlowCardArtColors.white;
}

/// Glow's student card, the face of the home screen: who it belongs to, the
/// decorations bought with coins, the fire as stamps, and an avatar that
/// looks rested or sleepy after the latest night.
///
/// Purely visual: everything it shows is passed in.
class StudentCard extends StatelessWidget {
  final Color color;
  final String name;
  final String school;
  final String classYear;
  final String avatarId;
  final String logoId;
  final String frameId;
  final List<String> stickerIds;
  final AvatarMood mood;
  final int fireLevel;
  final int firePoints;

  /// The user's picture, shown instead of the avatar.
  final Uint8List? photo;

  /// Shows an empty line for each detail not filled in yet, on the user's own
  /// card. A shared picture leaves them out.
  final bool showBlanks;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.color,
    this.name = '',
    this.school = '',
    this.classYear = '',
    this.avatarId = defaultAvatarId,
    this.logoId = defaultLogoId,
    this.frameId = defaultFrameId,
    this.stickerIds = const [],
    this.mood = AvatarMood.calm,
    required this.fireLevel,
    required this.firePoints,
    this.photo,
    this.showBlanks = false,
    this.onTap,
  });

  static const _stickerSpots = [
    (right: 14.0, top: 46.0, turn: 0.18),
    (right: 52.0, top: 72.0, turn: -0.14),
    (right: 14.0, top: 96.0, turn: 0.06),
  ];

  @override
  Widget build(BuildContext context) {
    final ink = cardTextColor(color);
    final level = fireLevel.clamp(0, maxFireLevel);
    final moodWords = switch (photo == null ? mood : AvatarMood.calm) {
      AvatarMood.calm => '',
      AvatarMood.rested => ' อวตารดูสดชื่น',
      AvatarMood.sleepy => ' อวตารดูง่วงนิดหน่อย',
    };
    TextStyle text(double size, {bool bold = false}) => TextStyle(
      fontFamily: 'IBMPlexSansThai',
      fontFamilyFallback: const ['Nunito'],
      fontSize: size,
      height: 1.4,
      fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
      color: ink,
    );
    Widget line(String value, TextStyle style) =>
        Text(value, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);

    final shownName = name.isNotEmpty
        ? name
        : showBlanks
        ? 'ชื่อ ........'
        : 'บัตรของฉัน';
    // Room on the right so stickers don't cover the words.
    final stickerRoom = switch (stickerIds.length) {
      0 => 0.0,
      1 => 38.0,
      _ => 76.0,
    };

    final face = Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: CardFramePainter(frameId, ink)),
        ),
        Padding(
          padding: const EdgeInsets.all(GlowSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CardLogo(logoId),
                  const SizedBox(width: GlowSpacing.sm),
                  Text(
                    'Glow',
                    style: text(20, bold: true).copyWith(fontFamily: 'Fredoka'),
                  ),
                  const Spacer(),
                  Text('บัตรนักเรียน', style: text(GlowFontSize.tiny)),
                  const SizedBox(width: GlowSpacing.sm),
                ],
              ),
              Row(
                children: [
                  if (photo == null)
                    CardAvatar(avatarId, mood: mood)
                  else
                    Container(
                      width: 60,
                      height: 75,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(GlowRadius.button),
                      ),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(GlowRadius.button),
                        border: Border.all(color: ink),
                      ),
                      child: Image.memory(
                        photo!,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                  const SizedBox(width: GlowSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: stickerRoom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          line(shownName, text(20, bold: true)),
                          if (school.isNotEmpty || showBlanks)
                            line(
                              school.isEmpty ? 'โรงเรียน ........' : school,
                              text(GlowFontSize.tiny),
                            ),
                          if (classYear.isNotEmpty || showBlanks)
                            line(
                              classYear.isEmpty ? 'ชั้นปี ........' : classYear,
                              text(GlowFontSize.tiny),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  for (var i = 0; i < maxFireLevel; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: GlowSpacing.xs),
                      child: Transform.rotate(
                        // A stamp is never pressed perfectly straight.
                        angle: i.isEven ? -0.12 : 0.1,
                        child: CustomPaint(
                          size: const Size.square(22),
                          painter: FireStampPainter(
                            stamped: i < level,
                            empty: ink,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: GlowSpacing.xs),
                  Expanded(
                    child: Text(
                      '${fireLevelNames[level]}\n$firePoints แต้ม',
                      style: text(GlowFontSize.tiny, bold: true),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        for (var i = 0; i < stickerIds.length && i < maxCardStickers; i++)
          Positioned(
            right: _stickerSpots[i].right,
            top: _stickerSpots[i].top,
            child: Transform.rotate(
              angle: _stickerSpots[i].turn,
              child: CardSticker(stickerIds[i]),
            ),
          ),
      ],
    );

    return Semantics(
      label:
          'บัตรนักเรียน $shownName ไฟ ${fireLevelNames[level]} '
          '$firePoints แต้ม$moodWords',
      button: onTap != null,
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: studentCardSize.aspectRatio,
        child: FittedBox(
          child: SizedBox.fromSize(
            size: studentCardSize,
            // The card is a picture: the phone's text size scales it as a
            // whole through the space it gets, not line by line.
            child: MediaQuery.withNoTextScaling(
              child: Material(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(GlowRadius.card),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: GlowStroke.outline,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(onTap: onTap, child: face),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
