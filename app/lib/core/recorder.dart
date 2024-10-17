import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

const double SILENCE_THRESHOLD = 30;
const int SILENCE_DURATION_SEC = 2;

class Recorder {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _initialized = false;

  // StreamSubscription _recordingDataSubscription;
  StreamController<Food> _recordingDataController;
  StreamSubscription _recordingEventSubscription;
  Timer _silenceTimer;

  Future<void> init() async {
    if (!_initialized) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
      await _recorder.openRecorder();
      _initialized = true;
    }
  }

  Stream<Uint8List> start() {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    print('start recording');
    _recorder.setSubscriptionDuration(Duration(milliseconds: 100));
    _recordingDataController = StreamController<Food>();
    _recordingEventSubscription = _recorder.onProgress.listen((event) {
      double currentLevel = event.decibels ?? 0;
      print('decibels: ${currentLevel}');
      if (currentLevel < SILENCE_THRESHOLD) {
        _silenceTimer ??= Timer(Duration(seconds: SILENCE_DURATION_SEC), () {
          print('silence detected');
          stop();
        });
      } else {
        _silenceTimer?.cancel();
        _silenceTimer = null;
      }
    });
    _recorder.startRecorder(
      codec: Codec.pcm16,
      toStream: _recordingDataController.sink
    );
    return _recordingDataController.stream
        .where((b) => b is FoodData)
        .cast<FoodData>()
        .map((b) => b.data);
  }

  Future<void> stop() async {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    print('stop recording');
    // if (_recordingDataSubscription != null) {
    //   await _recordingDataSubscription.cancel();
    //   _recordingDataSubscription = null;
    // }

    if (_recordingEventSubscription != null) {
      await _recordingEventSubscription.cancel();
      _recordingEventSubscription = null;
    }
    if (_recordingDataController != null) {
      await _recordingDataController.close();
      _recordingDataController = null;
    }
    await _recorder.stopRecorder();
  }

}