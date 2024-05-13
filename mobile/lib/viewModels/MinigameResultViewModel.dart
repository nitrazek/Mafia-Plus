import 'package:flutter/material.dart';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/state/MinigameState.dart';

import '../models/Score.dart';

class MinigameResultViewModel extends ChangeNotifier {
  final MinigameState _minigameState = MinigameState();

  Score? _highestScore;
  Score? get highestScore => _highestScore;

  MinigameResultViewModel() {
    _minigameState.addListener(_updateHighestScore); _updateHighestScore();
  }

  void _updateHighestScore() {
    if(_minigameState.highestScore == null) return;
    _highestScore = _minigameState.highestScore;
    notifyListeners();
  }
}