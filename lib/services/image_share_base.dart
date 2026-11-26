import 'dart:typed_data';

enum ShareOutcome { done, cancelled, failed }

abstract interface class ImageSharer {
  /// Whether the share sheet takes a picture file here. Where it doesn't,
  /// no share button is shown.
  bool get canShare;

  /// Call straight from a tap, with the picture already made: Safari refuses
  /// to share after other waiting.
  Future<ShareOutcome> share(Uint8List png, String name);

  /// Saves the file. False if the user backed out.
  Future<bool> download(Uint8List png, String name);
}
