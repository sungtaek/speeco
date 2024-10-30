import 'package:grpc/grpc.dart';

import '../constants.dart';
import '../grpc/generated/speeco.pbgrpc.dart' as pb;
import './session.dart';

class Chat {
  pb.LLMClient _llmStub;
  String _convId;
  List<Message> _messages;
  
  Chat._(Session session, String convId, List<Message> messages) {
    this._llmStub = pb.LLMClient(session.getChannel);
    this._convId = convId;
    this._messages = messages;
  }

  static Future<Chat> create(Session session) async {
    var llmStub = pb.LLMClient(session.getChannel);
    var conversation = await llmStub.create(pb.Empty());
    return Chat._(session, conversation.id, conversation.messages.map((m) => convertMessage(m)).toList());
  }

  static Future<Chat> load(Session session, String convId) async {
    // TODO
    return new Chat._(session, convId, <Message>[]);
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