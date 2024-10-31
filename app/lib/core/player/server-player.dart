import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:remove_emoji/remove_emoji.dart';

import '../../grpc/generated/speeco.pbgrpc.dart';
import '../session.dart';
import 'player.dart';

class ServerPlayer implements Player {
  FlutterSoundPlayer _player;
  TTSClient _ttsStub;
  RemoveEmoji _removeEmoji;
  bool _initialized;

  ServerPlayer(Session session) {
    this._player = FlutterSoundPlayer();
    this._ttsStub = TTSClient(session.getChannel);
    this._removeEmoji = RemoveEmoji();
    this._initialized = false;
  }

  Future<void> init() async {
    if (!_initialized) {
      await _player.openPlayer();
      _initialized = true;
    }
  }

  Future<void> play(String text) async {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    Completer completer = new Completer();

    Uint8List audio = await _ttsStub
        .convert(Message(text: _removeEmoji.clean(text)))
        .then((a) => Uint8List.fromList(a.pcm));
    
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