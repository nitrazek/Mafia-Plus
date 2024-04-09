import 'package:flutter/material.dart';
import 'package:mobile/state/GameState.dart';

class WinnerViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();

  String _winnerRole='';
  String get winnerRole => _winnerRole;

  WinnerViewModel() {
    _gameState.addListener(_updateWinner); _updateWinner();
  }

  void _updateWinner() {
    if(_gameState.currentGameEnd == null) return;
    _winnerRole = _gameState.currentGameEnd!.winnerRole;
    notifyListeners();
  }
}