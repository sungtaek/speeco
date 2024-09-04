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
  private Speaker speaker;
  private byte[] audio;
  private String text;
}
