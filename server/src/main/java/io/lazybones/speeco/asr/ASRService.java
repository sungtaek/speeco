package io.lazybones.speeco.asr;

import org.springframework.stereotype.Service;

import io.lazybones.speeco.common.model.Conversation;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
public class ASRService {

  private final ASR asr;

  public ASRService(ASR asr) {
    this.asr = asr;
  }
  
  public Mono<String> recognize(Conversation conversation, Flux<byte[]> audio) {
    return audio
        .transform(asr::recognize)
        .last()
        .map(Recognized::getText);
  }

}
