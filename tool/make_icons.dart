// Makes opaque PWA icons from the transparent Figma mascot.
// Run from the project folder: dart run tool/make_icons.dart
import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final mascot = img.decodePng(File('assets/mascot.png').readAsBytesSync());
  if (mascot == null) throw const FormatException('Cannot read Glow mascot');
  for (final (path, side, scale) in [
    ('assets/logo_square.png', 512, 0.88),
    ('web/favicon.png', 64, 0.88),
    ('web/icons/apple-touch-icon.png', 180, 0.88),
    ('web/icons/Icon-192.png', 192, 0.88),
    ('web/icons/Icon-512.png', 512, 0.88),
    ('web/icons/Icon-maskable-192.png', 192, 0.70),
    ('web/icons/Icon-maskable-512.png', 512, 0.70),
  ]) {
    final canvas = img.Image(width: side, height: side, numChannels: 3);
    img.fill(canvas, color: img.ColorRgb8(255, 249, 240));
    final picture = img.copyResize(
      mascot,
      width: (side * scale).round(),
      interpolation: img.Interpolation.average,
    );
    img.compositeImage(
      canvas,
      picture,
      dstX: (side - picture.width) ~/ 2,
      dstY: (side - picture.height) ~/ 2,
    );
    // iPhone needs an opaque icon; transparent areas can otherwise turn black.
    if (canvas.any((pixel) => pixel.a != 255)) {
      throw StateError('Transparent pixels in $path');
    }
    File(path).writeAsBytesSync(img.encodePng(canvas, level: 9));
    stdout.writeln('$path ${side}x$side');
  }
}
