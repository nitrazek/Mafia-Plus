package pl.mafia.backend.models.enums;

import java.util.Random;

public enum MinigameType {
  CLICK_THE_BUTTON,
  NUMBER_MEMORY;

  public static MinigameType valueOf(int index) {
    MinigameType[] values = MinigameType.values();
    if (index >= 0 && index < values.length) {
      return values[index];
    } else {
      throw new IllegalArgumentException("Nieprawidłowy indeks");
    }
  }
}
