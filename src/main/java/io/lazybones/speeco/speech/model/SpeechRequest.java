package io.lazybones.speeco.speech.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SpeechRequest {
  private byte[] audio;
  private Boolean done;
}
