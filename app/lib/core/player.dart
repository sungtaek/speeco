import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

class Player {
  FlutterSoundPlayer _player;
  TTSClient _ttsStub;
  bool _initialized;

  Player(Session session) {
    this._player = FlutterSoundPlayer();
    this._ttsStub = TTSClient(session.getChannel);
    this._initialized = false;
  }

  Future<void> init() async {
    await _player.openPlayer();
    _initialized = true;
  }

  // Future<Uint8List> convert(String text) async {
  //   return _ttsStub
  //       .convert(Message(text: text))
  //       .then((a) => Uint8List.fromList(a.pcm));
  // }

  Future<void> start(Uint8List audio) {
    Completer completer = new Completer();
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    _player.startPlayer(
      fromDataBuffer: audio,
      codec: Codec.pcm16WAV,
      whenFinished: () {
        completer.complete();
      })
      .catchError((err) {
        completer.completeError(err);
        return Duration(seconds: 0);
      });
    return completer.future;
  }
}