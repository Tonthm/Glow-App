// Measures how well the AI reads real timetable pictures. Run from the
// project folder, with your own Gemini key in an environment variable:
//
//   $env:GEMINI_API_KEY = "..."      # PowerShell; never put it in a file
//   dart run tool/eval_timetable.dart
//
// Put 5 to 10 pictures in test_timetables/ (git ignores it). Next to each,
// a .json file with the same name lists what is really on it:
//
//   test_timetables/week1.png
//   test_timetables/week1.json:
//     [{"title": "คณิต", "day": "จันทร์", "start": "08:30", "end": "10:20"}]
//
// Every picture is sent to Google. Crop out names and student numbers first.
// An item counts as correct only if name, day, start and end all match.
// Quote no accuracy that this run didn't measure.
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:glow/core/ai_config.dart';
import 'package:glow/core/ai_payload.dart';
import 'package:glow/core/area_crop.dart';
import 'package:glow/core/timetable_import.dart';
import 'package:glow/services/ai/ai_client.dart';
import 'package:glow/services/ai/gemini_ai_client.dart';
import 'package:image/image.dart' as img;

const _folder = 'test_timetables';

/// The same size limits as the app, and no metadata.
Uint8List _prepare(File file) {
  final decoded = img.decodeImage(file.readAsBytesSync());
  if (decoded == null) throw const FormatException('not a picture');
  var picture = img.bakeOrientation(decoded);
  var side = timetableImageSide;
  while (side >= 400) {
    final size = fitWithin(picture.width, picture.height, side);
    final small = img.copyResize(
      picture,
      width: size.width,
      height: size.height,
      interpolation: img.Interpolation.average,
    )..exif = img.ExifData();
    for (final quality in timetableImageQualities) {
      final jpeg = img.encodeJpg(small, quality: quality);
      if (jpeg.length <= maxTimetableImageBytes) return jpeg;
    }
    side = side * 4 ~/ 5;
  }
  throw const FormatException('cannot be made small enough');
}

List<ImportedClass> _expected(File file) {
  final list = jsonDecode(file.readAsStringSync()) as List;
  return [
    for (final item in list.cast<Map<String, dynamic>>())
      ImportedClass(
        title: item['title'] as String,
        day: parseDayName(item['day'] as String)!,
        startMinutes: parseClock(item['start'] as String)!,
        endMinutes: parseClock(item['end'] as String)!,
        confidence: 1,
      ),
  ];
}

Future<void> main(List<String> args) async {
  final key = Platform.environment['GEMINI_API_KEY'] ?? '';
  if (key.isEmpty) {
    stderr.writeln('Set GEMINI_API_KEY first (see the top of this file).');
    exit(64);
  }
  final model = args.isEmpty ? aiDefaultModel : args.first;
  final folder = Directory(_folder);
  final pictures = !folder.existsSync()
      ? <File>[]
      : (folder
            .listSync()
            .whereType<File>()
            .where(
              (f) => RegExp(
                r'\.(png|jpe?g)$',
                caseSensitive: false,
              ).hasMatch(f.path),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path)));
  if (pictures.isEmpty) {
    stderr.writeln('No pictures in $_folder/.');
    exit(66);
  }

  final client = GeminiAiClient(timeout: const Duration(seconds: 15));
  var correct = 0, expected = 0, extra = 0, failed = 0, measured = 0;
  for (final picture in pictures) {
    final name = picture.uri.pathSegments.last;
    final answers = File(
      picture.path.replaceFirst(RegExp(r'\.[^.]+$'), '.json'),
    );
    if (!answers.existsSync()) {
      print('$name: skipped, no .json with the right answers');
      continue;
    }
    try {
      final want = _expected(answers);
      final jpeg = _prepare(picture);
      final request = buildTimetableRequest(jpeg);
      final answer = await client.complete(
        request!,
        apiKey: key,
        model: model,
      );
      final reading = parseTimetable(answer);
      measured++;
      expected += want.length;
      if (reading == null) {
        failed++;
        print('$name: answer in the wrong shape, 0/${want.length}');
        continue;
      }
      final score = scoreReading(expected: want, read: reading.items);
      correct += score.correct;
      extra += score.extra;
      print(
        '$name: ${score.correct}/${score.expected} correct, '
        '${score.extra} wrong or extra, ${reading.dropped} dropped by checks',
      );
    } on AiException catch (e) {
      // Not counted: the reading never happened.
      print('$name: request failed ($e)');
      failed++;
    } catch (e) {
      print('$name: could not be checked (${e.runtimeType})');
      failed++;
    }
  }
  print(
    '\nModel $model, $measured of ${pictures.length} pictures answered: '
    '$correct of $expected classes correct, $extra wrong or extra, '
    '$failed pictures with a problem.',
  );
  exit(0);
}
