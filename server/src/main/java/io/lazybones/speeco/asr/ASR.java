package io.lazybones.speeco.asr;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ASR {
  Mono<Recognized> recognize(Flux<byte[]> audio);
}
