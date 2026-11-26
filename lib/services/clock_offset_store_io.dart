import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File> _offsetFile() async {
  final dir = await getApplicationSupportDirectory();
  return File('${dir.path}/demo_clock_offset');
}

Future<String?> readStoredClockOffset() async {
  final file = await _offsetFile();
  return await file.exists() ? file.readAsString() : null;
}

Future<void> writeStoredClockOffset(String value) async {
  final file = await _offsetFile();
  await file.writeAsString(value);
}
