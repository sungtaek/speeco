
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/chat.dart';
import '../core/recorder.dart';
import '../core/session.dart';
import '../theme.dart';

class Conversation extends StatefulWidget {
  @override
  _Conversation createState() => _Conversation();
}

class MessageBox {
  String name;
  List<String> sentences;
  MessageBox(String name, String sentence) {
    this.name = name;
    this.sentences = <String>[];
    addSentence(sentence);
  }
  void addSentence(String sentence) {
    sentences.add(sentence);
  }
}

class _Conversation extends State<Conversation> {
  Recorder _recorder;
  Chat _chat;
  bool _isListening = false;
  List<MessageBox> _messages = <MessageBox>[];
  ScrollController _scrollController = ScrollController();
  bool _toBottom = false;

  @override
  void initState() {
    super.initState();
    var session = Session('dev-sungtaek.kro.kr', 9090);
    _recorder = Recorder(session);
    Chat.create(session).then((c) => _chat = c);
    _recorder.init();
  }

  void _listen() {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });
      _recorder.start().then((t) {
        setState(() {
          _messages.add(MessageBox('User', t));
          _toBottom = true;
        });
        _chat.sendMessage(t).listen((m) {
          setState(() {
            if (_messages.last.name == 'User') {
              _messages.add(MessageBox('Coach', m.text));
            } else {
              _messages.last.addSentence(m.text);
            }
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

  Widget buildMessageBox(MessageBox messageBox) {
    Color boxColor;
    EdgeInsetsGeometry boxMargin;
    if (messageBox.name == 'User') {
      boxColor = ThemeColors.primary;
      boxMargin = EdgeInsets.fromLTRB(5, 5, 20, 5);
    } else {
      boxColor = ThemeColors.success;
      boxMargin = EdgeInsets.fromLTRB(20, 5, 5, 5);
    }
    return Container(
        color: boxColor,
        padding: EdgeInsets.all(8),
        margin: boxMargin,
        alignment: Alignment.centerLeft,
        child: Column(
            children: messageBox.sentences.map((s) => Text(s)).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(children: [
        Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int idx) {
                  if (_toBottom) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                      _toBottom = false;
                    });
                  }
                  return buildMessageBox(_messages[idx]);
                })),
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
