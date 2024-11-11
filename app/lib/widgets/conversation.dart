
import 'dart:async';

import 'package:app/core/player/ondevice-player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import '../core/chat.dart';
import '../core/player/player.dart';
import '../core/recorder/ondevice-recorder.dart';
import '../core/recorder/recorder.dart';
import '../core/recorder/server-recorder.dart';
import '../core/session.dart';
import 'conversation-chat.dart';

class Conversation extends StatefulWidget {
  @override
  _Conversation createState() => _Conversation();
}

enum ChatStatus {
  NONE,
  LISTENING,
  PROCESSING,
}

class _Conversation extends State<Conversation> {
  Chat _chat;
  Recorder _recorder;
  Player _player;
  ChatStatus _status = ChatStatus.NONE;
  List<Message> _messages = <Message>[];
  bool _toBottom = false;

  @override
  void initState() {
    super.initState();
    var session = Session('dev-sungtaek.kro.kr', 9090);
    Chat.create(session).then((c) => _chat = c);
    _recorder = ServerRecorder(session);
    _recorder.init();
    _player = OndevicePlayer();
    _player.init();
  }

  void _listen() {
    if (_status == ChatStatus.NONE) {
      var playController = StreamController<String>();
      playBackground(playController.stream);
      setState(() {
        _status = ChatStatus.LISTENING;
      });
      _recorder.start().then((t) {
        setState(() {
          _messages.add(Message(Owner.USER, t));
          _toBottom = true;
          _status = ChatStatus.PROCESSING;
        });
        _chat.sendMessage(t).listen((m) {
          setState(() {
            playController.add(m.text);
            _messages.add(Message(Owner.COACH, m.text));
            _toBottom = true;
          });
        }, onDone: () {
          setState(() {
            playController.close();
            _status = ChatStatus.NONE;
          });
        });
      });
    } else if (_status == ChatStatus.LISTENING) {
      _recorder.stop();
    }
  }

  Future<void> playBackground(Stream<String> texts) async {
    await for (var text in texts) {
      print("play: ${text}");
      await _player.play(text);
    }
  }

  Widget buildButton() {
    switch(_status) {
      case ChatStatus.NONE:
        return TextButton(
            onPressed: _listen,
            child: Lottie.asset('assets/images/mic_icon.json',
                height: 80, repeat: false, animate: false));
      case ChatStatus.LISTENING:
        return TextButton(
            onPressed: _listen,
            child: Lottie.asset('assets/images/mic_icon.json',
                height: 80, repeat: true, animate: true));
      case ChatStatus.PROCESSING:
        return TextButton(
            onPressed: _listen,
            child: Lottie.asset('assets/images/progress_icon.json',
                height: 80, repeat: true, animate: true));
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
            height: 120, child: Column(children: [buildButton()]))
      ]),
    );
  }
}
