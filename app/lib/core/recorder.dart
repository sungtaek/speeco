import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

const double SILENCE_THRESHOLD = 30;
const int SILENCE_DURATION_SEC = 2;

class Recorder {
  FlutterSoundRecorder _recorder;
  ASRClient _asrStub;
  bool _initialized;

  StreamController<Food> _recordingDataController;
  StreamSubscription _recordingEventSubscription;
  Timer _silenceTimer;

  Recorder(Session session) {
    this._recorder = FlutterSoundRecorder();
    this._asrStub = ASRClient(session.getChannel);
    this._initialized = false;
  }

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

  Future<String> start() async {
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
    var audioStream = _recordingDataController.stream
        .where((b) => b is FoodData)
        .cast<FoodData>()
        .map((b) => b.data);
    var message = await _asrStub.recognize(audioStream.map<Audio>((a) => Audio(pcm: a)));
    return message.text;
  }

  Future<void> stop() async {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    print('stop recording');

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