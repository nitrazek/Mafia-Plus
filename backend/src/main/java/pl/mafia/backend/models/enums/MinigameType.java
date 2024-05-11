package pl.mafia.backend.models.enums;

public enum MinigameType {
  //TEST,
  CLICK_THE_BUTTON,
  NUMBER_MEMORY;

  public static MinigameType random() {
    return values()[(int)(Math.random() * values().length)];
  }
}
