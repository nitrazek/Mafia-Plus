package pl.mafia.backend.models.enums;

import java.util.Random;

public enum MinigameType {
  //TEST,
  //CLICK_THE_BUTTON,
  NUMBER_MEMORY;

  private static Random random = new Random();

  public static MinigameType random() {
    return values()[random.nextInt(values().length)];
  }
}
