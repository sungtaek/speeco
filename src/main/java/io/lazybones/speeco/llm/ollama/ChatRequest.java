package io.lazybones.speeco.llm.ollama;

import java.util.List;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ChatRequest {
  private String model;
  private List<ChatMessage> messages;
  private Boolean stream;
}
