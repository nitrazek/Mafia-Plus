package pl.mafia.backend.models.dto;

import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Room;

import java.util.List;

public record RoomUpdate(
  long id,
  List<String> accountUsernames,
  String hostUsername,
  String accessCode,
  RoomSettingsUpdate roomSettings
) {
  public RoomUpdate(Room room) {
    this(
      room.getId(),
      room.getAccounts().stream()
        .map(Account::getUsername)
        .toList(),
      room.getHost().getUsername(),
      room.getAccessCode(),
      new RoomSettingsUpdate(room.getRoomSettings())
    );
  }
}