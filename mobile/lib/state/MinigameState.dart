import 'package:flutter/cupertino.dart';

import '../models/MinigameStart.dart';
import '../models/Score.dart';

class MinigameState extends ChangeNotifier {
  static MinigameState? _instance;

  MinigameStart? _currentMinigame;
  MinigameStart? get currentMinigame => _currentMinigame;
  Score? _scores;
  Score? get scores => _scores;
  String? _reward;
  String? get reward => _reward;

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
    notifyListeners();
  }

  void setReward(String? reward){
    _reward = reward;
  }
}