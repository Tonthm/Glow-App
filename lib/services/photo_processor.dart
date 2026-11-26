/// Turns a picked picture into the small JPEG kept on the card. Everything
/// happens on the device. The result is built from bare pixels, so nothing
/// else in the original file (EXIF, place, time) can come along.
library;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../core/card_photo.dart';

/// Longest side of the picture while it is being cut.
const int _workingSide = 1600;

/// Opens a picked file, scaled down so a large camera picture fits in memory.
/// The phone or browser does the decoding.
/// Throws if the file isn't a picture it can read.
Future<ui.Image> openPickedPhoto(
  Uint8List bytes, {
  int maxSide = _workingSide,
}) async {
  if (bytes.length > maxPickedPhotoBytes) {
    throw const FormatException('too large');
  }
  final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
  // The codec takes over the buffer and releases it.
  final codec = await ui.instantiateImageCodecWithSize(
    buffer,
    getTargetSize: (width, height) {
      if (width <= maxSide && height <= maxSide) {
        return const ui.TargetImageSize();
      }
      return width >= height
          ? ui.TargetImageSize(width: maxSide)
          : ui.TargetImageSize(height: maxSide);
    },
  );
  try {
    return (await codec.getNextFrame()).image;
  } finally {
    codec.dispose();
  }
}

/// The part of [source] inside [rect], at the card's size.
Future<Uint8List> renderCardPhoto(ui.Image source, PhotoRect rect) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const target = ui.Rect.fromLTWH(
    0,
    0,
    cardPhotoWidth + 0.0,
    cardPhotoHeight + 0.0,
  );
  // See-through parts become white: JPEG has no transparency.
  canvas.drawRect(target, ui.Paint()..color = const ui.Color(0xFFFFFFFF));
  canvas.drawImageRect(
    source,
    ui.Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height),
    target,
    ui.Paint()..filterQuality = ui.FilterQuality.high,
  );
  final picture = recorder.endRecording();
  final cut = await picture.toImage(cardPhotoWidth, cardPhotoHeight);
  picture.dispose();
  final data = await cut.toByteData(format: ui.ImageByteFormat.rawRgba);
  cut.dispose();
  return encodeCardJpeg(data!.buffer.asUint8List());
}

/// [rgba] is one card-sized picture, 4 bytes a pixel.
Uint8List encodeCardJpeg(Uint8List rgba) {
  final pixels = img.Image.fromBytes(
    width: cardPhotoWidth,
    height: cardPhotoHeight,
    bytes: Uint8List.fromList(rgba).buffer,
    numChannels: 4,
  ).convert(numChannels: 3);
  for (final quality in cardPhotoQualities) {
    final jpeg = img.encodeJpg(pixels, quality: quality);
    if (jpeg.length <= maxCardPhotoBytes) return jpeg;
  }
  throw const FormatException('cannot be made small enough');
}
