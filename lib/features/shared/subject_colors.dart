import 'package:material_ui/material_ui.dart';

import '../../core/subject_color.dart';

/// The block background for [title], or null if it has no color of its own.
Color? subjectBlockColor(
  BuildContext context,
  Map<String, int> colors,
  String title,
) {
  final color = colorOfSubject(colors, title);
  if (color == null) return null;
  final scheme = Theme.of(context).colorScheme;
  return Color(
    subjectFill(
      color,
      surface: scheme.surface.toARGB32(),
      ink: scheme.onSurface.toARGB32(),
    ),
  );
}

/// [color] made clear enough for a small mark in this theme.
Color visibleMarkColor(BuildContext context, int color) {
  final theme = Theme.of(context);
  return Color(
    subjectMark(
      color,
      on: [
        theme.scaffoldBackgroundColor.toARGB32(),
        theme.colorScheme.surface.toARGB32(),
      ],
    ),
  );
}

/// A dot in the subject's color, for rows; nothing if it has none.
class SubjectDot extends StatelessWidget {
  final Map<String, int> colors;
  final String title;
  final double size;

  const SubjectDot(this.colors, this.title, {super.key, this.size = 10});

  @override
  Widget build(BuildContext context) {
    final color = colorOfSubject(colors, title);
    if (color == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: visibleMarkColor(context, color),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
