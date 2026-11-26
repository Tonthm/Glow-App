import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/area_crop.dart';

void main() {
  const full = CropArea();

  test('starts as the whole picture', () {
    expect(full.inPixels(width: 800, height: 600), (
      left: 0.0,
      top: 0.0,
      width: 800.0,
      height: 600.0,
    ));
  });

  test('dragging a corner moves only its two sides', () {
    final cut = full.dragCorner(CropCorner.topLeft, dx: 0.25, dy: 0.1);
    expect((cut.left, cut.top, cut.right, cut.bottom), (0.25, 0.1, 1, 1));
    final other = cut.dragCorner(CropCorner.bottomRight, dx: -0.25, dy: -0.4);
    expect(
      (other.left, other.top, other.right, other.bottom),
      (0.25, 0.1, 0.75, 0.6),
    );
  });

  test('stays inside the picture and keeps a smallest size', () {
    final out = full.dragCorner(CropCorner.topRight, dx: 5, dy: -5);
    expect((out.right, out.top), (1, 0));
    final tiny = full.dragCorner(CropCorner.topLeft, dx: 5, dy: 5);
    expect(tiny.right - tiny.left, closeTo(minCropShare, 1e-9));
    expect(tiny.bottom - tiny.top, closeTo(minCropShare, 1e-9));
  });

  test('keeps the picture within the longest side allowed', () {
    expect(fitWithin(4000, 3000, 1600), (width: 1600, height: 1200));
    expect(fitWithin(900, 3600, 1600), (width: 400, height: 1600));
    // Never made bigger.
    expect(fitWithin(600, 400, 1600), (width: 600, height: 400));
    expect(fitWithin(1, 9000, 1600), (width: 1, height: 1600));
  });
}
