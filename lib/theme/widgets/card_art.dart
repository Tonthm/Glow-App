/// Glow's own drawings for the student card: logos, avatars, stickers and
/// frames, all made of paths. No image files.
library;

import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../core/card_config.dart';
import '../tokens.dart';

Paint _fill(Color color) => Paint()..color = color;

Paint _line(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

/// A shape with the ink line around it. [unit] is the size of the drawing.
void _shape(Canvas canvas, Path path, Color color, double unit) {
  canvas.drawPath(path, _fill(color));
  canvas.drawPath(path, _line(GlowBaseColors.ink, unit * 0.045));
}

Path _star(Offset c, double outer, double inner, {int points = 5}) {
  final path = Path();
  for (var i = 0; i < points * 2; i++) {
    final radius = i.isEven ? outer : inner;
    final angle = -math.pi / 2 + i * math.pi / points;
    final p = c + Offset(math.cos(angle), math.sin(angle)) * radius;
    i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
  }
  return path..close();
}

Path _crescent(Offset c, double r) => Path.combine(
  PathOperation.difference,
  Path()..addOval(Rect.fromCircle(center: c, radius: r)),
  Path()..addOval(
    Rect.fromCircle(center: c + Offset(r * 0.55, -r * 0.3), radius: r * 0.82),
  ),
);

/// A cloud filling [box].
Path _cloud(Rect box) {
  Path oval(double cx, double cy, double r) => Path()
    ..addOval(
      Rect.fromCircle(
        center: Offset(box.left + box.width * cx, box.top + box.height * cy),
        radius: box.width * r,
      ),
    );
  var path = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          box.left,
          box.top + box.height * 0.48,
          box.right,
          box.bottom,
        ),
        Radius.circular(box.height * 0.26),
      ),
    );
  for (final puff in [
    oval(0.30, 0.48, 0.20),
    oval(0.56, 0.38, 0.27),
    oval(0.78, 0.54, 0.17),
  ]) {
    path = Path.combine(PathOperation.union, path, puff);
  }
  return path;
}

Path _heart(Rect b) {
  final w = b.width, h = b.height;
  return Path()
    ..moveTo(b.left + w * 0.5, b.top + h * 0.9)
    ..cubicTo(
      b.left - w * 0.1,
      b.top + h * 0.5,
      b.left + w * 0.15,
      b.top - h * 0.05,
      b.left + w * 0.5,
      b.top + h * 0.28,
    )
    ..cubicTo(
      b.left + w * 0.85,
      b.top - h * 0.05,
      b.left + w * 1.1,
      b.top + h * 0.5,
      b.left + w * 0.5,
      b.top + h * 0.9,
    )
    ..close();
}

void _planet(Canvas canvas, Offset c, double r, Color color, double unit) {
  _shape(
    canvas,
    Path()..addOval(Rect.fromCircle(center: c, radius: r)),
    color,
    unit,
  );
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.rotate(-0.38);
  final ring = Rect.fromCenter(
    center: Offset.zero,
    width: r * 3,
    height: r * 0.85,
  );
  // Only the front half, so the ring passes behind the planet.
  canvas.drawArc(
    ring,
    -0.35,
    math.pi + 0.7,
    false,
    _line(GlowBaseColors.ink, unit * 0.06),
  );
  canvas.restore();
}

void _comet(Canvas canvas, Size size) {
  final s = size.shortestSide;
  for (final (from, to) in [
    (const Offset(0.08, 0.92), const Offset(0.45, 0.58)),
    (const Offset(0.08, 0.62), const Offset(0.34, 0.45)),
    (const Offset(0.40, 0.94), const Offset(0.58, 0.68)),
  ]) {
    canvas.drawLine(from * s, to * s, _line(GlowBaseColors.ink, s * 0.07));
  }
  _shape(
    canvas,
    _star(Offset(s * 0.65, s * 0.37), s * 0.31, s * 0.15),
    GlowCardArtColors.butter,
    s,
  );
}

class _LogoPainter extends CustomPainter {
  final String id;

