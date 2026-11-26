import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/card_photo.dart';
import 'package:glow/services/photo_processor.dart';
import 'package:image/image.dart' as img;

bool _contains(Uint8List bytes, String text) =>
    latin1.decode(bytes).contains(text);

/// A phone-sized JPEG that says who took it and where: red on the left half,
/// blue on the right.
Uint8List _cameraPicture() {
  final picture = img.Image(width: 3000, height: 2000);
  for (final p in picture) {
    p.setRgb(p.x < 1500 ? 220 : 20, 20, p.x < 1500 ? 20 : 220);
  }
  picture.exif.imageIfd['Artist'] = img.IfdValueAscii('SECRET-NAME');
  picture.exif.gpsIfd[2] = img.IfdValueAscii('SECRET-PLACE');
  return img.encodeJpg(picture);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a picked picture becomes a small clean card photo', () async {
    final picked = _cameraPicture();
    expect(_contains(picked, 'SECRET-NAME'), isTrue);

    final opened = await openPickedPhoto(picked);
    // Scaled down before cutting.
    expect(opened.width, 1600);
    expect(opened.height, closeTo(1067, 1));

    // The left part only.
    final jpeg = await renderCardPhoto(
      opened,
      const PhotoCrop(
        zoom: 2,
        centerX: 0.2,
      ).rectIn(width: opened.width, height: opened.height),
    );
    opened.dispose();

    expect(jpeg.sublist(0, 2), [0xFF, 0xD8]);
    expect(jpeg.length, lessThanOrEqualTo(maxCardPhotoBytes));
    expect(_contains(jpeg, 'Exif'), isFalse);
    expect(_contains(jpeg, 'SECRET'), isFalse);
    final saved = img.decodeJpg(jpeg)!;
    expect((saved.width, saved.height), (cardPhotoWidth, cardPhotoHeight));
    final middle = saved.getPixel(200, 250);
    expect(middle.r, greaterThan(180));
    expect(middle.b, lessThan(60));
  });

  test('even a very busy picture fits the size limit', () {
    final noise = Uint8List(cardPhotoWidth * cardPhotoHeight * 4);
    var seed = 12345;
    for (var i = 0; i < noise.length; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      noise[i] = i % 4 == 3 ? 255 : (seed >> 16) & 0xFF;
    }
    expect(
      encodeCardJpeg(noise).length,
      lessThanOrEqualTo(maxCardPhotoBytes),
    );
  });

  test('a file that is not a picture is refused', () async {
    await expectLater(
      openPickedPhoto(Uint8List.fromList(utf8.encode('hello'))),
      throwsA(anything),
    );
  });
}
