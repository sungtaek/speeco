package io.lazybones.speeco.common.model;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class Message {
  private Owner owner;
  private String text;
}
