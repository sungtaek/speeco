
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/recorder.dart';

class Conversation extends StatefulWidget {
  @override
  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  Recorder _recorder = Recorder();
  bool _isListening = false;
  int _audioSize = 0;

  void _listen() async {
    if (!_isListening) {
      setState(() {
        _audioSize = 0;
        _isListening = true;
      });
      print('start');
      await _recorder.init();
      await _recorder.start(_onAudio, _onEnd);
    } else {
      setState(() => _isListening = false);
      print('stop');
      await _recorder.stop();
    }
  }

  void _onAudio(Uint8List buffer) {
    setState(() => _audioSize += buffer.length);
  }

  void _onEnd() {
    setState(() => _isListening = false);
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
              // Lottie.asset('images/thinking2.json',
                  // repeat: true, animate: true),
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
