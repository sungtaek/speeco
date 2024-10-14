package io.lazybones.speeco.tts;

import org.springframework.stereotype.Service;

import io.lazybones.speeco.common.model.Coach;
import io.lazybones.speeco.common.model.Conversation;
import reactor.core.publisher.Mono;

@Service
public class TTSService {

  private final TTS tts;

  public TTSService(TTS tts) {
    this.tts = tts;
  }

  public Mono<byte[]> convert(Conversation conversation, String text) {
    Coach coach = conversation.getCoach();
    return tts.tts(coach.getVoice(), text);
  }
  
}
