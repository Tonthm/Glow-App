import 'package:material_ui/material_ui.dart';

import '../glow_colors.dart';

/// Glow's bed character (CLAUDE.md section 9): drawn with simple shapes for
/// now since its final look "ยังไม่ได้ตัดสินใจ" — kept isolated in this one
/// widget so swapping it out later doesn't touch the room screen. Condition
/// follows the latest check-in (fluffy vs a little wrinkled, never sad —
/// "ห้ามดูเศร้าหรือเหมือนตำหนิผู้ใช้"); the lamp brightens with fire level.
class BedCharacter extends StatelessWidget {
  final Color blanketColor;
  final bool isFluffy;
  final double lampOpacity;

  const BedCharacter({
    super.key,
    required this.blanketColor,
    required this.isFluffy,
    required this.lampOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final glow = context.glowColors;
    return CustomPaint(
      painter: _BedPainter(
        blanketColor: blanketColor,
        isFluffy: isFluffy,
        lampColor: glow.lampGlow.withValues(
          alpha: lampOpacity.clamp(0.15, 1.0),
        ),
        frameColor: Theme.of(context).dividerColor,
      ),
    );
  }
}

class _BedPainter extends CustomPainter {
  final Color blanketColor;
  final bool isFluffy;
  final Color lampColor;
  final Color frameColor;

  const _BedPainter({
    required this.blanketColor,
    required this.isFluffy,
    required this.lampColor,
    required this.frameColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Lamp on a small nightstand, top-right.
    final lampCenter = Offset(w * 0.85, h * 0.28);
    canvas.drawCircle(lampCenter, w * 0.07, Paint()..color = lampColor);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(lampCenter.dx, h * 0.5),
        width: w * 0.1,
        height: h * 0.22,
      ),
      Paint()..color = frameColor,
    );

    // Bed frame.
    final bedRect = Rect.fromLTWH(w * 0.05, h * 0.45, w * 0.65, h * 0.4);
    final bedRRect = RRect.fromRectAndRadius(
      bedRect,
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(
      bedRRect,
      Paint()..color = frameColor.withValues(alpha: 0.5),
    );

    // Pillow.
    final pillowRect = Rect.fromLTWH(w * 0.1, h * 0.42, w * 0.22, h * 0.16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(pillowRect, Radius.circular(w * 0.04)),
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Blanket — fluffy is a smooth rounded shape; a little wrinkled adds a
    // couple of soft fold lines, never a frown or sad shape.
    final blanketRect = Rect.fromLTWH(w * 0.08, h * 0.52, w * 0.58, h * 0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(blanketRect, Radius.circular(w * 0.07)),
      Paint()..color = blanketColor,
    );

    if (!isFluffy) {
      final foldPaint = Paint()
        ..color = blanketColor.withValues(alpha: 0.6)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      for (final dx in [0.22, 0.4, 0.58]) {
        canvas.drawLine(
          Offset(w * dx, h * 0.56),
          Offset(w * (dx + 0.03), h * 0.78),
          foldPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BedPainter oldDelegate) =>
      oldDelegate.blanketColor != blanketColor ||
      oldDelegate.isFluffy != isFluffy ||
      oldDelegate.lampColor != lampColor;
}
