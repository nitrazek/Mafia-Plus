package pl.mafia.backend.models.dto;

import pl.mafia.backend.models.db.Account;

public record MinigameSummary(
      Account winner,
      int highestScore
) {
}
