import 'package:material_ui/material_ui.dart';

import 'glow_colors.dart';
import 'tokens.dart';

/// Builds the light/dark ThemeData for Glow, per THEME.md. The only place
/// that should construct a ThemeData for this app.
class GlowAppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background = isDark
        ? GlowBaseColors.backgroundDark
        : GlowBaseColors.backgroundLight;
    final surface = isDark
        ? GlowBaseColors.surfaceDark
        : GlowBaseColors.surfaceLight;
    final textPrimary = isDark
        ? GlowBaseColors.textPrimaryDark
        : GlowBaseColors.textPrimaryLight;
    final textSecondary = isDark
        ? GlowBaseColors.textSecondaryDark
        : GlowBaseColors.textSecondaryLight;
    final divider = isDark
        ? GlowBaseColors.dividerDark
        : GlowBaseColors.dividerLight;
    final accent = isDark
        ? GlowBaseColors.accentDark
        : GlowBaseColors.accentLight;
    final onAccent = isDark
        ? GlowBaseColors.onAccentDark
        : GlowBaseColors.onAccentLight;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      secondary: accent,
      onSecondary: onAccent,
      error: GlowBaseColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    final baseTextTheme = TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'NotoSansThai',
        fontWeight: FontWeight.w700,
        fontSize: GlowFontSize.headingLarge,
        height: 1.5,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'NotoSansThai',
        fontWeight: FontWeight.w700,
        fontSize: GlowFontSize.heading,
        height: 1.5,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'NotoSansThai',
        fontWeight: FontWeight.w400,
        fontSize: GlowFontSize.body,
        height: 1.5,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NotoSansThai',
        fontWeight: FontWeight.w400,
        fontSize: GlowFontSize.secondary,
        height: 1.5,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: 'NotoSansThai',
        fontWeight: FontWeight.w400,
        fontSize: GlowFontSize.smallest,
        height: 1.5,
        color: textSecondary,
      ),
      displayLarge: TextStyle(
        fontFamily: 'NotoSansThai',
        fontWeight: FontWeight.w700,
        fontSize: GlowFontSize.bigNumber,
        color: textPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'NotoSansThai',
      textTheme: baseTextTheme,
      dividerColor: divider,
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 0.5,
        space: 0.5,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSansThai',
          fontWeight: FontWeight.w700,
          fontSize: GlowFontSize.heading,
          color: textPrimary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlowRadius.button),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'NotoSansThai',
            fontWeight: FontWeight.w700,
            fontSize: GlowFontSize.body,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontFamily: 'NotoSansThai',
            fontWeight: FontWeight.w700,
            fontSize: GlowFontSize.body,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlowRadius.card),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(GlowRadius.card),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlowRadius.button),
          borderSide: BorderSide(color: divider),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlowRadius.pill),
        ),
        labelStyle: TextStyle(
          fontFamily: 'NotoSansThai',
          fontSize: GlowFontSize.secondary,
          color: textPrimary,
        ),
      ),
      iconTheme: IconThemeData(color: textPrimary, size: 26),
      extensions: [isDark ? GlowColors.dark : GlowColors.light],
    );
  }
}
