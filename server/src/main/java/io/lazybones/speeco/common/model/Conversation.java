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
  
  public List<Message> addSpeech(Speech speech) {
    messages.add(new Message(speech.getSpeaker(), speech.getText()));
    return messages;
  }
}
