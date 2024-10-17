import 'package:grpc/grpc.dart';

import '../constants.dart';
import '../grpc/generated/speeco.pbgrpc.dart';
import './session.dart';

class Message {
  Owner owner;
  List<String> text;
}

class Chat {
  LLMClient _llmStub;
  String _convId;
  List<Message> _messages;
  
  Chat._(Session session, String convId) {
    var channel = ClientChannel(
      session.getHost,
      port: session.getPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    this._llmStub = LLMClient(channel);
    this._convId = convId;
  }

  static Future<Chat> create(Session session) async {
    // TODO
    return new Chat._(session, "dummy");
  }

  static Future<Chat> load(Session session, String convId) async {
    // TODO
    return new Chat._(session, convId);
  }

  List<Message> get getMessages {
    return _messages;
  }

  Stream<String> sendMessage(String text) async* {
    // TODO
  }

}