  const _LogoPainter(this.id);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = size.center(Offset.zero);
    switch (id) {
      case 'logo_star':
        _shape(
          canvas,
          _star(c, s * 0.48, s * 0.22),
          GlowCardArtColors.butter,
          s,
        );
      case 'logo_cloud':
        _shape(
          canvas,
          _cloud(Rect.fromCenter(center: c, width: s * 0.94, height: s * 0.62)),
          GlowCardArtColors.white,
          s,
        );
      case 'logo_comet':
        _comet(canvas, size);
      case 'logo_planet':
        _planet(canvas, c, s * 0.29, GlowCardArtColors.peach, s);
      case 'logo_sparkles':
        _shape(
          canvas,
          _star(Offset(s * 0.40, s * 0.56), s * 0.38, s * 0.11, points: 4),
          GlowCardArtColors.butter,
          s,
        );
        _shape(
          canvas,
          _star(Offset(s * 0.76, s * 0.24), s * 0.22, s * 0.07, points: 4),
          GlowCardArtColors.white,
          s,
        );
      default:
        _shape(canvas, _crescent(c, s * 0.44), GlowCardArtColors.butter, s);
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.id != id;
}

class _AvatarPainter extends CustomPainter {
  final String id;
  final AvatarMood mood;

  const _AvatarPainter(this.id, this.mood);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = size.center(Offset.zero);
    var face = c + Offset(0, s * 0.06);
    switch (id) {
      case 'avatar_moon':
        _shape(
          canvas,
          Path()..addOval(Rect.fromCircle(center: c, radius: s * 0.42)),
          GlowCardArtColors.butter,
          s,
        );
        for (final (dx, dy, r) in [(-0.2, -0.24, 0.07), (0.22, -0.2, 0.045)]) {
          canvas.drawCircle(
            c + Offset(dx * s, dy * s),
            r * s,
            _line(GlowBaseColors.ink, s * 0.025),
          );
        }
      case 'avatar_star':
        _shape(
          canvas,
          _star(c + Offset(0, s * 0.03), s * 0.5, s * 0.29),
          GlowCardArtColors.butter,
          s,
        );
      case 'avatar_planet':
        _planet(canvas, c, s * 0.33, GlowCardArtColors.peach, s);
        face = c - Offset(0, s * 0.06);
      default:
        _shape(
          canvas,
          _cloud(Rect.fromCenter(center: c, width: s * 0.92, height: s * 0.68)),
          GlowCardArtColors.white,
          s,
        );
        face = c + Offset(0, s * 0.1);
    }
    _paintFace(canvas, face, s);
  }

  void _paintFace(Canvas canvas, Offset f, double s) {
    final ink = _line(GlowBaseColors.ink, s * 0.04);
    for (final side in [-1.0, 1.0]) {
      final eye = f + Offset(side * s * 0.13, -s * 0.03);
      final arc = Rect.fromCenter(
        center: eye,
        width: s * 0.11,
        height: s * 0.08,
      );
      switch (mood) {
        case AvatarMood.calm:
          canvas.drawCircle(eye, s * 0.035, _fill(GlowBaseColors.ink));
        case AvatarMood.rested:
          // Smiling eyes, curved up.
          canvas.drawArc(arc, math.pi, math.pi, false, ink);
        case AvatarMood.sleepy:
          // Closed and relaxed, curved down.
          canvas.drawArc(arc, 0, math.pi, false, ink);
      }
      if (mood == AvatarMood.rested) {
        canvas.drawCircle(
          f + Offset(side * s * 0.21, s * 0.06),
          s * 0.045,
          _fill(GlowCardArtColors.pink),
        );
      }
    }
    final mouth = f + Offset(0, s * 0.06);
    if (mood == AvatarMood.sleepy) {
      canvas.drawCircle(mouth + Offset(0, s * 0.02), s * 0.03, ink);
      _zed(canvas, f + Offset(s * 0.30, -s * 0.30), s * 0.13, ink);
    } else {
      final wide = mood == AvatarMood.rested ? 0.16 : 0.11;
      canvas.drawArc(
        Rect.fromCenter(center: mouth, width: s * wide, height: s * wide * 0.8),
        0.15,
        math.pi - 0.3,
        false,
        ink,
      );
    }
  }

  @override
  bool shouldRepaint(_AvatarPainter old) => old.id != id || old.mood != mood;
}

void _zed(Canvas canvas, Offset at, double w, Paint paint) {
  canvas.drawPath(
    Path()
      ..moveTo(at.dx, at.dy)
      ..lineTo(at.dx + w, at.dy)
      ..lineTo(at.dx, at.dy + w)
      ..lineTo(at.dx + w, at.dy + w),
    paint,
  );
}

class _StickerPainter extends CustomPainter {
  final String id;

