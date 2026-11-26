import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import 'file_saver_web.dart';

Future<void> sharePng(Uint8List bytes, String name) async {
  try {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'image/png')],
        fileNameOverrides: [name],
        downloadFallbackEnabled: false,
      ),
    );
  } catch (_) {
    await saveFile(name, bytes, 'image/png');
  }
}
