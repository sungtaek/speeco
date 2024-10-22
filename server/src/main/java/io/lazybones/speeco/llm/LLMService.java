package io.lazybones.speeco.llm;

import java.util.List;

import org.springframework.stereotype.Service;

import io.lazybones.speeco.common.model.Coach;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.common.model.Message;
import io.lazybones.speeco.common.model.Speaker;
import reactor.core.publisher.Flux;

@Service
public class LLMService {

  private final LLM llm;

  public LLMService(LLM llm) {
    this.llm = llm;
  }
  
  Flux<String> chat(Conversation conversation, String message) {
    Coach coach = conversation.getCoach();
    List<Message> messages = conversation.getMessages();
    messages.add(new Message(Speaker.USER, message));
    return llm.chat(coach.getModel(), messages);
  }
}
