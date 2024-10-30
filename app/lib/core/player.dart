import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

class Player {
  // FlutterSoundPlayer _player;
  // TTSClient _ttsStub;
  FlutterTts _tts;
  bool _initialized;

  Player(Session session) {
    // this._player = FlutterSoundPlayer();
    // this._ttsStub = TTSClient(session.getChannel);
    this._tts = FlutterTts();
    this._initialized = false;
  }

  Future<void> init() async {
    // await _player.openPlayer();
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5);
    _initialized = true;
  }

  // Future<Uint8List> convert(String text) async {
  //   return _ttsStub
  //       .convert(Message(text: text))
  //       .then((a) => Uint8List.fromList(a.pcm));
  // }

  Future<dynamic> play(String text) async {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    return await _tts.speak(text);
    // Completer completer = new Completer();
    
    // _player.startPlayer(
    //   fromDataBuffer: audio,
    //   codec: Codec.pcm16WAV,
    //   whenFinished: () {
    //     completer.complete();
    //   })
    //   .catchError((err) {
    //     completer.completeError(err);
    //     return Duration(seconds: 0);
    //   });
    // return completer.future;
  }
}