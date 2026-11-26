/// Why speech-to-text failed, from the codes of the browser's Web Speech API
/// or of Android (CLAUDE.md section 11).
library;

enum SpeechProblem {
  noSpeech,

  /// The microphone is blocked or missing.
  permission,
  language,

  /// There is no working speech service here.
  unavailable,
  network,
  other,
}

SpeechProblem speechProblem(String code) => switch (code) {
  'no-speech' || 'error_no_match' || 'error_speech_timeout' =>
    SpeechProblem.noSpeech,
  'not-allowed' ||
  'audio-capture' ||
  'error_permission' ||
  'error_audio_error' => SpeechProblem.permission,
  'language-not-supported' ||
  'error_language_not_supported' ||
  'error_language_unavailable' => SpeechProblem.language,
  'service-not-allowed' ||
  'not supported' ||
  'speech_not_supported' => SpeechProblem.unavailable,
  'network' ||
  'error_network' ||
  'error_network_timeout' ||
  'error_server' => SpeechProblem.network,
  _ => SpeechProblem.other,
};

/// A button that cannot work is not shown.
bool micCannotWork(SpeechProblem problem) =>
    problem == SpeechProblem.permission ||
    problem == SpeechProblem.language ||
    problem == SpeechProblem.unavailable;

const String _keyboardInstead =
    'พิมพ์ในช่องด้านล่าง หรือกดไมค์บนคีย์บอร์ดมือถือแทนได้';

String speechProblemMessage(SpeechProblem problem) => switch (problem) {
  SpeechProblem.noSpeech => 'ไม่ได้ยินเสียงพูด ลองอีกครั้ง',
  SpeechProblem.permission =>
    'ใช้ไมค์ไม่ได้ เพราะไม่ได้รับอนุญาตหรือไม่มีไมโครโฟน $_keyboardInstead',
  SpeechProblem.language =>
    'ตัวแปลงเสียงนี้ยังไม่รองรับภาษาไทย $_keyboardInstead',
  SpeechProblem.unavailable =>
    'ที่นี่ยังใช้ไมค์ของแอปไม่ได้ $_keyboardInstead',
  SpeechProblem.network => 'ต่ออินเทอร์เน็ตไม่ได้ ลองอีกครั้ง หรือพิมพ์แทน',
  SpeechProblem.other => 'แปลงเสียงไม่สำเร็จ ลองอีกครั้ง หรือพิมพ์แทน',
};
