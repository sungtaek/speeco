
import 'dart:typed_data';

import 'package:grpc/grpc.dart';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

class ASR {
  ASRClient _asrStub;

  ASR(Session session) {
    var channel = ClientChannel(
      session.getHost,
      port: session.getPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    this._asrStub = ASRClient(channel);
  }
  
  Future<String> recognize(Stream<Uint8List> audio) async {
    return _asrStub
        .recognize(audio.map<Audio>((a) => new Audio(pcm: a)))
        .then((m) => m.text);
  }
}