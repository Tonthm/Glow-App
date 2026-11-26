import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// A download can't report whether the user kept it, so this is always true.
Future<bool> saveFile(String name, Uint8List bytes, String mimeType) async {
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  final link = web.HTMLAnchorElement()
    ..href = url
    ..download = name;
  web.document.body!.append(link);
  link.click();
  link.remove();
  // Safari may still be reading it right after the click.
  Future.delayed(
    const Duration(seconds: 30),
    () => web.URL.revokeObjectURL(url),
  );
  return true;
}
