import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/state/RoomState.dart';
import 'package:mobile/state/RoundState.dart';
import '../models/Room.dart';
import '../models/VotingSummary.dart';
import '../services/network/GameService.dart';
import '../state/VotingState.dart';

class VotingViewModel extends ChangeNotifier {
  final RoomState _roomState = RoomState();
  final RoundState _roundState = RoundState();
  final VotingState _votingState = VotingState();
  final GameService _gameService = GameService();
  VotingSummary? _votingSummary;
  VotingSummary? get votingSummary => _votingSummary;
  List<Player> _players = []; // Lista użytkowników
  Player? _votedPlayer;
  Player? get votedPlayer => _votedPlayer;
  late Map<String, String> _roles; // Change key type to String
  Map<String, int> _votesCount = {};
  int? _votingId=0;
  Room? _room;
  Room? get room => _room;
  final _votingFinished = StreamController<void>.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  VotingViewModel() {
    _roomState.addListener(_updatePlayers); _updatePlayers();
    _roundState.addListener(_updateVoting); _updateVoting();
    _votingState.addListener(_updateVotingSummary);
  }

  void _updatePlayers() {
    if(_roomState.currentRoom == null) return;
    _room = _roomState.currentRoom!;
    _players = _room!.accountUsernames.map(
      (username) => Player(nickname: username, canVote: true)
    ).toList();
    _votesCount = { for (var player in _players) player.nickname : 0 };
    notifyListeners();
  }

  void _updateVoting() {
    if(_roundState.currentRound == null) return;
    _votingId = _roundState.currentRound!.votingCityId;
    notifyListeners();
  }

  void _updateVotingSummary() {
    if(_votingState.currentVotingSummary == null) return;
    _votingSummary = _votingState.currentVotingSummary!;
    _votingFinished.add(null);
    notifyListeners();
  }

  List<Player> getPlayers() {
    return _players;
  }

  Map<String, int> getVotesCount() {
    return _votesCount;
  }

  void vote(String playerNickname) async {
    Player? player = _players.firstWhere((p) => p.nickname == playerNickname, orElse: () => Player(nickname: '', canVote: false));
    _votedPlayer = player;

    if (player?.canVote ?? false) {
      print('Głos oddany na gracza: $playerNickname');
      await _gameService.addVote(_votingId!, playerNickname);
      _votesCount[playerNickname] = (_votesCount[playerNickname] ?? 0) + 1;
      notifyListeners();
    } else {
      print('Nie można głosować na $playerNickname');
    }

    notifyListeners();
  }

  int getVotesForPlayer(String playerNickname) {
    return _votesCount[playerNickname] ?? 0;
  }

  Player? getPlayerWithMostVotes() {
    int maxVotes = 0;
    Player? playerWithMostVotes;

    for (Player player in _players) {
      int votes = _votesCount[player.nickname] ?? 0;
      if (votes > maxVotes) {
        maxVotes = votes;
        playerWithMostVotes = player;
      }
    }

    return playerWithMostVotes;
  }
}

class Player {
  final String nickname;
  final bool canVote;

  Player({required this.nickname, required this.canVote});
}