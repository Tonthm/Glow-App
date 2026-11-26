/// Gets a timetable picture ready to send: cut, shrunk and compressed on the
/// device. It is rebuilt from bare pixels, so nothing else in the original
/// file (EXIF, place, time) can go with it. Nothing here saves anything.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../core/area_crop.dart';

/// A picked file larger than this is turned away before it is opened.
const int maxPickedTimetableBytes = 25 * 1024 * 1024;

/// Longest side while cutting: more than is sent, so a small cut stays sharp.
const int _workingSide = 2400;

/// Throws if the file isn't a picture it can read.
Future<ui.Image> openTimetablePicture(Uint8List bytes) async {
  if (bytes.length > maxPickedTimetableBytes) {
    throw const FormatException('too large');
  }
  final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
  final codec = await ui.instantiateImageCodecWithSize(
    buffer,
    getTargetSize: (width, height) {
      if (math.max(width, height) <= _workingSide) {
        return const ui.TargetImageSize();
      }
      final size = fitWithin(width, height, _workingSide);
      return ui.TargetImageSize(width: size.width, height: size.height);
    },
  );
  try {
    return (await codec.getNextFrame()).image;
  } finally {
    codec.dispose();
  }
}

/// The part of [source] inside [area], as a JPEG small enough to send.
Future<Uint8List> timetableJpeg(ui.Image source, CropArea area) async {
  final rect = area.inPixels(width: source.width, height: source.height);
  var side = timetableImageSide;
  while (side >= 400) {
    final size = fitWithin(rect.width, rect.height, side);
    final recorder = ui.PictureRecorder();
    final target = ui.Rect.fromLTWH(
      0,
      0,
      size.width.toDouble(),
      size.height.toDouble(),
    );
    ui.Canvas(recorder)
      // See-through parts become white: JPEG has no transparency.
      ..drawRect(target, ui.Paint()..color = const ui.Color(0xFFFFFFFF))
      ..drawImageRect(
        source,
        ui.Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height),
        target,
        ui.Paint()..filterQuality = ui.FilterQuality.high,
      );
    final picture = recorder.endRecording();
    final cut = await picture.toImage(size.width, size.height);
    picture.dispose();
    final data = await cut.toByteData(format: ui.ImageByteFormat.rawRgba);
    cut.dispose();
    final pixels = img.Image.fromBytes(
      width: size.width,
      height: size.height,
      bytes: Uint8List.fromList(data!.buffer.asUint8List()).buffer,
      numChannels: 4,
    ).convert(numChannels: 3);
    for (final quality in timetableImageQualities) {
      final jpeg = img.encodeJpg(pixels, quality: quality);
      if (jpeg.length <= maxTimetableImageBytes) return jpeg;
    }
    side = side * 4 ~/ 5;
  }
  throw const FormatException('cannot be made small enough');
}
