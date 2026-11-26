import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/card_photo.dart';
import '../../services/photo_processor.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// Pinch, drag or use the slider to choose the part of [photo] that goes on
/// the card. Pops the finished JPEG, or null.
class PhotoCropScreen extends StatefulWidget {
  /// This screen takes it over and frees it when it closes.
  final ui.Image photo;

  const PhotoCropScreen({super.key, required this.photo});

  @override
  State<PhotoCropScreen> createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  PhotoCrop _crop = const PhotoCrop();
  double _zoomAtStart = 1;
  bool _saving = false;

  @override
  void dispose() {
    widget.photo.dispose();
    super.dispose();
  }

  int get _width => widget.photo.width;
  int get _height => widget.photo.height;

  Future<void> _use() async {
    setState(() => _saving = true);
    try {
      final Uint8List jpeg = await renderCardPhoto(
        widget.photo,
        _crop.rectIn(width: _width, height: _height),
      );
      if (mounted) Navigator.of(context).pop(jpeg);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ใช้รูปนี้ไม่ได้ ลองรูปอื่น')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('จัดรูปบนบัตร')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GlowSpacing.pageMargin),
          child: Column(
            children: [
              Text(
                'ลากเพื่อเลื่อน ใช้สองนิ้วหรือแถบด้านล่างเพื่อซูม',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GlowSpacing.md),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cardPhotoAspect,
                    child: LayoutBuilder(
                      builder: (context, constraints) => GestureDetector(
                        onScaleStart: (_) => _zoomAtStart = _crop.zoom,
                        onScaleUpdate: (details) => setState(() {
                          _crop = _crop
                              .zoomed(_zoomAtStart * details.scale)
                              .moved(
                                dx: details.focalPointDelta.dx,
                                dy: details.focalPointDelta.dy,
                                viewWidth: constraints.maxWidth,
                                width: _width,
                                height: _height,
                              );
                        }),
                        child: Semantics(
                          label: 'ตัวอย่างรูปบนบัตร',
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _CropPainter(
                              widget.photo,
                              _crop.rectIn(width: _width, height: _height),
                              Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Slider(
                value: _crop.zoom,
                min: 1,
                max: maxPhotoZoom,
                label: 'ซูม',
                onChanged: (v) => setState(() => _crop = _crop.zoomed(v)),
              ),
              GlowPrimaryButton(
                label: _saving ? 'กำลังทำรูป…' : 'ใช้รูปนี้',
                onPressed: _saving ? null : _use,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CropPainter extends CustomPainter {
  final ui.Image photo;
  final PhotoRect rect;
  final Color border;

  const _CropPainter(this.photo, this.rect, this.border);

  @override
  void paint(Canvas canvas, Size size) {
    final target = Offset.zero & size;
    canvas.drawImageRect(
      photo,
      Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height),
      target,
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.drawRect(
      target,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = GlowStroke.focus
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(_CropPainter old) =>
      old.rect != rect || old.photo != photo;
}
