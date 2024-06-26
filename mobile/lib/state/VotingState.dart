import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobile/models/VotingSummary.dart';

import '../models/Round.dart';
import '../models/VotingEnd.dart';
import '../models/VotingStart.dart';

class VotingState extends ChangeNotifier {
  static VotingState? _instance;

  final StreamController<void> _votingStarted = StreamController.broadcast();
  Stream<void> get votingStarted => _votingStarted.stream;

  final StreamController<void> _votingFinished = StreamController.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  VotingStart? _currentVoting;
  VotingStart? get currentVoting => _currentVoting;

  VotingSummary? _currentVotingSummary;
  VotingSummary? get currentVotingSummary => _currentVotingSummary;

  VotingEnd? _currentVotingEnd;
  VotingEnd? get currentVotingEnd => _currentVotingEnd;

  VotingState._internal();

  factory VotingState() {
    _instance ??= VotingState._internal();
    return _instance!;
  }

  void setVoting(VotingStart? votingStart) {
    _currentVoting = votingStart;
    if(votingStart != null) _votingStarted.add(null);
    notifyListeners();
  }

  void setVotingSummary(VotingSummary? votingSummary) {
    _currentVotingSummary = votingSummary;
    if(votingSummary != null) _votingFinished.add(null);
    notifyListeners();
  }

  void setVotingEnd(VotingEnd? votingEnd) {
    _currentVotingEnd = votingEnd;
    if(votingEnd != null) _votingFinished.add(null);
    notifyListeners();
  }
}