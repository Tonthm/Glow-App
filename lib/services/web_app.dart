/// Things only an installed web app deals with (CLAUDE.md section 17). The
/// Android versions do nothing.
library;

export 'web_app_io.dart' if (dart.library.js_interop) 'web_app_web.dart';
