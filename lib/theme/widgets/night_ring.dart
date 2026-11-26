import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../glow_colors.dart';
import '../tokens.dart';

/// One circle in the "วงคืนในสัปดาห์" row on the Tonight screen (THEME.md):
/// a 3dp ring colored by that night's sleep result, with the day-of-week
/// abbreviation inside. Tonight gets a dashed accent border instead.
class NightRing extends StatelessWidget {
  final String dayLabel;
  final SleepResult? result;
  final bool isTonight;
  final VoidCallback? onTap;

  const NightRing({
    super.key,
    required this.dayLabel,
    required this.result,
    this.isTonight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final glowColors = context.glowColors;
    final ringColor = result == null
        ? glowColors.noData
        : glowColors.forResult(result!);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Semantics(
      label: dayLabel,
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GlowRadius.pill),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: isTonight
              ? null
              : BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: 3),
                ),
          child: isTonight
              ? CustomPaint(
                  painter: _DashedCirclePainter(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      dayLabel,
                      style: TextStyle(
                        fontSize: GlowFontSize.tiny,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              : Text(
                  dayLabel,
                  style: TextStyle(
                    fontSize: GlowFontSize.tiny,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  const _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final radius = (size.shortestSide - paint.strokeWidth) / 2;
    final center = size.center(Offset.zero);
    const dashLength = 4.5, gapLength = 3.5;
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();
    final anglePerDash = 2 * math.pi / dashCount;
    final dashAngle = anglePerDash * (dashLength / (dashLength + gapLength));

    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * anglePerDash;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
