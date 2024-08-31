package io.lazybones.speeco.asr;

import reactor.core.publisher.Flux;

public interface ASR {
  Flux<Recognized> recognize(Flux<byte[]> audio);
}
