import 'package:material_ui/material_ui.dart';

/// Raw design values from THEME.md. Only app_theme.dart and glow_colors.dart
/// should read these directly — screens and widgets must go through
/// Theme.of(context) / GlowColors.of(context) instead.
class GlowSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double pageMargin = 16;
}

class GlowRadius {
  static const double button = 10;
  static const double card = 16;
  static const double pill = 999;
}

class GlowFontSize {
  static const double headingLarge = 24;
  static const double heading = 18;
  static const double body = 16;
  static const double secondary = 14;
  static const double smallest = 12;
  static const double bigNumber = 48;
}

class GlowBaseColors {
  // Light mode
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFFAFAFA);
  static const textPrimaryLight = Color(0xFF1A1A1A);
  static const textSecondaryLight = Color(0xFF8A8A8A);
  static const dividerLight = Color(0xFFE3E3E3);
  static const accentLight = Color(0xFF5B5BD6);
  static const onAccentLight = Color(0xFFFFFFFF);

  // Dark mode
  static const backgroundDark = Color(0xFF000000);
  static const surfaceDark = Color(0xFF121212);
  static const textPrimaryDark = Color(0xFFF5F5F5);
  static const textSecondaryDark = Color(0xFFA3A3A3);
  static const dividerDark = Color(0xFF262626);
  static const accentDark = Color(0xFF8B8BFF);
  static const onAccentDark = Color(0xFF000000);

  // Same in both modes
  static const lampGlow = Color(0xFFFFC86B);
  static const danger = Color(0xFFED4956);
}

/// Sleep-result colors per THEME.md section "สีผลการนอน" — used in heatmap,
/// the week-night rings, and check-in results. Intentionally two-directional
/// (more isn't better): orange/yellow/green/blue, never red, so it never
/// reads as a pass/fail signal the way GitHub's heatmap does.
class GlowResultColors {
  static const noDataLight = Color(0xFFEBEDF0);
  static const notEnoughLight = Color(0xFFF28C38);
  static const almostEnoughLight = Color(0xFFF2C94C);
  static const enoughLight = Color(0xFF7ED38C);
  static const enoughOnTimeLight = Color(0xFF2EB872);
  static const overLight = Color(0xFF56A3F2);

  static const noDataDark = Color(0xFF2A2A2A);
  static const notEnoughDark = Color(0xFFF29A50);
  static const almostEnoughDark = Color(0xFFE8C45A);
  static const enoughDark = Color(0xFF4FA85E);
  static const enoughOnTimeDark = Color(0xFF3DDC84);
  static const overDark = Color(0xFF6AB0F5);
}
