package pl.mafia.backend.models.dto;

import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.MinigameScore;

import java.util.List;
import java.util.Map;

public record MinigameSummary(
        AccountDetails winner,
        int highestScore,
        Map<String, Integer> scores
) {}
