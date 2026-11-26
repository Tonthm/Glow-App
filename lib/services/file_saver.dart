/// Saves a file for the user: a "save as" screen on Android, a download in
/// the browser. `saveFile` returns false if the user cancelled.
library;

export 'file_saver_io.dart' if (dart.library.js_interop) 'file_saver_web.dart';
