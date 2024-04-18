package pl.mafia.backend.models.enums;

public enum MinigameType {
  TEST;

  public static MinigameType random() {
    return values()[(int)(Math.random() * values().length)];
  }
}
