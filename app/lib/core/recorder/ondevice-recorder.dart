import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

import 'recorder.dart';

const double SILENCE_THRESHOLD = 30;
const int SILENCE_DURATION_SEC = 2;

class OndeviceRecorder implements Recorder {
  SpeechToText _speechToText = SpeechToText();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      await _speechToText.initialize();
      for (var locale in await _speechToText.locales()) {
        print('recorder locale id: ${locale.localeId}, name: ${locale.name}');
      }
      _initialized = true;
    }
  }

  Future<String> start() {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    print('start recording');
    var completer = new Completer<String>();
    _speechToText
        .listen(
            onResult: (t) {
              print('recognized: ${t.recognizedWords}');
              if (t.finalResult) {
                completer.complete(t.recognizedWords);
              }
            },
            onDevice: true,
            pauseFor: Duration(seconds: SILENCE_DURATION_SEC))
        .catchError((err) => completer.completeError(err));
    return completer.future;
  }

  Future<void> stop() async {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    print('stop recording');
    await _speechToText.stop();
  }

}