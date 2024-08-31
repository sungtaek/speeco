package io.lazybones.speeco.common.model;

import java.util.List;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Conversation {
  private String id;
  private User user;
  private Coach coach;
  private List<Message> messages;
}
