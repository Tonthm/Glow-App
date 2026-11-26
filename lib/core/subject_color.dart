/// A color the user gives a subject (CLAUDE.md section 2). It belongs to the
/// name, so every class, exam, or task with that name wears it. Colors are
/// plain ARGB numbers here.
library;

import 'dart:math' as math;

/// How a subject's name is looked up: spacing and capitals don't matter.
String subjectKey(String title) =>
    title.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

/// [colors] is keyed by [subjectKey].
int? colorOfSubject(Map<String, int> colors, String title) =>
    colors[subjectKey(title)];

double _channel(int value) {
  final c = value / 255;
  return c <= 0.03928
      ? c / 12.92
      : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(int argb) =>
    0.2126 * _channel((argb >> 16) & 0xFF) +
    0.7152 * _channel((argb >> 8) & 0xFF) +
    0.0722 * _channel(argb & 0xFF);

/// The WCAG contrast ratio, 1 to 21.
double contrastRatio(int a, int b) {
  final la = _luminance(a), lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// [amount] of [top] over [base]; both are treated as solid.
int _mix(int top, int base, double amount) {
  int part(int shift) {
    final t = (top >> shift) & 0xFF, b = (base >> shift) & 0xFF;
    return (b + (t - b) * amount).round();
  }

  return 0xFF000000 | part(16) << 16 | part(8) << 8 | part(0);
}

const double _strongestFill = 0.6;

/// The background of a block in [color]: as much of it as still lets text of
/// color [ink] be read.
int subjectFill(int color, {required int surface, required int ink}) {
  for (var amount = _strongestFill; amount > 0; amount -= 0.03) {
    final fill = _mix(color, surface, amount);
    if (contrastRatio(ink, fill) >= 4.5) return fill;
  }
  return surface;
}

/// [color] for a small mark, darkened or lightened only as far as needed to
/// stand out (3:1) from every background in [on].
int subjectMark(int color, {required List<int> on}) {
  bool clear(int candidate) =>
      on.every((background) => contrastRatio(candidate, background) >= 3);
  // Move away from the backgrounds: towards black on light, white on dark.
  final towards = _luminance(on.first) > 0.4 ? 0xFF000000 : 0xFFFFFFFF;
  for (var step = 0; step <= 20; step++) {
    final candidate = _mix(towards, color, step / 20);
    if (clear(candidate)) return candidate;
  }
  return towards;
}
