import 'package:flutter/cupertino.dart';
import 'package:mobile/models/VotingSummary.dart';

import '../models/Round.dart';
import '../models/VotingStart.dart';
import '../services/WebSocketClient.dart';

class VotingState extends ChangeNotifier {
  static VotingState? _instance;

  VotingSummary? _currentVotingSummary;
  VotingSummary? get currentVotingSummary => _currentVotingSummary;

  VotingStart? _currentVoting;
  VotingStart? get currentVoting => _currentVoting;

  VotingState._internal();

  factory VotingState() {
    _instance ??= VotingState._internal();
    return _instance!;
  }

  void setVoting(VotingStart? votingStart) {
    _currentVoting = votingStart;
    notifyListeners();
  }

  void setVotingSummary(VotingSummary? votingSummary) {
    _currentVotingSummary = votingSummary;
    notifyListeners();
  }
}