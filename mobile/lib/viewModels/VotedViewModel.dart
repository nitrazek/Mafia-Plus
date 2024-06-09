import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/models/VotingConditions.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/VotingState.dart';

import '../models/MinigameType.dart';
import '../state/MinigameState.dart';

class VotedViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();
  final VotingState _votingState = VotingState();
  final MinigameState _minigameState = MinigameState();

  String? _votingType;
  String? get votingType => _votingType;

  String? _votedPlayerNickname;
  String? get votedPlayerNickname => _votedPlayerNickname;

  bool? _isAlive;
  bool? get isAlive => _isAlive;

  final _gameEnded = StreamController<void>.broadcast();
  Stream<void> get gameEnded => _gameEnded.stream;

  final _votingStarted = StreamController<VotingConditions>.broadcast();
  Stream<VotingConditions> get votingStarted => _votingStarted.stream;

  final _minigameStarted = StreamController<MinigameType>.broadcast();
  Stream<MinigameType> get minigameStarted => _minigameStarted.stream;

  VotedViewModel() {
    _votingState.addListener(_updateVotingEnd); _updateVotingEnd();
    _gameState.addListener(_endGame); _endGame();
    _minigameState.addListener(_updateMinigame); _updateMinigame();

    _votingState.votingStarted.listen((_) {
      if (_votingState.currentVoting == null) return;
      _votingStarted.add(VotingConditions(
        isVoting: _votingState.currentVoting!.playerUsernames != null,
        isAlive: _votingState.currentVoting!.isAlive
      ));
      notifyListeners();
    });
    _gameState.gameFinished.listen((_) {
      if (_gameState.currentGameEnd == null) return;
      _gameEnded.add(null);
      notifyListeners();
    });
  }

  void _endGame() {
    if (_gameState.currentGameEnd == null) return;
    notifyListeners();
  }

  void _updateVotingEnd() {
    if (_votingState.currentVotingEnd == null) return;
    _votingType = _votingState.currentVotingEnd!.votingType;
    _votingType = _votingType![0].toUpperCase() + _votingType!.substring(1).toLowerCase();

    if (_votingState.currentVotingEnd?.votedUsername != null) {
      _votedPlayerNickname = _votingState.currentVotingEnd?.votedUsername;
    } else {
      _votedPlayerNickname = "Nobody";
    }
    _isAlive = _votingState.currentVotingEnd!.isAlive;

    notifyListeners();
  }

  void _updateMinigame() {
    if(_minigameState.currentMinigame == null) return;
    _minigameStarted.add(_minigameState.currentMinigame!.type);
    notifyListeners();
  }
}
