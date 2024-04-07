import 'package:flutter/material.dart';
import 'package:mobile/state/GameState.dart';

class WinnerViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();

  String _userRole = '';
  String get userRole => _userRole;
  String _winnerRole='';
  String get winnerRole => _winnerRole;

  WinnerViewModel() {
    _gameState.addListener(_updateRole); _updateRole();
    _gameState.addListener(_checkWinner);_checkWinner();
  }

  void _updateRole() {
    if(_gameState.currentGame == null) return;
    _userRole = _gameState.currentGame!.role;
    notifyListeners();
  }

  void _checkWinner(){
    _winnerRole=_gameState.gameFinished!.gameEnd;
    notifyListeners();
  }
}