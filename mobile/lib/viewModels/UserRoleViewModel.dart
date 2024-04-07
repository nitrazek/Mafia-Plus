import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/VotingState.dart';

class UserRoleViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();
  final VotingState _votingState = VotingState();

  String _role = '';
  String get role => _role;

  final _votingStarted = StreamController<void>.broadcast();
  Stream<void> get votingStarted => _votingStarted.stream;

  UserRoleViewModel() {
    _gameState.addListener(_updateRole); _updateRole();
    _votingState.addListener(_updateVoting); _updateVoting();
  }

  void _updateRole() {
    if(_gameState.currentGame == null) return;
    _role = _gameState.currentGame!.role;
    notifyListeners();
  }

  void _updateVoting() {
    if(_votingState.currentVoting == null) return;
    _votingStarted.add(null);
    notifyListeners();
  }
}