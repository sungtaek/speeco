package io.lazybones.speeco.common.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Speech {
  private Owner speaker;
  private byte[] audio;
  private String text;
}
