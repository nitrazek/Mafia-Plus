package pl.mafia.backend.models.dto;

import java.util.List;

public record VotingStart(
  long id,
  String type,
  List<String> playerUsernames
) { }
