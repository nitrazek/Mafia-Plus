import 'dart:async';

import 'package:flutter/material.dart';
import '../state/VotingState.dart';

class WaitingViewModel extends ChangeNotifier {
  final VotingState _votingState = VotingState();

  String? _turn;
  String? get turn =>_turn;

  final _votingFinished = StreamController<void>.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  WaitingViewModel() {
    _votingState.addListener(_updateTurn); _updateTurn();
    _votingState.votingFinished.listen((_) {
      if (_votingState.currentVotingSummary == null && _votingState.currentVotingEnd == null) return;
      _votingFinished.add(null);
      notifyListeners();
    });
  }

  void _updateTurn() {
    if (_votingState.currentVoting == null) return;
    _turn = _votingState.currentVoting!.type;
    notifyListeners();
  }
}