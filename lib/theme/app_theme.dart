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
    Color pick(Color light, Color dark) => isDark ? dark : light;

    final background = pick(
      GlowBaseColors.backgroundLight,
      GlowBaseColors.backgroundDark,
    );
    final surface = pick(
      GlowBaseColors.surfaceLight,
      GlowBaseColors.surfaceDark,
    );
    final textPrimary = pick(
      GlowBaseColors.textPrimaryLight,
      GlowBaseColors.textPrimaryDark,
    );
    final textSecondary = pick(
      GlowBaseColors.textSecondaryLight,
      GlowBaseColors.textSecondaryDark,
    );
    final outline = pick(
      GlowBaseColors.outlineLight,
      GlowBaseColors.outlineDark,
    );
    final divider = pick(
      GlowBaseColors.dividerLight,
      GlowBaseColors.dividerDark,
    );
    final accent = pick(GlowBaseColors.accentLight, GlowBaseColors.accentDark);
    final onAccent = pick(
      GlowBaseColors.onAccentLight,
      GlowBaseColors.onAccentDark,
    );
    final accentFill = pick(
      GlowBaseColors.accentFillLight,
      GlowBaseColors.accentFillDark,
    );
    final onAccentFill = pick(
      GlowBaseColors.onAccentFillLight,
      GlowBaseColors.onAccentFillDark,
    );
    final glow = isDark ? GlowColors.dark : GlowColors.light;
    final selectedFill = glow.pastel(GlowPastel.lilac);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      primaryContainer: accentFill,
      onPrimaryContainer: onAccentFill,
      secondary: accent,
      onSecondary: onAccent,
      secondaryContainer: selectedFill,
      onSecondaryContainer: textPrimary,
      error: GlowBaseColors.danger,
      onError: GlowBaseColors.onDanger,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceContainerHighest: divider,
      outline: outline,
      outlineVariant: divider,
    );

    TextStyle text(double size, FontWeight weight, Color color) => TextStyle(
      fontFamily: 'IBMPlexSansThai',
      fontWeight: weight,
      fontSize: size,
      // Thai stacks marks above and below the line.
      height: 1.5,
      color: color,
    );

    const regular = FontWeight.w400;
    const bold = FontWeight.w600;
    final baseTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: bold,
        fontSize: GlowFontSize.bigNumber,
        color: textPrimary,
      ),
      headlineLarge: text(GlowFontSize.title, bold, textPrimary),
      titleLarge: text(GlowFontSize.title, bold, textPrimary),
      titleMedium: text(GlowFontSize.body, bold, textPrimary),
      bodyLarge: text(GlowFontSize.body, regular, textPrimary),
      bodyMedium: text(GlowFontSize.body, regular, textSecondary),
      bodySmall: text(GlowFontSize.tiny, regular, textSecondary),
      labelSmall: text(GlowFontSize.tiny, regular, textSecondary),
    );

    const buttonText = TextStyle(
      fontFamily: 'IBMPlexSansThai',
      fontWeight: bold,
      fontSize: GlowFontSize.body,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(GlowRadius.button),
    );
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(GlowRadius.card),
      side: BorderSide.none,
    );

    // The coral action is shared by elevated and filled buttons.
    final mainButton = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? divider : accentFill,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? textSecondary
            : onAccentFill,
      ),
      side: const WidgetStatePropertyAll(BorderSide.none),
      shape: WidgetStatePropertyAll(buttonShape),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: const WidgetStatePropertyAll(buttonText),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );

    OutlineInputBorder fieldBorder(Color color, double width) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlowRadius.button),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'IBMPlexSansThai',
      textTheme: baseTextTheme.apply(fontFamilyFallback: const ['Nunito']),
      dividerColor: divider,
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: GlowStroke.divider,
        space: GlowStroke.divider,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 72,
        titleSpacing: GlowSpacing.pageMargin,
        titleTextStyle: text(GlowFontSize.title, bold, textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimary,
        unselectedLabelColor: textSecondary,
        indicatorColor: accent,
        dividerColor: divider,
        labelStyle: buttonText,
        unselectedLabelStyle: buttonText.copyWith(fontWeight: regular),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: mainButton.copyWith(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: mainButton.copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: divider,
          minimumSize: const Size(64, 48),
          side: BorderSide.none,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size(48, 48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? accentFill : divider,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? onAccentFill
                : textPrimary,
          ),
          side: const WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(buttonShape),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          textStyle: const WidgetStatePropertyAll(buttonText),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentFill,
        foregroundColor: onAccentFill,
        elevation: 0,
        shape: cardShape,
      ),
      cardTheme: CardThemeData(color: surface, elevation: 0, shape: cardShape),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 0,
        shape: cardShape,
        titleTextStyle: text(GlowFontSize.title, bold, textPrimary),
        contentTextStyle: text(GlowFontSize.body, regular, textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(GlowRadius.card),
          ),
          side: BorderSide.none,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.all(GlowSpacing.lg),
        border: fieldBorder(Colors.transparent, 0),
        enabledBorder: fieldBorder(Colors.transparent, 0),
        disabledBorder: fieldBorder(divider, GlowStroke.outline),
        focusedBorder: fieldBorder(accent, GlowStroke.focus),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: selectedFill,
        checkmarkColor: textPrimary,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlowRadius.pill),
        ),
        labelStyle: text(GlowFontSize.body, regular, textPrimary),
        secondaryLabelStyle: text(GlowFontSize.body, bold, textPrimary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimary,
        contentTextStyle: text(GlowFontSize.body, regular, background),
        actionTextColor: pick(
          GlowBaseColors.accentDark,
          GlowBaseColors.accentLight,
        ),
        shape: buttonShape,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentFill,
        linearTrackColor: divider,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? accentFill : divider,
        ),
        thumbColor: WidgetStatePropertyAll(surface),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlowRadius.button),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: GlowSpacing.lg),
        minVerticalPadding: GlowSpacing.md,
        iconColor: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary, size: 24),
      extensions: [glow],
    );
  }
}
