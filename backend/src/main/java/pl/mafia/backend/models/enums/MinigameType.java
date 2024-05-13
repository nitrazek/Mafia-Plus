package pl.mafia.backend.models.enums;

import java.util.Random;

public enum MinigameType {
  //TEST,
  CLICK_THE_BUTTON;

  private static final Random random = new Random();

  public static MinigameType random() {
    return values()[random.nextInt(values().length)];
  }
}
