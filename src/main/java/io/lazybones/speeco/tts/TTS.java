package io.lazybones.speeco.tts;

import java.util.List;

import reactor.core.publisher.Mono;

public interface TTS {
  List<String> getVoices();
  Mono<byte[]> tts(String voice, String text);
}
