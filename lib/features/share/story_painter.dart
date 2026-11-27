/// Draws the picture shared to a story: see-through, 1080 x 1920, to lay over
/// any photo. The preview and the saved PNG are drawn by the same code.
library;

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import '../../core/story_share.dart';
import '../../theme/tokens.dart';

const Size storySize = Size(1080, 1920);

/// Instagram covers about this much at the top and bottom with its own
/// buttons, so nothing is drawn there.
const double storySafeMargin = 250;

/// Kept inside the safe area so soft shadows stay out of the margins too.
const double _shadowRoom = 40;
const double _sideMargin = 72;

enum StoryPosition { top, middle, bottom }

class StoryOptions {
  /// Dark text for bright photos; white otherwise.
  final bool darkText;
  final bool showLogo;

  /// Bed and wake times.
  final bool showTimes;
  final StoryPosition position;

  const StoryOptions({
    this.darkText = false,
    this.showLogo = true,
    this.showTimes = true,
    this.position = StoryPosition.middle,
  });

  StoryOptions copyWith({
    bool? darkText,
    bool? showLogo,
    bool? showTimes,
    StoryPosition? position,
  }) => StoryOptions(
    darkText: darkText ?? this.darkText,
    showLogo: showLogo ?? this.showLogo,
    showTimes: showTimes ?? this.showTimes,
    position: position ?? this.position,
  );
}

Color storyDotColor(StoryDot dot, {required bool darkText}) => switch (dot) {
  StoryDot.full =>
    darkText ? GlowStoryColors.fullDark : GlowStoryColors.fullLight,
  StoryDot.slightlyShort =>
    darkText
        ? GlowStoryColors.slightlyShortDark
        : GlowStoryColors.slightlyShortLight,
  StoryDot.veryShort =>
    darkText ? GlowStoryColors.veryShortDark : GlowStoryColors.veryShortLight,
  StoryDot.none =>
    darkText ? GlowStoryColors.noneDark : GlowStoryColors.noneLight,
};

/// One dot. The shapes differ as well as the colors: solid, half full, a
/// ring with a small centre, and a thin empty ring for no data.
void paintStoryDot(
  Canvas canvas,
  StoryDot dot,
  Offset centre,
  double radius, {
  required bool darkText,
}) {
  final color = storyDotColor(dot, darkText: darkText);
  final edge = darkText ? GlowStoryColors.halo : GlowStoryColors.shadow;
  final ringWidth = radius * (dot == StoryDot.none ? 0.11 : 0.24);
  final ring = radius - ringWidth / 2;
  final halo = radius * 0.1;

  Paint fill(Color c) => Paint()..color = c;
  Paint stroke(Color c, double width) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;

  switch (dot) {
    case StoryDot.full:
      canvas.drawCircle(centre, radius + halo, fill(edge));
      canvas.drawCircle(centre, radius, fill(color));
    case StoryDot.slightlyShort:
      canvas.drawCircle(centre, ring, stroke(edge, ringWidth + halo * 2));
      canvas.drawCircle(centre, ring, stroke(color, ringWidth));
      canvas.drawArc(
        Rect.fromCircle(center: centre, radius: ring),
        0,
        pi,
        true,
        fill(color),
      );
    case StoryDot.veryShort:
      canvas.drawCircle(centre, ring, stroke(edge, ringWidth + halo * 2));
      canvas.drawCircle(centre, ring, stroke(color, ringWidth));
      canvas.drawCircle(centre, radius * 0.24 + halo, fill(edge));
      canvas.drawCircle(centre, radius * 0.24, fill(color));
    case StoryDot.none:
      canvas.drawCircle(centre, ring, stroke(edge, ringWidth + halo * 2));
      canvas.drawCircle(centre, ring, stroke(color, ringWidth));
  }
}

/// A row of text, or the dots, with the room it takes.
class _Part {
  final double height;
  final double gapAbove;
  final void Function(Canvas canvas, double top) paint;

