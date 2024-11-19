import 'package:grpc/grpc.dart';

import '../constants.dart';
import '../grpc/generated/speeco.pbgrpc.dart' as pb;
import './session.dart';

class Chat {
  pb.LLMClient _llmStub;
  String _convId;
  List<Message> _messages;
  
  Chat(Session session) {
    this._llmStub = pb.LLMClient(session.getChannel);
  }

  Future<void> create() async {
    var conversation = await _llmStub.create(pb.Empty());
    this._convId = conversation.id;
    this._messages = conversation.messages.map((m) => convertMessage(m)).toList();
  }

  Future<void> load(String convId) async {
    this._convId = convId;
    // TODO
  }

  static Message convertMessage(pb.Message message) {
    var owner = (message.owner == pb.Owner.COACH) ? Owner.COACH : Owner.USER;
    return Message(owner, message.text);
  }

  List<Message> get getMessages {
    return _messages;
  }

  Stream<Message> sendMessage(String text) {
    return _llmStub
        .chat(pb.Message(text: text),
            options: CallOptions(metadata: {'conv-id': _convId}))
        .map((m) {
          var msg = convertMessage(m);
          _messages.add(msg);
          return msg;
        });
  }

}