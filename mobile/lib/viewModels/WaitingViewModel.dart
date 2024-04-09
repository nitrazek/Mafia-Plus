import 'dart:async';

import 'package:flutter/material.dart';
import '../state/VotingState.dart';

class WaitingViewModel extends ChangeNotifier {
  final VotingState _votingState = VotingState();

  final _votingFinished = StreamController<void>.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  WaitingViewModel() {
    _votingState.votingFinished.listen((_) {
      if (_votingState.currentVotingSummary == null) return;
      _votingFinished.add(null);
      notifyListeners();
    });
  }
}