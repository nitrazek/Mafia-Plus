package pl.mafia.backend.models.dto;

import pl.mafia.backend.models.db.Minigame;

public record MinigameStart (
  String title
) {
  public MinigameStart(Minigame minigame) {
    this(minigame.getTitle());
  }
}
