
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import '../core/asr.dart';
import '../core/chat.dart';
import '../core/recorder.dart';
import '../core/session.dart';
import '../core/tts.dart';

class Conversation extends StatefulWidget {
  @override
  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  Recorder _recorder = Recorder();
  ASR _asr;
  TTS _tts;
  Chat _chat;
  bool _isListening = false;
  List<Message> _messages = <Message>[];

  @override
  void initState() {
    super.initState();
    var session = Session('192.168.1.105', 9090);
    _asr = ASR(session);
    _tts = TTS(session);
    Chat.create(session).then((c) => _chat = c);
    _recorder.init();
  }

  void _listen() {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _messages.length = 0;
      });
      var record = _recorder.start();
      _asr.recognize(record).then((t) {
        setState(() {
          _messages.add(Message(Owner.USER, t));
          _isListening = false;
        });
        _chat.sendMessage(t).listen((m) {
          setState(() {
            _messages.add(Message(Owner.COACH, m.text));
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

  Iterable<Widget> buildChatList() {
    return _messages.map((m) => Text("${m.owner}: ${m.text}"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(child: Column(children: buildChatList())),
        ),
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
