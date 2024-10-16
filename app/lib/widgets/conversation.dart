
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/asr.dart';
import '../core/recorder.dart';
import '../core/session.dart';

class Conversation extends StatefulWidget {
  @override
  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  Recorder _recorder = Recorder();
  ASR _asr = ASR(Session('192.168.1.105', 9090));
  bool _isListening = false;
  int _audioSize = 0;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _recorder.init();
  }

  void _listen() async {
    if (!_isListening) {
      setState(() {
        _audioSize = 0;
        _isListening = true;
      });
      // _asr.recognize()
      _recorder.start().listen((b) {
        setState(() => _audioSize += b.length);
      }, onDone: () {
        setState(() => _isListening = false);
      });
    } else {
      setState(() => _isListening = false);
      await _recorder.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(child: Text("Body")),
        ),
        Container(
            height: 80,
            child: Row(children: [
              // Lottie.asset('images/thinking2.json', repeat: true, animate: true),
              // Lottie.asset('images/mic2.json', repeat: true, animate: true),
              Text('Audio: $_audioSize'),
              ElevatedButton(
                onPressed: _listen,
                child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
              ),
            ]))
      ]),
    );
  }
}