  const _StickerPainter(this.id);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = size.center(Offset.zero);
    // A white disc lets every sticker stand out on any card color.
    _shape(
      canvas,
      Path()..addOval(Rect.fromCircle(center: c, radius: s * 0.48)),
      GlowCardArtColors.white,
      s,
    );
    final box = Rect.fromCircle(center: c, radius: s * 0.3);
    switch (id) {
      case 'sticker_moon':
        _shape(canvas, _crescent(c, s * 0.3), GlowCardArtColors.lilac, s);
      case 'sticker_cloud':
        _shape(
          canvas,
          _cloud(Rect.fromCenter(center: c, width: s * 0.64, height: s * 0.44)),
          GlowCardArtColors.sky,
          s,
        );
      case 'sticker_heart':
        _shape(canvas, _heart(box), GlowCardArtColors.pink, s);
      case 'sticker_zzz':
        final ink = _line(GlowBaseColors.ink, s * 0.055);
        _zed(canvas, Offset(s * 0.24, s * 0.46), s * 0.26, ink);
        _zed(canvas, Offset(s * 0.57, s * 0.25), s * 0.17, ink);
      case 'sticker_comet':
        canvas.save();
        canvas.translate(s * 0.17, s * 0.17);
        _comet(canvas, Size.square(s * 0.66));
        canvas.restore();
      default:
        _shape(
          canvas,
          _star(c, s * 0.34, s * 0.17),
          GlowCardArtColors.butter,
          s,
        );
        for (final side in [-1.0, 1.0]) {
          canvas.drawCircle(
            c + Offset(side * s * 0.06, s * 0.01),
            s * 0.022,
            _fill(GlowBaseColors.ink),
          );
        }
    }
  }

  @override
  bool shouldRepaint(_StickerPainter old) => old.id != id;
}

/// Drawn over the whole card, just inside its outline.
class CardFramePainter extends CustomPainter {
  final String id;
  final Color color;

  const CardFramePainter(this.id, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final inner = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(6),
      const Radius.circular(GlowRadius.card - 5),
    );
    switch (id) {
      case 'frame_double':
        canvas.drawRRect(inner, _line(color, 1.2));
      case 'frame_dots':
        for (final metric in (Path()..addRRect(inner)).computeMetrics()) {
          for (var d = 0.0; d < metric.length; d += 9) {
            canvas.drawCircle(
              metric.getTangentForOffset(d)!.position,
              1.4,
              _fill(color),
            );
          }
        }
      case 'frame_stars':
        canvas.drawRRect(inner, _line(color, 0.8));
        for (final corner in [
          const Offset(12, 12),
          Offset(size.width - 12, 12),
          Offset(12, size.height - 12),
          Offset(size.width - 12, size.height - 12),
        ]) {
          _shape(
            canvas,
            _star(corner, 10, 3.2, points: 4),
            GlowCardArtColors.butter,
            22,
          );
        }
    }
  }

  @override
  bool shouldRepaint(CardFramePainter old) =>
      old.id != id || old.color != color;
}

/// One fire stamp: a stamped flame star, or the dashed slot waiting for it.
class FireStampPainter extends CustomPainter {
  final bool stamped;
  final Color empty;

  const FireStampPainter({required this.stamped, required this.empty});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = size.center(Offset.zero);
    if (!stamped) {
      const dashes = 12;
      for (var i = 0; i < dashes; i++) {
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: s * 0.44),
          i * 2 * math.pi / dashes,
          math.pi / dashes,
          false,
          _line(empty, 1.2),
        );
      }
      return;
    }
    _shape(
      canvas,
      Path()..addOval(Rect.fromCircle(center: c, radius: s * 0.46)),
      GlowBaseColors.lampGlow,
      s,
    );
    _shape(canvas, _star(c, s * 0.3, s * 0.13), GlowCardArtColors.white, s);
  }

  @override
  bool shouldRepaint(FireStampPainter old) =>
      old.stamped != stamped || old.empty != empty;
}

class CardLogo extends StatelessWidget {
  final String id;
  final double size;

  const CardLogo(this.id, {super.key, this.size = 28});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _LogoPainter(id));
}

class CardAvatar extends StatelessWidget {
  final String id;
  final AvatarMood mood;
  final double size;

  const CardAvatar(
    this.id, {
    super.key,
    this.mood = AvatarMood.calm,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _AvatarPainter(id, mood));
}

class CardSticker extends StatelessWidget {
  final String id;
  final double size;

  const CardSticker(this.id, {super.key, this.size = 36});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _StickerPainter(id));
}
