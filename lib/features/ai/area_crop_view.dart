import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

import '../../core/area_crop.dart';

const double _touch = 48;

/// A picture with four corners to drag around the part to keep.
class AreaCropView extends StatelessWidget {
  final ui.Image picture;
  final CropArea area;
  final ValueChanged<CropArea> onChanged;

  const AreaCropView({
    super.key,
    required this.picture,
    required this.area,
    required this.onChanged,
  });

  static const _cornerNames = {
    CropCorner.topLeft: 'มุมบนซ้าย',
    CropCorner.topRight: 'มุมบนขวา',
    CropCorner.bottomLeft: 'มุมล่างซ้าย',
    CropCorner.bottomRight: 'มุมล่างขวา',
  };

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    // The handles sit inside this box with the picture, set in by half a
    // handle: a touch outside a parent's bounds never reaches the child.
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(
          (constraints.maxWidth - _touch) / picture.width,
          (constraints.maxHeight - _touch) / picture.height,
        );
        final double width = picture.width * math.max(scale, 0.0);
        final double height = picture.height * math.max(scale, 0.0);
        return Center(
          child: SizedBox(
            width: width + _touch,
            height: height + _touch,
            child: Stack(
              children: [
                Positioned(
                  left: _touch / 2,
                  top: _touch / 2,
                  width: width,
                  height: height,
                  child: CustomPaint(
                    painter: _AreaPainter(picture, area, accent),
                  ),
                ),
                for (final MapEntry(key: corner, value: name)
                    in _cornerNames.entries)
                  Positioned(
                    left:
                        width *
                        (corner == CropCorner.topLeft ||
                                corner == CropCorner.bottomLeft
                            ? area.left
                            : area.right),
                    top:
                        height *
                        (corner == CropCorner.topLeft ||
                                corner == CropCorner.topRight
                            ? area.top
                            : area.bottom),
                    child: Semantics(
                      label: 'ลาก$nameเพื่อครอบตัด',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (details) => onChanged(
                          area.dragCorner(
                            corner,
                            dx: details.delta.dx / width,
                            dy: details.delta.dy / height,
                          ),
                        ),
                        child: SizedBox.square(
                          dimension: _touch,
                          child: Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AreaPainter extends CustomPainter {
  final ui.Image picture;
  final CropArea area;
  final Color accent;

  const _AreaPainter(this.picture, this.area, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final whole = Offset.zero & size;
    canvas.drawImageRect(
      picture,
      Rect.fromLTWH(
        0,
        0,
        picture.width.toDouble(),
        picture.height.toDouble(),
      ),
      whole,
      Paint()..filterQuality = FilterQuality.medium,
    );
    final kept = Rect.fromLTRB(
      area.left * size.width,
      area.top * size.height,
      area.right * size.width,
      area.bottom * size.height,
    );
    // What will be left out is dimmed.
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(whole),
        Path()..addRect(kept),
      ),
      Paint()..color = const Color(0xAA000000),
    );
    canvas.drawRect(
      kept,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent,
    );
  }

  @override
  bool shouldRepaint(_AreaPainter old) =>
      old.area != area || old.picture != picture;
}
