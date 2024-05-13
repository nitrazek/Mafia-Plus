import 'package:flutter/cupertino.dart';

import '../models/MinigameStart.dart';
import '../models/Score.dart';

class MinigameState extends ChangeNotifier {
  static MinigameState? _instance;

  MinigameStart? _currentMinigame;
  MinigameStart? get currentMinigame => _currentMinigame;
  Score? _highestScore;
  Score? get highestScore => _highestScore;

  MinigameState._internal();

  factory MinigameState() {
    _instance ??= MinigameState._internal();
    return _instance!;
  }

  void setMinigame(MinigameStart? minigame) {
    _currentMinigame = minigame;
    notifyListeners();
  }

  void setHighestScore(Score? score)
  {
    _highestScore = score;
  }
}