package io.lazybones.speeco.llm.ollama;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Data;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ChatResponse {
  private String model;
  private String createdAt;
  private ChatMessage message;
  private String doneReason;
  private Boolean done;
  private Long totalDuration;
  private Long loadDuration;
  private Integer promptEvalCount;
  private Long promptEvalDuration;
  private Integer evalCount;
  private Long evalDuration;
}
