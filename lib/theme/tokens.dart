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

/// The calendar's small marks: strong enough to see on the page, unlike the
/// pastels.
class GlowMarkColors {
  static const classLight = Color(0xFF4B3FC4);
  static const classDark = Color(0xFFBDB4FF);
  static const examLight = Color(0xFFC0264F);
  static const examDark = Color(0xFFFF9DB5);
  static const activityLight = Color(0xFF0B6BB5);
  static const activityDark = Color(0xFF8FCBFF);
  static const taskLight = Color(0xFF8A5A00);
  static const taskDark = Color(0xFFFFD27A);
  static const holidayLight = Color(0xFFB4530A);
  static const holidayDark = Color(0xFFFFB680);
}

class GlowRadius {
  static const double button = 14;
  static const double card = 20;
  static const double pill = 999;

  /// Squares in the heatmap and its legend.
  static const double cell = 3;
}

class GlowStroke {
  /// The thin ink line around cards, buttons, chips and fields.
  static const double outline = 1.2;
  static const double divider = 0.8;
  static const double focus = 2;
}

/// A screen uses two text sizes, [title] and [body], with weight doing the
/// rest of the work. [bigNumber] is the one hero figure (tonight's bedtime)
/// and [tiny] is only for dense charts such as the heatmap and week grid.
class GlowFontSize {
  static const double title = 20;
  static const double body = 15;
  static const double tiny = 12;
  static const double bigNumber = 48;
}

class GlowBaseColors {
  // Light mode
  static const backgroundLight = Color(0xFFFBF9FF);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const textPrimaryLight = Color(0xFF1D1A29);
  static const textSecondaryLight = Color(0xFF5E5973);
  static const outlineLight = Color(0xFF1D1A29);
  static const dividerLight = Color(0xFFE4DFF0);

  /// Dark enough to read as text on the light background.
  static const accentLight = Color(0xFF4B3FC4);
  static const onAccentLight = Color(0xFFFFFFFF);

  /// The pastel behind the main button.
  static const accentFillLight = Color(0xFFBDB4FF);
  static const onAccentFillLight = Color(0xFF1D1A29);

  // Dark mode: a black line would disappear, so the outline turns light.
  static const backgroundDark = Color(0xFF13111B);
  static const surfaceDark = Color(0xFF1F1C2B);
  static const textPrimaryDark = Color(0xFFF4F2FB);
  static const textSecondaryDark = Color(0xFFB5B0C9);
  static const outlineDark = Color(0xFF8D87A8);
  static const dividerDark = Color(0xFF322E44);
  static const accentDark = Color(0xFFBDB4FF);
  static const onAccentDark = Color(0xFF17141F);
  static const accentFillDark = Color(0xFFBDB4FF);
  static const onAccentFillDark = Color(0xFF17141F);

  // Same in both modes
  static const lampGlow = Color(0xFFFFC86B);
  static const danger = Color(0xFFED4956);
  static const onDanger = Color(0xFF1D1A29);

  /// Ink for marks drawn on top of a bright swatch.
  static const ink = Color(0xFF1D1A29);
}

/// Soft fills for cards, tags and subject colors. Text on them is the normal
/// text color: the light set is pale, the dark set is deep.
class GlowPastelColors {
  static const lilacLight = Color(0xFFE4DEFF);
  static const pinkLight = Color(0xFFFFDCE8);
  static const peachLight = Color(0xFFFFE3CF);
  static const butterLight = Color(0xFFFFF0B8);
  static const mintLight = Color(0xFFD2F2DF);
  static const skyLight = Color(0xFFD6EAFF);

  static const lilacDark = Color(0xFF37315C);
  static const pinkDark = Color(0xFF4F2D40);
  static const peachDark = Color(0xFF503526);
  static const butterDark = Color(0xFF473F1E);
  static const mintDark = Color(0xFF224233);
  static const skyDark = Color(0xFF213A53);
}

/// Colors of the drawings on the student card. The card looks the same in
/// light and dark mode, like a real one.
class GlowCardArtColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const butter = Color(0xFFFFE27A);
  static const peach = Color(0xFFFFC49B);
  static const pink = Color(0xFFFF9EBB);
  static const lilac = Color(0xFFBDB4FF);
  static const sky = Color(0xFFAFD8FF);
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
