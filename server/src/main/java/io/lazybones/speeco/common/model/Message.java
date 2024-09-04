package io.lazybones.speeco.common.model;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class Message {
  private Speaker speaker;
  private String text;
}
