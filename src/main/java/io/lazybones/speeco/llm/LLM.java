package io.lazybones.speeco.llm;

import java.util.List;

import io.lazybones.speeco.common.model.Message;
import reactor.core.publisher.Flux;

public interface LLM {
  List<String> getModels();
  Flux<String> chat(String model, List<Message> messsages);
}
