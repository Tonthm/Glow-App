/// The shared picture itself: really see-through, clear of the parts a story
/// covers, and the same size however it is set up.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/check_in.dart';
import 'package:glow/core/story_share.dart';
import 'package:glow/features/share/story_painter.dart';
import 'package:glow/features/share/story_samples.dart';
import 'package:glow/services/photo_processor.dart';
import 'package:image/image.dart' as img;

final now = DateTime(2026, 11, 27, 9);

/// The app's own fonts. Without them every letter is a black box, and the
/// sizes would be wrong.
Future<void> loadFonts() async {
  for (final (family, file) in [
    ('Fredoka', 'assets/fonts/Fredoka.ttf'),
    ('IBMPlexSansThai', 'assets/fonts/IBMPlexSansThai-Regular.ttf'),
    ('IBMPlexSansThai', 'assets/fonts/IBMPlexSansThai-SemiBold.ttf'),
    ('Nunito', 'assets/fonts/Nunito.ttf'),
    ('NotoSansThai', 'assets/fonts/NotoSansThai.ttf'),
  ]) {
    final bytes = File(file).readAsBytesSync();
    await (FontLoader(
      family,
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
}

StorySummary sample(StorySample set, StoryView view) =>
    buildStory(set.nights(now), view, now: now, fallAsleepMinutes: 15);

/// First and last rows with anything on them.
(int, int) paintedRows(img.Image picture) {
  var first = picture.height;
  var last = -1;
  for (final pixel in picture) {
    if (pixel.a == 0) continue;
    if (pixel.y < first) first = pixel.y;
    if (pixel.y > last) last = pixel.y;
  }
  return (first, last);
}

void main() {
  late ui.Image logo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
    logo = await openPickedPhoto(
      File('assets/logo_square.png').readAsBytesSync(),
    );
  });

  Future<img.Image> render(
    StorySummary story,
    StoryOptions options, {
    ui.Image? photo,
  }) async => img.decodePng(
    await renderStoryPng(story, options, logo: logo, photo: photo),
  )!;

  test('it is a 1080 x 1920 PNG with a see-through background', () async {
    final picture = await render(
      sample(StorySample.mixedWeek, StoryView.week),
      const StoryOptions(),
    );
    expect((picture.width, picture.height), (1080, 1920));
    expect(picture.numChannels, 4);
    for (final (x, y) in [
      (0, 0),
      (1079, 0),
      (0, 1919),
      (1079, 1919),
      (540, 20),
      (30, 960),
      (540, 1900),
    ]) {
      expect(picture.getPixel(x, y).a, 0, reason: 'at $x, $y');
    }
    // And it is not simply empty.
    final solid = picture.where((p) => p.a == 255).length;
    expect(solid, greaterThan(20000));
    expect(solid, lessThan(1080 * 1920 ~/ 4));
  });

  test('every kind stays out of the top and bottom margins', () async {
    for (final view in StoryView.values) {
      for (final position in StoryPosition.values) {
        for (final darkText in [false, true]) {
          final picture = await render(
            // Missing nights add the longest layout: the note below.
            sample(StorySample.mixedMonth, view),
            StoryOptions(position: position, darkText: darkText),
          );
          final (first, last) = paintedRows(picture);
          final what = '$view $position dark=$darkText';
          expect(first, greaterThanOrEqualTo(250), reason: what);
          expect(last, lessThan(1920 - 250), reason: what);
        }
      }
    }
  });

  test('position moves the numbers', () async {
    final story = sample(StorySample.allFullWeek, StoryView.week);
    Future<int> firstRow(StoryPosition position) async => paintedRows(
      await render(story, StoryOptions(position: position, showLogo: false)),
    ).$1;
    final top = await firstRow(StoryPosition.top);
    final middle = await firstRow(StoryPosition.middle);
    final bottom = await firstRow(StoryPosition.bottom);
    expect(top, lessThan(middle));
    expect(middle, lessThan(bottom));
  });

  test('the logo and the times can each be left off', () async {
    final story = sample(StorySample.allFullWeek, StoryView.night);
    Future<int> painted(StoryOptions options) async =>
        (await render(story, options)).where((p) => p.a > 0).length;
    final all = await painted(const StoryOptions());
    expect(await painted(const StoryOptions(showLogo: false)), lessThan(all));
    expect(await painted(const StoryOptions(showTimes: false)), lessThan(all));
  });

  test('text is white, or dark for bright photos', () async {
    final story = sample(StorySample.allFullWeek, StoryView.night);
    Future<(int, int)> whiteAndDark(bool darkText) async {
      final picture = await render(
        story,
        StoryOptions(darkText: darkText, showLogo: false),
      );
      final solid = picture.where((p) => p.a == 255);
      return (
        solid.where((p) => p.r > 240 && p.g > 240 && p.b > 240).length,
        solid.where((p) => p.r < 50 && p.g < 50 && p.b < 60).length,
      );
    }

    final (lightWhite, lightDark) = await whiteAndDark(false);
    expect(lightWhite, greaterThan(lightDark));
    final (darkWhite, darkDark) = await whiteAndDark(true);
    expect(darkDark, greaterThan(darkWhite));
  });

  test('with nothing recorded the picture is empty', () async {
    final picture = await render(
      buildStory(const [], StoryView.week, now: now, fallAsleepMinutes: 15),
      const StoryOptions(),
    );
    expect(picture.every((p) => p.a == 0), isTrue);
  });

  test('on a photo it becomes one solid picture', () async {
    final green = img.Image(width: 400, height: 300);
    img.fill(green, color: img.ColorRgb8(0, 120, 40));
    final photo = await openPickedPhoto(img.encodePng(green));
    final picture = await render(
      sample(StorySample.allShortWeek, StoryView.week),
      const StoryOptions(),
      photo: photo,
    );
    expect((picture.width, picture.height), (1080, 1920));
    expect(picture.every((p) => p.a == 255), isTrue);
    final corner = picture.getPixel(0, 0);
    expect((corner.r, corner.g, corner.b), (0, 120, 40));
  });

  test('the sample sets are what their names say', () {
    List<StoryDot> dots(StorySample set, StoryView view) => [
      for (final c in sample(set, view).cells) c.dot,
    ];
    expect(
      dots(StorySample.allFullWeek, StoryView.week),
      List.filled(7, StoryDot.full),
    );
    expect(
      dots(StorySample.allShortWeek, StoryView.week),
      List.filled(7, StoryDot.veryShort),
    );
    expect(
      dots(StorySample.mixedWeek, StoryView.week).toSet(),
      StoryDot.values.toSet(),
    );
    final month = sample(StorySample.mixedMonth, StoryView.month);
    expect(month.cells.map((c) => c.dot).toSet(), StoryDot.values.toSet());
    expect(month.nightsWithData, greaterThan(20));
    final midnight = sample(StorySample.acrossMidnight, StoryView.week);
    expect(midnight.bedMinutes! < 60 || midnight.bedMinutes! > 23 * 60, isTrue);
    // Each sample's verdicts match the app's own rule for its hours.
    for (final set in StorySample.values) {
      for (final n in set.nights(now)) {
        final slept = n.wakeAt.difference(n.lightsOffAt).inMinutes - 15;
        final expected = slept >= 480
            ? CheckInResult.enough
            : slept >= 420
            ? CheckInResult.almostEnough
            : CheckInResult.notEnough;
        expect(n.result, expected, reason: '$set ${n.wakeDate}');
      }
    }
  });

  /// Writes every picture, over a see-through background, to the folder in
  /// STORY_OUT, to look at by eye.
  test('write the samples for viewing', () async {
    final out = Platform.environment['STORY_OUT'];
    if (out == null) return;
    Directory(out).createSync(recursive: true);
    for (final set in StorySample.values) {
      for (final view in StoryView.values) {
        for (final dark in [false, true]) {
          final png = await renderStoryPng(
            sample(set, view),
            StoryOptions(darkText: dark),
            logo: logo,
          );
          File('$out/${set.name}_${view.name}_${dark ? 'dark' : 'light'}.png')
              .writeAsBytesSync(png);
        }
      }
    }
    for (final position in [StoryPosition.top, StoryPosition.bottom]) {
      File('$out/position_${position.name}.png').writeAsBytesSync(
        await renderStoryPng(
          sample(StorySample.mixedMonth, StoryView.month),
          StoryOptions(position: position),
          logo: logo,
        ),
      );
    }
  });
}
