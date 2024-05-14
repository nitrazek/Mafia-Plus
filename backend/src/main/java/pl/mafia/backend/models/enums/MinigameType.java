package pl.mafia.backend.models.enums;

import java.util.Random;

public enum MinigameType {
  CLICK_THE_BUTTON,
  NUMBER_MEMORY;

  private static final Random random = new Random();

  public static MinigameType random() {
    return values()[random.nextInt(values().length)];
  }
}
