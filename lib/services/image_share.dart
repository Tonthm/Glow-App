/// Opens the system share sheet with a picture; the web version downloads it
/// where sharing files isn't possible.
library;

export 'image_share_io.dart'
    if (dart.library.js_interop) 'image_share_web.dart';
