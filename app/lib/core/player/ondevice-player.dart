import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:remove_emoji/remove_emoji.dart';

import 'player.dart';

class OndevicePlayer implements Player {
  FlutterTts _tts = FlutterTts();
  RemoveEmoji _removeEmoji = RemoveEmoji();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // {name: en-US-default, locale: eng-default}
      // {name: en-US-SMTl03, locale: eng-x-lvariant-l03}
      // {name: en-US-SMTd01, locale: eng-x-lvariant-d01}
      for (var v in await _tts.getVoices) {
        print(v.toString());
      }
      _tts.setLanguage("en-US");
      _tts.setSpeechRate(0.5);
      _tts.setVoice({"name": "en-US-default", "locale": "eng-default"});
      _tts.awaitSpeakCompletion(true);
      _initialized = true;
    }
  }

  Future<void> play(String text) async {
    if (!_initialized) {
      throw Exception('Not initialized yet');
    }
    await _tts.speak(_removeEmoji.clean(text));
  }
}