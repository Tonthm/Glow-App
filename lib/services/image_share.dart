/// Handing a picture to the user: the system share sheet where it takes
/// files, otherwise a download.
library;

import 'image_share_base.dart';
import 'image_share_io.dart'
    if (dart.library.js_interop) 'image_share_web.dart';

export 'image_share_base.dart';

ImageSharer createImageSharer() => platformImageSharer();
