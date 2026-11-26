import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// speech_to_text builds its recogniser from the "webkit" name only, so that
/// is the one that has to exist. Having it doesn't prove it works: an
/// installed iPhone app may still refuse, which only shows when it is used.
bool deviceHasSpeech() => globalContext.has('webkitSpeechRecognition');

/// Browsers want a hyphen.
const String thaiSpeechLocale = 'th-TH';
