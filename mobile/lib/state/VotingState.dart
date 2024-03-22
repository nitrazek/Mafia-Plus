import 'package:flutter/cupertino.dart';
import 'package:mobile/models/VotingSummary.dart';

import '../models/Round.dart';
import '../services/WebSocketClient.dart';

class VotingState extends ChangeNotifier {
  static VotingState? _instance;
  final WebSocketClient _webSocketClient = WebSocketClient();

  VotingSummary? _currentVotingSummary;
  VotingSummary? get currentVotingSummary => _currentVotingSummary;

  VotingState._internal() {
    _webSocketClient.votingSummaryUpdate.listen((votingSummary) {
      _currentVotingSummary = votingSummary;
      notifyListeners();
    });
  }

  factory VotingState() {
    _instance ??= VotingState._internal();
    return _instance!;
  }
}