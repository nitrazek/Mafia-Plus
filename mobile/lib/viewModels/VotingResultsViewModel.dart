import 'dart:async';

import '../models/VotingSummary.dart';
import '../state/VotingState.dart';
import 'package:flutter/material.dart';

class VotingResultsViewModel extends ChangeNotifier {
  final VotingState _votingState = VotingState();

  VotingSummary? _votingSummary;
  VotingSummary? get votingSummary => _votingSummary;

  final _votingFinished = StreamController<void>.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  VotingResultsViewModel() {
    _votingState.addListener(_updateVotingSummary); _updateVotingSummary();
    _votingState.votingFinished.listen((_) {
      if(_votingState.currentVotingEnd == null) return;
      _votingFinished.add(null);
      notifyListeners();
    });
  }

  void _updateVotingSummary() {
    if(_votingState.currentVotingSummary == null) return;
    _votingSummary = _votingState.currentVotingSummary;
  }
}