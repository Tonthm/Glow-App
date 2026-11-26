import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

/// True when opened from the home screen icon.
bool isRunningStandalone() {
  if (web.window.matchMedia('(display-mode: standalone)').matches) return true;
  // Older iOS Safari only has this.
  final standalone = (web.window.navigator as JSObject).getProperty<JSAny?>(
    'standalone'.toJS,
  );
  return standalone.isA<JSBoolean>() && (standalone! as JSBoolean).toDart;
}

/// Asks the browser not to clear the database to free up space.
Future<void> requestPersistentStorage() async {
  try {
    await web.window.navigator.storage.persist().toDart;
  } catch (_) {
    // Not supported; the install guide and backup bar still help.
  }
}

// Both defined in web/index.html.
@JS('glowUpdateReady')
external bool _updateReady();

@JS('glowApplyUpdate')
external void _applyUpdate();

bool isUpdateReady() {
  try {
    return _updateReady();
  } catch (_) {
    return false;
  }
}

void applyUpdate() => _applyUpdate();
