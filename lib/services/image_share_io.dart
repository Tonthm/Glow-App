import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'file_saver_io.dart';
import 'image_share_base.dart';

ImageSharer platformImageSharer() => _PhoneImageSharer();

class _PhoneImageSharer implements ImageSharer {
  @override
  bool get canShare => true;

  @override
  Future<ShareOutcome> share(Uint8List png, String name) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(png);
      final result = await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
      );
      return result.status == ShareResultStatus.dismissed
          ? ShareOutcome.cancelled
          : ShareOutcome.done;
    } catch (_) {
      return ShareOutcome.failed;
    }
  }

  @override
  Future<bool> download(Uint8List png, String name) =>
      saveFile(name, png, 'image/png');
}
