/// The picture as it will be saved, over a checkerboard (which stands for
/// "see-through") or over the user's own photo.
library;

import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

import '../../core/story_share.dart';
import '../../theme/tokens.dart';
import 'story_painter.dart';

class StoryPreview extends StatelessWidget {
  final StorySummary story;
  final StoryOptions options;
  final ui.Image? logo;
  final ui.Image? photo;

  const StoryPreview({
    super.key,
    required this.story,
    required this.options,
    this.logo,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: storySize.width / storySize.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GlowRadius.button),
        child: CustomPaint(
          painter: _PreviewPainter(story, options, logo, photo),
        ),
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  final StorySummary story;
  final StoryOptions options;
  final ui.Image? logo;
  final ui.Image? photo;

  _PreviewPainter(this.story, this.options, this.logo, this.photo);

  @override
  void paint(Canvas canvas, Size size) {
    final own = photo;
    if (own != null) {
      paintPhotoCover(canvas, own, Offset.zero & size);
    } else {
      const square = 12.0;
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = GlowStoryColors.checkerLight,
      );
      final dark = Paint()..color = GlowStoryColors.checkerDark;
      for (var row = 0; row * square < size.height; row++) {
        for (var col = row % 2; col * square < size.width; col += 2) {
          canvas.drawRect(
            Rect.fromLTWH(col * square, row * square, square, square),
            dark,
          );
        }
      }
    }
    canvas.save();
    canvas.scale(size.width / storySize.width);
    paintStory(canvas, story, options, logo: logo);
    canvas.restore();
  }

  // The summary is rebuilt each time, and the screen changes rarely.
  @override
  bool shouldRepaint(_PreviewPainter old) => true;
}

/// One dot, for the legend.
class StoryDotIcon extends StatelessWidget {
  final StoryDot dot;
  final bool darkText;

  const StoryDotIcon({super.key, required this.dot, required this.darkText});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size.square(14),
    painter: _DotPainter(dot, darkText),
  );
}

class _DotPainter extends CustomPainter {
  final StoryDot dot;
  final bool darkText;

  _DotPainter(this.dot, this.darkText);

  @override
  void paint(Canvas canvas, Size size) => paintStoryDot(
    canvas,
    dot,
    size.center(Offset.zero),
    size.width / 2,
    darkText: darkText,
  );

  @override
  bool shouldRepaint(_DotPainter old) =>
      old.dot != dot || old.darkText != darkText;
}
