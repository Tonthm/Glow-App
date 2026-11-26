/// Where demo mode keeps its time offset.
library;

export 'clock_offset_store_io.dart'
    if (dart.library.js_interop) 'clock_offset_store_web.dart';
