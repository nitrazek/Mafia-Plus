import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/MinigameState.dart';
import 'package:mobile/state/VotingState.dart';

class UserRoleViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();
  final MinigameState _minigameState = MinigameState();

  String _role = '';
  String get role => _role;

  final _minigameStarted = StreamController<MinigameType>.broadcast();
  Stream<MinigameType> get minigameStarted => _minigameStarted.stream;

  UserRoleViewModel() {
    _gameState.addListener(_updateRole); _updateRole();
    _minigameState.addListener(_updateMinigame); _updateMinigame();
  }

  void _updateRole() {
    if(_gameState.currentGame == null) return;
    _role = _gameState.currentGame!.role;
    notifyListeners();
  }

  void _updateMinigame() {
    if(_minigameState.currentMinigame == null) return;
    _minigameStarted.add(_minigameState.currentMinigame!.type);
    notifyListeners();
  }
}