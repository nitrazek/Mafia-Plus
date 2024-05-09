import 'package:flutter/cupertino.dart';

import '../models/MinigameStart.dart';

class MinigameState extends ChangeNotifier {
  static MinigameState? _instance;

  MinigameStart? _currentMinigame;
  MinigameStart? get currentMinigame => _currentMinigame;

  MinigameState._internal();

  factory MinigameState() {
    _instance ??= MinigameState._internal();
    return _instance!;
  }

  void setMinigame(MinigameStart? minigame) {
    _currentMinigame = minigame;
    notifyListeners();
  }
}