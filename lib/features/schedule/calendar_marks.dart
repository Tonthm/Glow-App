import 'package:material_ui/material_ui.dart';

import '../../core/calendar_view.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';

String calendarKindLabel(CalendarKind kind) => switch (kind) {
  CalendarKind.holiday => 'วันหยุด',
  CalendarKind.exam => 'สอบ',
  CalendarKind.classSession => 'เรียน',
  CalendarKind.activity => 'กิจกรรม',
  CalendarKind.task => 'งาน',
};

/// The soft fill of a block or row of this kind.
Color calendarKindFill(BuildContext context, CalendarKind kind) =>
    context.glowColors.pastel(switch (kind) {
      CalendarKind.holiday => GlowPastel.butter,
      CalendarKind.exam => GlowPastel.pink,
      CalendarKind.classSession => GlowPastel.lilac,
      CalendarKind.activity => GlowPastel.sky,
      CalendarKind.task => GlowPastel.mint,
    });

Color calendarMarkColor(BuildContext context, CalendarKind kind) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (kind) {
    CalendarKind.holiday =>
      dark ? GlowMarkColors.holidayDark : GlowMarkColors.holidayLight,
    CalendarKind.exam =>
      dark ? GlowMarkColors.examDark : GlowMarkColors.examLight,
    CalendarKind.classSession =>
      dark ? GlowMarkColors.classDark : GlowMarkColors.classLight,
    CalendarKind.activity =>
      dark ? GlowMarkColors.activityDark : GlowMarkColors.activityLight,
    CalendarKind.task =>
      dark ? GlowMarkColors.taskDark : GlowMarkColors.taskLight,
  };
}

/// The small mark for a kind. Each has its own shape as well as its color, so
/// they can be told apart without seeing color.
class CalendarMark extends StatelessWidget {
  final CalendarKind kind;
  final double size;

  const CalendarMark(this.kind, {super.key, this.size = 7});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _MarkPainter(kind, calendarMarkColor(context, kind)),
  );
}

class _MarkPainter extends CustomPainter {
  final CalendarKind kind;
  final Color color;

  const _MarkPainter(this.kind, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = size.center(Offset.zero);
    final r = size.width / 2;
    switch (kind) {
      case CalendarKind.classSession || CalendarKind.holiday:
        canvas.drawCircle(center, r, paint);
      case CalendarKind.exam:
        // A diamond, a little larger so exams stand out.
        canvas.drawPath(
          Path()
            ..moveTo(center.dx, center.dy - r * 1.3)
            ..lineTo(center.dx + r * 1.3, center.dy)
            ..lineTo(center.dx, center.dy + r * 1.3)
            ..lineTo(center.dx - r * 1.3, center.dy)
            ..close(),
          paint,
        );
      case CalendarKind.activity:
        canvas.drawCircle(
          center,
          r - 1,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      case CalendarKind.task:
        canvas.drawRect(
          Rect.fromCenter(center: center, width: r * 1.8, height: r * 1.8),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.kind != kind || old.color != color;
}
