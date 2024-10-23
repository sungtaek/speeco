package io.lazybones.speeco.common.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Builder;
import lombok.Data;
import lombok.Builder.Default;

@Data
@Builder
public class Conversation {
  private String id;
  private User user;
  private Coach coach;
  @Default
  private List<Message> messages = new ArrayList<>();
  @Default
  private Boolean useAsr = false;
  @Default
  private Boolean useTts = false;

  public void addMessage(Message message) {
    messages.add(message);
  }
  
  public static Conversation DEFAULT = Conversation.builder()
      .id("conv-0001")
      .user(User.builder()
          .name("user")
          .build())
      .coach(Coach.builder()
          .name("coach")
          .gender("M")
          .model("teacher")
          .language("en")
          .voice("larynx:southern_english_male-glow_tts")
          .build())
      .messages(new ArrayList<>())
      .build();
}
