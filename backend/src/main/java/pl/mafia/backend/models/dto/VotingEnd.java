package pl.mafia.backend.models.dto;

public record VotingEnd(
  String votingType,
  String votedUsername
) { }
