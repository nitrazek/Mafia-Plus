package pl.mafia.backend.models.dto;

import pl.mafia.backend.models.db.RoomSettings;

public record RoomSettingsUpdate(boolean isPublic, int maxNumberOfPlayers) {
  public RoomSettingsUpdate(RoomSettings roomSettings) {
    this(roomSettings.isPublic(), roomSettings.getMaxNumberOfPlayers());
  }
}
