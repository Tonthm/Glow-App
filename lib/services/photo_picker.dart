import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Where a picture comes from.
enum PhotoFrom { gallery, camera }

/// Asks the phone or browser for one picture. On the web, Safari only opens
/// the picker straight from a tap, so call this before any other waiting.
abstract interface class PhotoPicker {
  /// The picked file's bytes, or null if the user backed out.
  /// [selfie] asks for the front camera.
  Future<Uint8List?> pick(PhotoFrom from, {bool selfie = true});
}

class DevicePhotoPicker implements PhotoPicker {
  final _picker = ImagePicker();

  @override
  Future<Uint8List?> pick(PhotoFrom from, {bool selfie = true}) async {
    final file = await _picker.pickImage(
      source: from == PhotoFrom.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      preferredCameraDevice: selfie ? CameraDevice.front : CameraDevice.rear,
      // The photo's place and time aren't wanted.
      requestFullMetadata: false,
    );
    return file?.readAsBytes();
  }
}
