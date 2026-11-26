import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/speech_problem.dart';

void main() {
  test('reads browser and Android error codes alike', () {
    const expected = {
      // Web Speech API.
      'no-speech': SpeechProblem.noSpeech,
      'not-allowed': SpeechProblem.permission,
      'audio-capture': SpeechProblem.permission,
      'service-not-allowed': SpeechProblem.unavailable,
      'not supported': SpeechProblem.unavailable,
      'speech_not_supported': SpeechProblem.unavailable,
      'language-not-supported': SpeechProblem.language,
      'network': SpeechProblem.network,
      'aborted': SpeechProblem.other,
      // Android.
      'error_no_match': SpeechProblem.noSpeech,
      'error_speech_timeout': SpeechProblem.noSpeech,
      'error_permission': SpeechProblem.permission,
      'error_audio_error': SpeechProblem.permission,
      'error_language_not_supported': SpeechProblem.language,
      'error_language_unavailable': SpeechProblem.language,
      'error_network': SpeechProblem.network,
      'error_server': SpeechProblem.network,
      'something new': SpeechProblem.other,
    };
    for (final MapEntry(key: code, value: problem) in expected.entries) {
      expect(speechProblem(code), problem, reason: code);
    }
  });

  test('the mic is taken away only when trying again cannot help', () {
    expect(SpeechProblem.values.where(micCannotWork), [
      SpeechProblem.permission,
      SpeechProblem.language,
      SpeechProblem.unavailable,
    ]);
  });

  test('every message offers typing instead', () {
    for (final problem in SpeechProblem.values) {
      expect(
        speechProblemMessage(problem),
        anyOf(contains('พิมพ์'), contains('ลองอีกครั้ง')),
      );
      if (micCannotWork(problem)) {
        expect(speechProblemMessage(problem), contains('คีย์บอร์ด'));
      }
    }
  });
}
