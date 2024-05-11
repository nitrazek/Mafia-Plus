import 'dart:math';

import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';

class NumberMemoryMinigameViewModel extends MinigameViewModel {
  static final Random _random = Random();

  String _generatedNumber = "";
  String get generatedNumber => _generatedNumber;

  bool _isNumberVisible = true;
  bool get isNumberVisible => _isNumberVisible;

  String _generateRandomNumber(int length) {
    String firstDigit = (_random.nextInt(9) + 1).toString();
    String restDigits = List.generate(length - 1, (index) => _random.nextInt(10).toString()).join();
    return firstDigit + restDigits;
  }

  @override
  void init() {
    _generatedNumber = _generateRandomNumber(1);
    _isNumberVisible = true;
    notifyListeners();
  }

  void submitAnswer(String answer) {

  }
}