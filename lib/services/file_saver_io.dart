import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<bool> saveFile(String name, Uint8List bytes, String mimeType) async {
  final uri = await FilePicker.saveFile(
    fileName: name,
    bytes: bytes,
    mimeType: mimeType,
  );
  return uri != null;
}
