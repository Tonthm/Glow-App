import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:glow/theme/glow_colors.dart';
import 'package:glow/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final brightness in Brightness.values) {
    final theme = brightness == Brightness.dark
        ? GlowAppTheme.dark()
        : GlowAppTheme.light();
    final scheme = theme.colorScheme;
    final page = theme.scaffoldBackgroundColor;
    final glow = theme.extension<GlowColors>()!;
    final button = theme.elevatedButtonTheme.style!;

    group('${brightness.name} theme is readable', () {
      // 4.5:1 is the WCAG AA level for normal text.
      void readable(String name, Color text, Color on) {
        test(name, () {
          expect(_contrast(text, on), greaterThanOrEqualTo(4.5));
        });
      }

      readable('text on the page', scheme.onSurface, page);
      readable('secondary text on the page', scheme.onSurfaceVariant, page);
      readable(
        'secondary text on cards',
        scheme.onSurfaceVariant,
        scheme.surface,
      );
      readable('links on the page', scheme.primary, page);
      readable('links on cards', scheme.primary, scheme.surface);
      readable(
        'selected navigation label',
        scheme.onSurface,
        glow.pastel(GlowPastel.peach),
      );
      final secondaryButton = theme.outlinedButtonTheme.style!;
      readable(
        'secondary button label',
        secondaryButton.foregroundColor!.resolve({})!,
        secondaryButton.backgroundColor!.resolve({})!,
      );
      readable(
        'main button label',
        button.foregroundColor!.resolve({})!,
        button.backgroundColor!.resolve({})!,
      );
      // 3:1 is the WCAG level for shapes that carry meaning.
      final dark = brightness == Brightness.dark;
      for (final (name, mark) in [
        ('class', dark ? GlowMarkColors.classDark : GlowMarkColors.classLight),
        ('exam', dark ? GlowMarkColors.examDark : GlowMarkColors.examLight),
        (
          'activity',
          dark ? GlowMarkColors.activityDark : GlowMarkColors.activityLight,
        ),
        ('task', dark ? GlowMarkColors.taskDark : GlowMarkColors.taskLight),
      ]) {
        test('the $name calendar mark can be seen', () {
          expect(_contrast(mark, page), greaterThanOrEqualTo(3));
          expect(_contrast(mark, scheme.surface), greaterThanOrEqualTo(3));
        });
      }
      for (final pastel in GlowPastel.values) {
        readable(
          'text on ${pastel.name}',
          scheme.onSurface,
          glow.pastel(pastel),
        );
      }
    });

    // On the web, a letter that no listed font has makes Flutter download one
    // from Google. Fredoka and Nunito have no Thai letters.
    test('every ${brightness.name} text style has a bundled Thai font', () {
      final styles = theme.textTheme;
      for (final style in [
        styles.displayLarge,
        styles.headlineLarge,
        styles.titleLarge,
        styles.titleMedium,
        styles.bodyLarge,
        styles.bodyMedium,
        styles.bodySmall,
        styles.labelSmall,
      ]) {
        expect([
          style!.fontFamily,
          ...?style.fontFamilyFallback,
        ], contains('IBMPlexSansThai'));
      }
    });
  }
}
