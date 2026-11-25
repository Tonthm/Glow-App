import 'package:flutter/services.dart';

/// Keeps the screen on while stretching, so it doesn't dim mid-pose. Does
/// nothing where the platform side isn't there (tests, other platforms).
class ScreenService {
  static const _channel = MethodChannel('glow/screen');

  Future<void> keepOn(bool value) async {
    try {
      await _channel.invokeMethod<void>('keepOn', value);
    } on MissingPluginException {
      // No platform side.
    }
  }
}
