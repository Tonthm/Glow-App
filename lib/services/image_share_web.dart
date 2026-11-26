import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'file_saver_web.dart';
import 'image_share_base.dart';

ImageSharer platformImageSharer() => _BrowserImageSharer();

web.ShareData _data(Uint8List png, String name) => web.ShareData(
  files: [
    web.File([png.toJS].toJS, name, web.FilePropertyBag(type: 'image/png')),
  ].toJS,
);

class _BrowserImageSharer implements ImageSharer {
  @override
  late final bool canShare = _askBrowser();

  bool _askBrowser() {
    final navigator = web.window.navigator as JSObject;
    if (!navigator.has('share') || !navigator.has('canShare')) return false;
    try {
      return web.window.navigator.canShare(_data(Uint8List(8), 'glow.png'));
    } catch (_) {
      return false;
    }
  }

  @override
  Future<ShareOutcome> share(Uint8List png, String name) async {
    try {
      // Nothing may be awaited before this call (see [ImageSharer.share]).
      await web.window.navigator.share(_data(png, name)).toDart;
      return ShareOutcome.done;
    } catch (e) {
      // Closing the share sheet is reported as an AbortError.
      return '$e'.contains('AbortError')
          ? ShareOutcome.cancelled
          : ShareOutcome.failed;
    }
  }

  @override
  Future<bool> download(Uint8List png, String name) =>
      saveFile(name, png, 'image/png');
}
