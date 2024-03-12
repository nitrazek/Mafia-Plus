import 'package:flutter/material.dart';
import '../models/Room.dart';
import '../services/WebSocketClient.dart';
import '../models/VotingSummary.dart';

class VotingViewModel extends ChangeNotifier {
  final WebSocketClient webSocketClient = WebSocketClient();
  VotingSummary? _votingSummary;
  VotingSummary? get votingSummary => _votingSummary;
  List<Player> _players = []; // Lista użytkowników

  VotingViewModel() {
    webSocketClient.roomUpdate.listen((room) {
      _players = room.accountUsernames.map((username) => Player(nickname: username, canVote: true)).toList();
      notifyListeners();
    });
  }

  List<Player> getPlayers() {
    return _players;
  }

  Map<String, int> _votesCount = {};

  Map<String, int> getVotesCount() {
    return _votesCount;
  }

  void vote(String playerNickname) {
    Player? player = _players.firstWhere((p) => p.nickname == playerNickname, orElse: () => Player(nickname: '', canVote: false));

    if (player?.canVote ?? false) {
      print('Głos oddany na gracza: $playerNickname');
      _votesCount[playerNickname] = (_votesCount[playerNickname] ?? 0) + 1;
      notifyListeners();
    } else {
      print('Nie można głosować na $playerNickname');
    }
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

  void setVotingResults(VotingSummary value) {
    _votingSummary = value;
    notifyListeners();
  }

  void connectWebSocket() {
    webSocketClient.votingSummaryUpdate.listen((votingSummary) {
      setVotingResults(votingSummary);
    });
  }
}

class Player {
  final String nickname;
  final bool canVote;

  Player({required this.nickname, required this.canVote});
}