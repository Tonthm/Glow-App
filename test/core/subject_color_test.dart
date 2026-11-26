import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/subject_color.dart';

void main() {
  // The light and dark theme's page, card and text colors.
  const themes = [
    (page: 0xFFFBF9FF, surface: 0xFFFFFFFF, ink: 0xFF1D1A29),
    (page: 0xFF13111B, surface: 0xFF1F1C2B, ink: 0xFFF4F2FA),
  ];

  // Every color a user could make: the corners of the color cube and more.
  final anyColor = [
    for (final r in [0, 64, 128, 192, 255])
      for (final g in [0, 64, 128, 192, 255])
        for (final b in [0, 64, 128, 192, 255])
          0xFF000000 | r << 16 | g << 8 | b,
  ];

  test('one subject however it is typed', () {
    expect(subjectKey('  คณิต   เพิ่มเติม '), 'คณิต เพิ่มเติม');
    expect(subjectKey('Physics'), subjectKey('physics '));
    expect(subjectKey('คณิต'), isNot(subjectKey('ฟิสิกส์')));
    expect(subjectKey('   '), '');
  });

  test('finds a subject color by name', () {
    const colors = {'physics': 0xFF112233};
    expect(colorOfSubject(colors, ' PHYSICS '), 0xFF112233);
    expect(colorOfSubject(colors, 'เคมี'), isNull);
    expect(colorOfSubject(colors, ''), isNull);
  });

  test('contrast matches the known extremes', () {
    expect(contrastRatio(0xFF000000, 0xFFFFFFFF), closeTo(21, 0.01));
    expect(contrastRatio(0xFF777777, 0xFF777777), 1);
  });

  test('text can be read on a block of any color', () {
    for (final theme in themes) {
      for (final color in anyColor) {
        final fill = subjectFill(color, surface: theme.surface, ink: theme.ink);
        expect(
          contrastRatio(theme.ink, fill),
          greaterThanOrEqualTo(4.5),
          reason: color.toRadixString(16),
        );
      }
    }
  });

  test('a block still shows its color', () {
    for (final theme in themes) {
      final red = subjectFill(
        0xFFFF0000,
        surface: theme.surface,
        ink: theme.ink,
      );
      expect(red, isNot(theme.surface));
      expect((red >> 16) & 0xFF, greaterThan(red & 0xFF));
    }
  });

  test('a mark of any color can be seen on the page', () {
    for (final theme in themes) {
      for (final color in anyColor) {
        final mark = subjectMark(color, on: [theme.page, theme.surface]);
        for (final background in [theme.page, theme.surface]) {
          expect(
            contrastRatio(mark, background),
            greaterThanOrEqualTo(3),
            reason: color.toRadixString(16),
          );
        }
      }
    }
  });

  test('a mark that is already clear keeps its color', () {
    expect(subjectMark(0xFF4B3FC4, on: [0xFFFFFFFF]), 0xFF4B3FC4);
  });
}
