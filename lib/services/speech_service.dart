import 'package:speech_to_text/speech_to_text.dart';

import 'speech_support.dart';

/// Thai speech-to-text using the phone's own recogniser (CLAUDE.md section
/// 11). Only turns audio into text; core/thai_schedule_parser does the rest.
class SpeechService {
  final SpeechToText _speech = SpeechToText();
  void Function(bool listening)? _onListeningChanged;
  void Function(String code)? _onError;

  /// Asks for the microphone the first time. False if it was refused or the
  /// phone has no speech recogniser.
  Future<bool> prepare() {
    return _speech.initialize(
      onStatus: (status) =>
          _onListeningChanged?.call(status == SpeechToText.listeningStatus),
      onError: (error) => _onError?.call(error.errorMsg),
    );
  }

  Future<void> listen({
    required void Function(String text) onText,
    required void Function(bool listening) onListeningChanged,
    required void Function(String code) onError,
  }) async {
    _onListeningChanged = onListeningChanged;
    _onError = onError;
    await _speech.listen(
      onResult: (result) => onText(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        localeId: thaiSpeechLocale,
        partialResults: true,
        listenMode: ListenMode.dictation,
        // A timetable has pauses between subjects.
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(seconds: 60),
      ),
    );
  }

  Future<void> stop() => _speech.stop();

  Future<void> cancel() async {
    _onListeningChanged = null;
    _onError = null;
    await _speech.cancel();
  }
}