  _Part(this.height, this.paint, {this.gapAbove = 0});
}

TextStyle _style(
  double size, {
  required bool darkText,
  FontWeight weight = FontWeight.w700,
}) {
  final edge = darkText ? GlowStoryColors.halo : GlowStoryColors.shadow;
  return TextStyle(
    fontFamily: 'Fredoka',
    fontFamilyFallback: const ['IBMPlexSansThai', 'NotoSansThai'],
    fontSize: size,
    height: 1.25,
    fontWeight: weight,
    // Fredoka is variable; the Thai fallback uses its bundled static weight.
    fontVariations: [FontVariation('wght', weight.value.toDouble())],
    color: darkText ? GlowStoryColors.textDark : GlowStoryColors.textLight,
    // A tight edge for pale or busy patches, then a wider soft one.
    shadows: [
      Shadow(color: edge, blurRadius: 3),
      Shadow(color: edge, blurRadius: 8),
      Shadow(color: edge, blurRadius: 24, offset: const Offset(0, 2)),
    ],
  );
}

TextPainter _layOut(InlineSpan span) => TextPainter(
  text: span,
  textAlign: TextAlign.center,
  textDirection: TextDirection.ltr,
)..layout(maxWidth: storySize.width - _sideMargin * 2);

_Part _text(InlineSpan span, {double gapAbove = 0}) {
  final painter = _layOut(span);
  return _Part(painter.height, gapAbove: gapAbove, (canvas, top) {
    painter.paint(canvas, Offset((storySize.width - painter.width) / 2, top));
  });
}

const double _dotRadius = 42;

_Part _dots(StorySummary story, {required bool darkText}) {
  final isWeek = story.view == StoryView.week;
  // A week is one row with day letters; 30 nights are 6 across, 5 down.
  final columns = isWeek ? 7 : 6;
  final gapX = isWeek ? 44.0 : 52.0;
  const gapY = 36.0;
  const letterRoom = 76.0;
  final rows = (story.cells.length / columns).ceil();
  final width = columns * _dotRadius * 2 + (columns - 1) * gapX;
  final height =
      rows * _dotRadius * 2 + (rows - 1) * gapY + (isWeek ? letterRoom : 0);

  return _Part(height, (canvas, top) {
    final left = (storySize.width - width) / 2;
    for (var i = 0; i < story.cells.length; i++) {
      final centre = Offset(
        left + _dotRadius + (i % columns) * (_dotRadius * 2 + gapX),
        top + _dotRadius + (i ~/ columns) * (_dotRadius * 2 + gapY),
      );
      final cell = story.cells[i];
      paintStoryDot(canvas, cell.dot, centre, _dotRadius, darkText: darkText);
      if (!isWeek) continue;
      final letter = _layOut(
        TextSpan(
          text: storyDayLetter(cell.wakeDate),
          style: _style(40, darkText: darkText),
        ),
      );
      letter.paint(
        canvas,
        Offset(centre.dx - letter.width / 2, centre.dy + _dotRadius + 16),
      );
    }
  });
}

List<_Part> _parts(StorySummary story, StoryOptions options) {
  final dark = options.darkText;
  final isNight = story.view == StoryView.night;
  final (hours, minutes) = storyDuration(story.sleep!);
  final big = _style(172, darkText: dark, weight: FontWeight.w800);
  final unit = _style(72, darkText: dark);
  final note = story.missingNote;
  return [
    if (!isNight) _dots(story, darkText: dark),
    _text(
      TextSpan(
        text: isNight
            ? 'เวลานอน'
            : '${story.view.nights} คืนล่าสุด · นอนเฉลี่ยต่อคืน',
        style: _style(46, darkText: dark),
      ),
      gapAbove: isNight ? 0 : 56,
    ),
    _text(
      TextSpan(
        children: [
          TextSpan(text: '$hours', style: big),
          TextSpan(text: ' ชม. ', style: unit),
          TextSpan(text: '$minutes', style: big),
          TextSpan(text: ' น.', style: unit),
        ],
      ),
    ),
    if (options.showTimes) ...[
      _text(
        TextSpan(
          text: isNight ? 'เข้านอน – ตื่น' : 'เฉลี่ยเข้านอน – ตื่น',
          style: _style(40, darkText: dark),
        ),
        gapAbove: 28,
      ),
      _text(
        TextSpan(
          text:
              '${storyClock(story.bedMinutes!)} – '
              '${storyClock(story.wakeMinutes!)}',
          style: _style(84, darkText: dark, weight: FontWeight.w800),
        ),
      ),
    ],
    if (note != null)
      _text(
        TextSpan(
          text: note,
          style: _style(40, darkText: dark),
        ),
        gapAbove: 24,
      ),
  ];
}

