import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobile/services/network/MinigameService.dart';
import 'package:mobile/state/MinigameState.dart';
import 'package:mobile/state/VotingState.dart';

class MinigameViewModel extends ChangeNotifier {
  final MinigameService _minigameService = MinigameService();
  final MinigameState _minigameState = MinigameState();
  final VotingState _votingState = VotingState();

  int? _minigameId;
  int _score = 0;

  final _votingStarted = StreamController<void>.broadcast();
  Stream<void> get votingStarted => _votingStarted.stream;

  MinigameViewModel() {
    _minigameState.addListener(_updateMinigameId); _updateMinigameId();
    _votingState.addListener(_updateVoting); _updateVoting();
  }

  void _updateMinigameId() {
    if(_minigameState.currentMinigame == null) return;
    _minigameId = _minigameState.currentMinigame!.id;
    notifyListeners();
  }

  void _updateVoting() {
    if(_votingState.currentVoting == null) return;
    _votingStarted.add(null);
    notifyListeners();
  }

  void increaseScore(int value) {
    _score += value;
  }

  Future<void> finishMinigame() async {
    await _minigameService.finishMinigame(_minigameId!, _score);
    notifyListeners();
  }
}