import 'package:material_ui/material_ui.dart';

/// The "→" between two times, drawn as an icon. The bundled fonts don't have
/// the character, and the web version would download a font from Google for
/// it.
InlineSpan arrowSpan(TextStyle? style) => WidgetSpan(
  alignment: PlaceholderAlignment.middle,
  child: Icon(
    Icons.arrow_forward,
    size: style?.fontSize,
    color: style?.color,
    semanticLabel: 'ถึง',
  ),
);
