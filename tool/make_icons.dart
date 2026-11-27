// Makes every app icon from assets/logo.png. Run from the project folder:
//   dart run tool/make_icons.dart
//
// The source is a rounded square in the middle of a larger transparent
// canvas. The full-square version is cut from inside it, so no rounded corner
// is left, and phones can round it their own way.
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// How far inside the rounded square the cut is made, on each side.
const double _inset = 0.08;

/// The logo's size within a maskable icon. A launcher may cut away everything
/// outside the middle circle (radius 40%), and the big star reaches furthest.
const double _maskableScale = 0.70;

/// How far the edge colors are blurred at the outside of a maskable icon.
const double _spreadShare = 0.08;

void main() {
  final source = img.decodePng(File('assets/logo.png').readAsBytesSync())!;
  final square = _fullSquare(source);

  _save('assets/logo_square.png', _resize(square, 512));
  // web/favicon.png is made by hand (rounded corners), so it isn't touched.
  _save('web/icons/apple-touch-icon.png', _resize(square, 180));
  _save('web/icons/Icon-192.png', _resize(square, 192));
  _save('web/icons/Icon-512.png', _resize(square, 512));
  final maskable = _maskable(square, 512);
  _save('web/icons/Icon-maskable-512.png', maskable);
  _save('web/icons/Icon-maskable-192.png', _resize(maskable, 192));
}

img.Image _fullSquare(img.Image source) {
  var left = source.width, top = source.height, right = 0, bottom = 0;
  for (final p in source) {
    if (p.a < 200) continue;
    left = math.min(left, p.x);
    top = math.min(top, p.y);
    right = math.max(right, p.x);
    bottom = math.max(bottom, p.y);
  }
  final side = math.min(right - left, bottom - top) + 1;
  final cut = (side * _inset).round();
  final square = img.copyCrop(
    source,
    x: left + cut,
    y: top + cut,
    width: side - 2 * cut,
    height: side - 2 * cut,
  );
  for (final p in square) {
    if (p.a < 255) {
      throw StateError('A see-through pixel is left at ${p.x},${p.y}');
    }
    if (p.r + p.g + p.b < 150) {
      throw StateError('A black pixel is left at ${p.x},${p.y}');
    }
  }
  // iPhone shows see-through parts as black, so drop the alpha channel.
  return square.convert(numChannels: 3);
}

img.Image _resize(img.Image image, int side) => img.copyResize(
  image,
  width: side,
  height: side,
  interpolation: img.Interpolation.average,
);

img.Image _maskable(img.Image square, int side) {
  final purple = _edgeColor(square);
  final canvas = img.Image(width: side, height: side, numChannels: 3);
  final inner = _resize(square, (side * _maskableScale).round());
  final offset = (side - inner.width) ~/ 2;
  final last = inner.width - 1;
  final spread = (inner.width * _spreadShare).round();
  for (final p in canvas) {
    final x = p.x - offset, y = p.y - offset;
    final nx = x.clamp(0, last), ny = y.clamp(0, last);
    final away = math.sqrt(math.pow(x - nx, 2) + math.pow(y - ny, 2));
    if (away == 0) {
      p.set(inner.getPixel(x, y));
      continue;
    }
    // Outside the logo, carry its edge outwards, blurred more and faded into
    // plain purple the further out, so no seam shows.
    final t = (away / offset).clamp(0.0, 1.0);
    final fade = t * t * (3 - 2 * t);
    final reach = (spread * t).round();
    var r = 0.0, g = 0.0, b = 0.0, n = 0;
    for (var step = -reach; step <= reach; step++) {
      final edge = inner.getPixel(
        (x == nx ? nx + step : nx).clamp(0, last),
        (y == ny ? ny + step : ny).clamp(0, last),
      );
      r += edge.r;
      g += edge.g;
      b += edge.b;
      n++;
    }
    int mix(double sum, num base) =>
        (sum / n + (base - sum / n) * fade).round();
    p.setRgb(mix(r, purple.r), mix(g, purple.g), mix(b, purple.b));
  }
  return canvas;
}

/// The average color along the four sides of [image].
img.Color _edgeColor(img.Image image) {
  var r = 0.0, g = 0.0, b = 0.0, n = 0;
  final last = image.width - 1;
  for (var i = 0; i <= last; i++) {
    for (final (x, y) in [(i, 0), (i, last), (0, i), (last, i)]) {
      final p = image.getPixel(x, y);
      r += p.r;
      g += p.g;
      b += p.b;
      n++;
    }
  }
  return img.ColorRgb8((r / n).round(), (g / n).round(), (b / n).round());
}

void _save(String path, img.Image image) {
  File(path).writeAsBytesSync(img.encodePng(image, level: 9));
  stdout.writeln('$path ${image.width}x${image.height}');
}
