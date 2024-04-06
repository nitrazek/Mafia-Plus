import 'package:flutter/material.dart';
import 'package:mobile/state/GameState.dart';

class WinnerViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();

  String _userRole = '';
  String get userRole => _userRole;

  WinnerViewModel() {
    _gameState.addListener(_updateRole); _updateRole();
  }

  void _updateRole() {
    if(_gameState.currentGame == null) return;
    _userRole = _gameState.currentGame!.role;
    notifyListeners();
  }
}