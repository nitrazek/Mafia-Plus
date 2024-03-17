import 'package:flutter/cupertino.dart';

import '../models/Round.dart';
import '../services/WebSocketClient.dart';

class RoundState extends ChangeNotifier {
  static RoundState? _instance;
  final WebSocketClient _webSocketClient = WebSocketClient();

  Round? _currentRound;
  Round? get currentRound => _currentRound;

  RoundState._internal() {
    _webSocketClient.roundStartUpdate.listen((round) {
      _currentRound = round;
      notifyListeners();
    });
  }

  factory RoundState() {
    _instance ??= RoundState._internal();
    return _instance!;
  }
}