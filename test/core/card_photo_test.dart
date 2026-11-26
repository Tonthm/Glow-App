import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/card_photo.dart';

void main() {
  // The photo slot is 4 wide by 5 tall.
  test('starts with the biggest cut from the middle', () {
    // A wide picture is limited by its height.
    final wide = const PhotoCrop().rectIn(width: 2000, height: 1000);
    expect(wide, (left: 600.0, top: 0.0, width: 800.0, height: 1000.0));
    // A tall one by its width.
    final tall = const PhotoCrop().rectIn(width: 800, height: 2000);
    expect(tall, (left: 0.0, top: 500.0, width: 800.0, height: 1000.0));
  });

  test('zooming in cuts a smaller part around the same middle', () {
    final rect = const PhotoCrop(zoom: 2).rectIn(width: 800, height: 1000);
    expect(rect, (left: 200.0, top: 250.0, width: 400.0, height: 500.0));
  });

  test('the cut can never leave the picture', () {
    for (final crop in const [
      PhotoCrop(centerX: -3, centerY: -3),
      PhotoCrop(centerX: 4, centerY: 4),
      PhotoCrop(zoom: 3, centerX: 0, centerY: 1),
    ]) {
      final r = crop.rectIn(width: 1200, height: 900);
      expect(r.left, greaterThanOrEqualTo(0));
      expect(r.top, greaterThanOrEqualTo(0));
      expect(r.left + r.width, lessThanOrEqualTo(1200.0001));
      expect(r.top + r.height, lessThanOrEqualTo(900.0001));
      expect(r.width / r.height, closeTo(4 / 5, 0.0001));
    }
  });

  test('zoom stays within its limits', () {
    final out = const PhotoCrop(zoom: 0.2).rectIn(width: 800, height: 1000);
    expect(out.width, 800);
    final in_ = const PhotoCrop(zoom: 99).rectIn(width: 800, height: 1000);
    expect(in_.width, 800 / maxPhotoZoom);
  });

  test('dragging moves the cut the other way, by what the finger covers', () {
    // The 400-wide cut is shown in a 200-wide box: 1 on screen is 2 inside.
    final moved = const PhotoCrop(zoom: 2).moved(
      dx: 20,
      dy: -10,
      viewWidth: 200,
      width: 800,
      height: 1000,
    );
    final rect = moved.rectIn(width: 800, height: 1000);
    expect(rect.left, closeTo(160, 0.001));
    expect(rect.top, closeTo(270, 0.001));
  });

  test('dragging past the edge does not build up', () {
    var crop = const PhotoCrop(zoom: 2);
    crop = crop.moved(
      dx: 5000,
      dy: 0,
      viewWidth: 200,
      width: 800,
      height: 1000,
    );
    crop = crop.moved(
      dx: -10,
      dy: 0,
      viewWidth: 200,
      width: 800,
      height: 1000,
    );
    expect(crop.rectIn(width: 800, height: 1000).left, closeTo(20, 0.001));
  });
}
