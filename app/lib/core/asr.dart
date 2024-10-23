
import 'dart:typed_data';

import 'package:grpc/grpc.dart';

import '../grpc/generated/speeco.pbgrpc.dart';
import 'session.dart';

class ASR {
  ASRClient _asrStub;

  ASR(Session session) {
    this._asrStub = ASRClient(session.getChannel);
  }
  
  Future<String> recognize(Stream<Uint8List> audio) async {
    return _asrStub
        .recognize(audio.map<Audio>((a) => Audio(pcm: a)))
        .then((m) => m.text);
  }
}