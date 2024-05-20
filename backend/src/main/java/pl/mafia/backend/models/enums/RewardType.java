package pl.mafia.backend.models.enums;

import java.util.Random;

public enum RewardType {
  REVIVE,
  INVINCIBLE,
  DOUBLE_VOTE;

  private static final Random random = new Random();

  public static RewardType random() {
    return values()[values().length-1];
  }
}
