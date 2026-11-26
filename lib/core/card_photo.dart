/// The photo on the student card: its size, and which part of the picked
/// picture is kept (CLAUDE.md section 19).
library;

import 'dart:math' as math;

/// The saved picture, 4 wide by 5 tall.
const int cardPhotoWidth = 400;
const int cardPhotoHeight = 500;
const double cardPhotoAspect = cardPhotoWidth / cardPhotoHeight;

/// The most a saved photo may take. It is compressed harder until it fits.
const int maxCardPhotoBytes = 150 * 1024;
const List<int> cardPhotoQualities = [82, 70, 55, 40, 25];

/// A picked file larger than this is turned away before it is opened.
const int maxPickedPhotoBytes = 25 * 1024 * 1024;

const double maxPhotoZoom = 5;

/// A part of a picture, in its own pixels.
typedef PhotoRect = ({double left, double top, double width, double height});

/// Where the user has zoomed and dragged to. The center is a share of the
/// picture, 0 to 1, so it doesn't depend on the picture's size.
class PhotoCrop {
  final double zoom;
  final double centerX;
  final double centerY;

  const PhotoCrop({this.zoom = 1, this.centerX = 0.5, this.centerY = 0.5});

  PhotoCrop zoomed(double value) => PhotoCrop(
    zoom: value.clamp(1, maxPhotoZoom),
    centerX: centerX,
    centerY: centerY,
  );

  /// The part kept, always inside the picture and 4:5.
  PhotoRect rectIn({required int width, required int height}) {
    final fullWidth = math.min(width.toDouble(), height * cardPhotoAspect);
    final w = fullWidth / zoom.clamp(1, maxPhotoZoom);
    final h = w / cardPhotoAspect;
    double start(double center, double size, int total) =>
        (center * total - size / 2).clamp(0, math.max(0, total - size));
    return (
      left: start(centerX, w, width),
      top: start(centerY, h, height),
      width: w,
      height: h,
    );
  }

  /// After a finger moved [dx], [dy] on a preview [viewWidth] wide: the
  /// picture follows the finger, so the kept part moves the other way.
  PhotoCrop moved({
    required double dx,
    required double dy,
    required double viewWidth,
    required int width,
    required int height,
  }) {
    // Starting from the real rectangle drops any push past the edge.
    final rect = rectIn(width: width, height: height);
    final scale = rect.width / viewWidth;
    return PhotoCrop(
      zoom: zoom,
      centerX: (rect.left + rect.width / 2 - dx * scale) / width,
      centerY: (rect.top + rect.height / 2 - dy * scale) / height,
    );
  }
}
