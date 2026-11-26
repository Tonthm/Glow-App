/// Cutting a rectangle of any shape out of a picture, and the size it is sent
/// at (CLAUDE.md section 16, job 5).
library;

import 'dart:math' as math;

/// Longest side of a timetable picture as sent.
const int timetableImageSide = 1600;

/// The most a sent picture may weigh. Compressed harder, then made smaller,
/// until it fits.
const int maxTimetableImageBytes = 700 * 1024;
const List<int> timetableImageQualities = [85, 72, 60];

/// The smallest cut, as a share of each side.
const double minCropShare = 0.1;

enum CropCorner { topLeft, topRight, bottomLeft, bottomRight }

/// The kept part, as shares (0 to 1) of the picture.
class CropArea {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const CropArea({
    this.left = 0,
    this.top = 0,
    this.right = 1,
    this.bottom = 1,
  });

  /// [dx] and [dy] are shares of the picture's width and height.
  CropArea dragCorner(CropCorner corner, {double dx = 0, double dy = 0}) {
    final isLeft =
        corner == CropCorner.topLeft || corner == CropCorner.bottomLeft;
    final isTop = corner == CropCorner.topLeft || corner == CropCorner.topRight;
    return CropArea(
      left: isLeft ? (left + dx).clamp(0.0, right - minCropShare) : left,
      right: isLeft ? right : (right + dx).clamp(left + minCropShare, 1.0),
      top: isTop ? (top + dy).clamp(0.0, bottom - minCropShare) : top,
      bottom: isTop ? bottom : (bottom + dy).clamp(top + minCropShare, 1.0),
    );
  }

  ({double left, double top, double width, double height}) inPixels({
    required int width,
    required int height,
  }) => (
    left: left * width,
    top: top * height,
    width: (right - left) * width,
    height: (bottom - top) * height,
  );
}

/// [width] x [height] shrunk so neither side is over [side].
({int width, int height}) fitWithin(num width, num height, int side) {
  final scale = math.min(1.0, side / math.max(width, height));
  return (
    width: math.max(1, (width * scale).round()),
    height: math.max(1, (height * scale).round()),
  );
}
