import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/features/card/photo_field.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/photo_picker.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';

class _OnePhoto implements PhotoPicker {
  @override
  Future<Uint8List?> pick(PhotoFrom from, {bool selfie = true}) async =>
      img.encodeJpg(img.Image(width: 600, height: 400));
}

void main() {
  testWidgets('picking, cropping and closing the crop screen', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Uint8List? saved;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [photoPickerProvider.overrideWithValue(_OnePhoto())],
        child: MaterialApp(
          home: Scaffold(
            body: PhotoField(
              photo: null,
              onChanged: (jpeg) async => saved = jpeg,
            ),
          ),
        ),
      ),
    );

    /// Decoding and drawing pictures runs outside the test clock.
    Future<void> until(bool Function() done) async {
      for (var i = 0; i < 200 && !done(); i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(done(), isTrue);
    }

    await tester.tap(find.text('เลือกรูป'));
    await until(() => find.text('ใช้รูปนี้').evaluate().isNotEmpty);
    // Let the screen slide in, then drag the picture a little.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.drag(
      find.bySemanticsLabel('ตัวอย่างรูปบนบัตร'),
      const Offset(40, 0),
    );
    await tester.pump();

    await tester.tap(find.text('ใช้รูปนี้'));
    await until(() => saved != null);
    // Every frame while the screen slides away, still showing the picture.
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull);
    }
    expect(find.text('ใช้รูปนี้'), findsNothing);
    expect(saved!.sublist(0, 2), [0xFF, 0xD8]);
  });
}
