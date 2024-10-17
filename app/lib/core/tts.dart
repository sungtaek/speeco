
import 'dart:typed_data';

import 'package:grpc/grpc.dart';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

class TTS {
  TTSClient _ttsStub;

  TTS(Session session) {
  var channel = ClientChannel(
      session.getHost,
      port: session.getPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    this._ttsStub = TTSClient(channel);
  }

  Future<Uint8List> convert(String text) async {
    return _ttsStub
        .convert(Message(text: text))
        .then((a) => Uint8List.fromList(a.pcm));
  }
}