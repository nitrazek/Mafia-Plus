import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:mobile/viewModels/minigames/ClickTheButtonMinigameViewModel.dart';

import '../../services/network/MinigameService.dart';
import '../../state/MinigameState.dart';
import '../../state/VotingState.dart';

class NumberMemoryMinigameViewModel extends ChangeNotifier {
  final MinigameService _minigameService = MinigameService();
  final MinigameState _minigameState = MinigameState();
  final VotingState _votingState = VotingState();
  static final Random _random = Random();

  String _generatedNumber = "";
  String get generatedNumber => _generatedNumber;

  bool _isNumberVisible = true;
  bool get isNumberVisible => _isNumberVisible;

  void Function() _hideNumberCallback = () {};

  int? _minigameId;
  int _score = 0;

  final _votingStarted = StreamController<void>.broadcast();
  Stream<void> get votingStarted => _votingStarted.stream;

  NumberMemoryMinigameViewModel() {
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

  String _generateRandomNumber(int length) {
    String firstDigit = (_random.nextInt(9) + 1).toString();
    String restDigits = List.generate(length - 1, (index) => _random.nextInt(10).toString()).join();
    return firstDigit + restDigits;
  }

  void generateNumber() {
    _generatedNumber = _generateRandomNumber(_score + 1);
  }

  bool submitAnswer(String answer) {
    bool isCorrect = answer == _generatedNumber;
    if(isCorrect) { _score++; }
    return isCorrect;
  }

  Future<void> finishMinigame() async {
    await _minigameService.finishMinigame(_minigameId!, _score);
    notifyListeners();
  }
}