const double _logoSide = 112;

/// The icon already carries the name, so nothing is written beside it.
void _paintLogo(Canvas canvas, ui.Image logo, StoryOptions options) {
  // The corner away from the numbers.
  final top = options.position == StoryPosition.bottom
      ? storySafeMargin + _shadowRoom
      : storySize.height - storySafeMargin - _shadowRoom - _logoSide;
  final box = Rect.fromLTWH(
    storySize.width - _sideMargin - _logoSide,
    top,
    _logoSide,
    _logoSide,
  );
  final shape = RRect.fromRectAndRadius(box, const Radius.circular(26));
  canvas.drawRRect(
    shape,
    Paint()
      ..color = GlowStoryColors.shadow
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8),
  );
  canvas.save();
  canvas.clipRRect(shape);
  canvas.drawImageRect(
    logo,
    Rect.fromLTWH(0, 0, logo.width.toDouble(), logo.height.toDouble()),
    box,
    Paint()..filterQuality = FilterQuality.high,
  );
  canvas.restore();
}

/// Draws the overlay on a [storySize] canvas, leaving the rest see-through.
/// A [story] with nothing recorded draws nothing.
void paintStory(
  Canvas canvas,
  StorySummary story,
  StoryOptions options, {
  ui.Image? logo,
}) {
  if (!story.canShare) return;
  final parts = _parts(story, options);
  final height = parts.fold(0.0, (sum, p) => sum + p.gapAbove + p.height);
  const highest = storySafeMargin + _shadowRoom;
  final lowest = storySize.height - storySafeMargin - _shadowRoom - height;
  var top = switch (options.position) {
    StoryPosition.top => highest,
    StoryPosition.middle => (storySize.height - height) / 2,
    StoryPosition.bottom => lowest,
  };
  for (final part in parts) {
    top += part.gapAbove;
    part.paint(canvas, top);
    top += part.height;
  }
  if (options.showLogo && logo != null) _paintLogo(canvas, logo, options);
}

/// Fills [target] with [photo], cutting off what doesn't fit its shape.
void paintPhotoCover(Canvas canvas, ui.Image photo, Rect target) {
  final scale = max(target.width / photo.width, target.height / photo.height);
  final width = target.width / scale;
  final height = target.height / scale;
  canvas.drawImageRect(
    photo,
    Rect.fromLTWH(
      (photo.width - width) / 2,
      (photo.height - height) / 2,
      width,
      height,
    ),
    target,
    Paint()..filterQuality = FilterQuality.high,
  );
}

/// The PNG to save or share. With no [photo] it is see-through; with one,
/// the overlay is flattened onto it. Built from drawn pixels, so nothing in
/// the photo's file (place, time) comes along.
Future<Uint8List> renderStoryPng(
  StorySummary story,
  StoryOptions options, {
  ui.Image? logo,
  ui.Image? photo,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.clipRect(Offset.zero & storySize);
  if (photo != null) paintPhotoCover(canvas, photo, Offset.zero & storySize);
  paintStory(canvas, story, options, logo: logo);
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    storySize.width.toInt(),
    storySize.height.toInt(),
  );
  picture.dispose();
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}
