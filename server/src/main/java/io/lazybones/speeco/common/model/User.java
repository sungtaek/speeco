package io.lazybones.speeco.common.model;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class User {
  private String id;
  private String name;
}
