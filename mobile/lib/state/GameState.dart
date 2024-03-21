import 'package:flutter/cupertino.dart';
import 'package:mobile/services/WebSocketClient.dart';

import '../models/GameStart.dart';
import '../models/Round.dart';

class GameState extends ChangeNotifier {
  static GameState? _instance;
  final WebSocketClient _webSocketClient = WebSocketClient();

  GameStart? _currentGame;
  GameStart? get currentGame => _currentGame;

  Round? _currentRound;
  Round? get currentRound => _currentRound;

  GameState._internal() {
    _webSocketClient.gameStartUpdate.listen((gameStart) {
      _currentGame = gameStart;
      notifyListeners();
    });
    _webSocketClient.roundStartUpdate.listen((round) {
      _currentRound = round;
      notifyListeners();
    });
  }

  factory GameState() {
    _instance ??= GameState._internal();
    return _instance!;
  }
}