package io.lazybones.speeco.common.model;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Coach {
  private String id;
  private String name;
  private String gender;
  private String model;
  private String language;
  private String voice;
}
