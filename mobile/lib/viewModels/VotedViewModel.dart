import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/VotingState.dart';

class VotedViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();
  final VotingState _votingState = VotingState();
  String? _votingType;
  String? get votingType => _votingType;

  String? _votedPlayerNickname;
  String? get votedPlayerNickname => _votedPlayerNickname;

  final _gameEnded = StreamController<void>.broadcast();
  Stream<void> get gameEnded => _gameEnded.stream;

  final _votingSetted = StreamController<void>.broadcast();
  Stream<void> get votingSetted => _votingSetted.stream;

  VotedViewModel() {
    _votingState.addListener(_updateVotingType); _updateVotingType();
    _votingState.addListener(_updateVotedPlayerNickname); _updateVotedPlayerNickname();
    _votingState.addListener(_setVoting); _setVoting();
    _gameState.addListener(_endGame); _endGame();

    _votingState.currentVoting.listen((_) {
      if (_votingState.currentVoting == null) return;
      _votingSetted.add(null);
      notifyListeners();
    });

    _gameState.gameFinished.listen((_) {
      if (_gameState.currentGameEnd == null) return;
      _gameEnded.add(null);
      notifyListeners();
    });
  }

  void _updateVotingType(){
    if (_votingState.currentVoting == null) return;
    else {
      _votingType = _votingState.currentVoting?.type;
      _votingType = _votingType![0].toUpperCase()+_votingType!.substring(1).toLowerCase();
    }
  }

  void _updateVotedPlayerNickname() {
    if (_votingState.currentVoting == null) return;
    else {
      if (_votingState.currentVotingEnd?.votedUsername != null)
        {
          _votedPlayerNickname = _votingState.currentVotingEnd?.votedUsername;
        }
      else {
        _votedPlayerNickname = "Nobody";
      }
    }
  }

  void _endGame()
  {

  }

  void _setVoting()
  {

  }

}