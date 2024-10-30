
import 'package:app/core/player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import '../core/chat.dart';
import '../core/recorder.dart';
import '../core/session.dart';
import 'conversation-chat.dart';

class Conversation extends StatefulWidget {
  @override
  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  Chat _chat;
  Recorder _recorder;
  Player _player;
  bool _isListening = false;
  List<Message> _messages = <Message>[];
  bool _toBottom = false;

  @override
  void initState() {
    super.initState();
    var session = Session('dev-sungtaek.kro.kr', 9090);
    Chat.create(session).then((c) => _chat = c);
    _recorder = Recorder(session);
    _recorder.init();
    _player = Player(session);
    _player.init();
  }

  void _listen() {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });
      _recorder.start().then((t) {
        setState(() {
          _messages.add(Message(Owner.USER, t));
          _toBottom = true;
        });
        _chat.sendMessage(t).listen((m) {
          setState(() {
            _player.play(m.text);
            _messages.add(Message(Owner.COACH, m.text));
            _toBottom = true;
          });
        }, onDone: () {
          setState(() {
            _isListening = false;
          });
        });
      });
    } else {
      _recorder.stop().then((_) {
        setState(() {
          _isListening = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(children: [
        Expanded(
            child: ConversationChat(messages: _messages, toBottom: _toBottom)),
        Container(
            height: 80,
            child: Column(children: [
              // Lottie.asset('images/thinking2.json', repeat: true, animate: true),
              // Lottie.asset('images/mic2.json', repeat: true, animate: true),
              ElevatedButton(
                onPressed: _listen,
                child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
              ),
            ]))
      ]),
    );
  }
}
