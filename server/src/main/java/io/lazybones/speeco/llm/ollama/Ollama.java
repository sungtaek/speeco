package io.lazybones.speeco.llm.ollama;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import io.lazybones.speeco.common.model.Message;
import io.lazybones.speeco.common.model.Owner;
import io.lazybones.speeco.llm.LLM;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;

@Component
@Slf4j
public class Ollama implements LLM {

  private final WebClient client;

  public Ollama(@Value("${llm.ollama.url}") String url) {
    this.client = WebClient.create(url);
  }
  
  @Override
  public List<String> getModels() {
    return List.of("teacher");
  }

  @Override
  public Flux<String> chat(String model, List<Message> messages) {
    StringBuilder sb = new StringBuilder();
    ChatRequest request = ChatRequest.builder()
        .model(model)
        .messages(messages.stream()
            .map(c -> ChatMessage.builder()
                .role(c.getOwner() == Owner.COACH ? "assistant" : "user")
                .content(c.getText())
                .build())
            .toList())
        .stream(true)
        .build();
    log.info("Send chat to LLM: {}", request);
    return client.post()
        .uri("/api/chat")
        .contentType(MediaType.APPLICATION_JSON)
        .bodyValue(request)
        .retrieve()
        .bodyToFlux(ChatResponse.class)
        .mapNotNull(r -> {
          String text = r.getMessage().getContent();
          if (text.endsWith("\n")) {
            sb.append(text.replaceAll("\n+$", ""));
            text = sb.toString();
            sb.setLength(0);
            if (StringUtils.isNotBlank(text)) {
              return text;
            } else {
              return null;
            }
          } else {
            sb.append(text);
            return null;
          }
        })
        .doOnNext(r -> log.info("Receive from LLM: {}", r));
  }
  
}
