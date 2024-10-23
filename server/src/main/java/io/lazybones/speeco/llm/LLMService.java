package io.lazybones.speeco.llm;

import java.util.ArrayList;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

import io.lazybones.speeco.common.model.Coach;
import io.lazybones.speeco.common.model.Conversation;
import io.lazybones.speeco.common.model.Message;
import io.lazybones.speeco.common.model.Owner;
import io.lazybones.speeco.common.model.User;
import reactor.core.publisher.Flux;

@Service
public class LLMService {

  private final LLM llm;
  private final Map<String, Conversation> conversationStore = new ConcurrentHashMap<>();

  public LLMService(LLM llm) {
    this.llm = llm;
  }

  public Conversation createConversation() {
    String convId = UUID.randomUUID().toString();
    Conversation conversation = Conversation.builder()
      .id(convId)
      .user(User.builder()
          .name("junhui")
          .build())
      .coach(Coach.builder()
          .name("teddy")
          .gender("M")
          .model("teacher")
          .language("en")
          .voice("larynx:southern_english_male-glow_tts")
          .build())
      .messages(new ArrayList<>())
      .build();
    conversationStore.put(convId, conversation);
    return conversation;
  }

  public Conversation getConversation(String convId) {
    return conversationStore.get(convId);
  }
  
  public Flux<Message> chat(Conversation conversation, String message) {
    Coach coach = conversation.getCoach();
    conversation.addMessage(new Message(Owner.USER, message));
    return llm.chat(coach.getModel(), conversation.getMessages())
        .map(t -> new Message(Owner.COACH, t))
        .doOnNext(m -> conversation.addMessage(m));
  }

}
