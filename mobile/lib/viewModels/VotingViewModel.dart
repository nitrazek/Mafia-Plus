import 'package:flutter/material.dart';
import 'package:mobile/models/VotingResult.dart';
import '../models/Room.dart';
import '../services/WebSocketClient.dart';
import '../models/VotingSummary.dart';
import '../services/network/GameService.dart';

import '../models/Room.dart';
import '../models/VotingSummary.dart';
import '../services/WebSocketClient.dart';
import '../services/network/GameService.dart';

class VotingViewModel extends ChangeNotifier {
  final GameService _gameService = GameService();
  final WebSocketClient webSocketClient = WebSocketClient();
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
  bool _votingFinished = true;
  bool get votingFinished => _votingFinished;

  VotingViewModel() {
    _players = webSocketClient.lastRoomUpdate!.accountUsernames.map(
      (username) => Player(nickname: username, canVote: true)).toList();
    _votesCount = Map<String, int>.fromIterable(_players, key: (player) => player.nickname, value: (player) => 0);
    _votingId = webSocketClient.lastRoundStartUpdate?.votingCityId;
    notifyListeners();
    VotingResult result = VotingResult(username: 'Gracz', voteCount: 3);
    _votingSummary = VotingSummary(results: [result]);
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

  void setVotingResults(VotingSummary value)
  {
    _votingSummary = value;
    _votingFinished = true;
    print("elop");
    notifyListeners();
  }
  void setRoom(Room value)
  {
    _room=value;
    notifyListeners();
  }

  void connectWebSocket() {
    if(webSocketClient.lastVotingSummary != null) { setVotingResults(webSocketClient.lastVotingSummary!); }
    if(webSocketClient.lastRoomUpdate != null) { setRoom(webSocketClient.lastRoomUpdate!); }

    webSocketClient.votingSummaryUpdate.listen((votingSummary) { setVotingResults(votingSummary); });
  }
}

class Player {
  final String nickname;
  final bool canVote;

  Player({required this.nickname, required this.canVote});
}