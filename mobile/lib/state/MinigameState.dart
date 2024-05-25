import 'package:flutter/cupertino.dart';

import '../models/MinigameStart.dart';
import '../models/Reward.dart';
import '../models/Score.dart';

class MinigameState extends ChangeNotifier {
  static MinigameState? _instance;

  MinigameStart? _currentMinigame;
  MinigameStart? get currentMinigame => _currentMinigame;
  Score? _scores;
  Score? get scores => _scores;
  Reward? _reward;
  Reward? get reward => _reward;

  MinigameState._internal();

  factory MinigameState() {
    _instance ??= MinigameState._internal();
    return _instance!;
  }

  void setMinigame(MinigameStart? minigame) {
    _currentMinigame = minigame;
    notifyListeners();
  }

  void setScores(Score? scores)
  {
    _scores = scores;
  }

  void setReward(Reward? reward){
    _reward = reward;
  }
}