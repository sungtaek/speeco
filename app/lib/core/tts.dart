
import 'dart:typed_data';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

class TTS {
  TTSClient _ttsStub;

  TTS(Session session) {
    this._ttsStub = TTSClient(session.getChannel);
  }

  Future<Uint8List> convert(String text) async {
    return _ttsStub
        .convert(Message(text: text))
        .then((a) => Uint8List.fromList(a.pcm));
  }
}