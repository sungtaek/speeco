package io.lazybones.speeco.speech;

import org.springframework.stereotype.Service;

import io.lazybones.speeco.speech.model.SpeechRequest;
import io.lazybones.speeco.speech.model.SpeechResponse;
import reactor.core.publisher.Flux;

@Service
public class SpeechService {

  public Flux<SpeechResponse> speech(Flux<SpeechRequest> reqFlux) {
    return Flux.empty();
  }
  
}
