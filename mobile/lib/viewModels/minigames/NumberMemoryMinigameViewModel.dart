import 'dart:math';

import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';

class NumberMemoryMinigameViewModel extends MinigameViewModel {
  static final Random _random = Random();

  int _currentNumberLength = 1;

  String _generatedNumber = "";
  String get generatedNumber => _generatedNumber;

  bool _isNumberVisible = true;
  bool get isNumberVisible => _isNumberVisible;

  void Function() _hideNumberCallback = () {};

  String _generateRandomNumber(int length) {
    String firstDigit = (_random.nextInt(9) + 1).toString();
    String restDigits = List.generate(length - 1, (index) => _random.nextInt(10).toString()).join();
    return firstDigit + restDigits;
  }

  @override
  void init() {
    _generatedNumber = _generateRandomNumber(_currentNumberLength);
    _isNumberVisible = true;
    notifyListeners();
    _hideNumberCallback();
  }

  void setHideNumberCallback(void Function() callback) {
    _hideNumberCallback = callback;
  }

  void submitAnswer(String answer) {
    _generatedNumber = _generateRandomNumber(++_currentNumberLength);
    _isNumberVisible = true;
    notifyListeners();
    _hideNumberCallback();
  }
}