package io.lazybones.speeco.asr.whisper;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown=true)
public class WhisperResponse {
  private String text;
  private String language;
}
