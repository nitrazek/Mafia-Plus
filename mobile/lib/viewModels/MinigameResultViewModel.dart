import 'package:flutter/material.dart';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/state/AccountState.dart';
import 'package:mobile/state/MinigameState.dart';

import '../models/Account.dart';
import '../models/Score.dart';

class MinigameResultViewModel extends ChangeNotifier {
  final MinigameState _minigameState = MinigameState();
  final AccountState _accountState = AccountState();

  Score? _scores;
  Score? get scores => _scores;
  Account? _account;
  Account? get account => _account;


  MinigameResultViewModel() {
    _minigameState.addListener(_updateScores); _updateScores();
    _accountState.addListener(_updatePlayer); _updatePlayer();

  }

  void _updateScores() {
    if(_minigameState.scores == null) return;
    _scores = _minigameState.scores;
    notifyListeners();
  }
  void _updatePlayer() {
    if(_accountState.currentAccount == null) return;
    _account = _accountState.currentAccount;
  }

}