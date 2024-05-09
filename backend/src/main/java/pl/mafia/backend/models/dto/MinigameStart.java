package pl.mafia.backend.models.dto;

import pl.mafia.backend.models.db.Minigame;

public record MinigameStart (
  Long id,
  String type
) {
  public MinigameStart(Minigame minigame) {
    this(minigame.getId(), minigame.getType().name());
  }
}
