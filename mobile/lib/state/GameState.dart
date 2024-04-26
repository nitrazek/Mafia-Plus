import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobile/services/WebSocketClient.dart';

import '../models/GameEnd.dart';
import '../models/GameStart.dart';
import '../models/Round.dart';

class GameState extends ChangeNotifier {
  static GameState? _instance;

  final StreamController<void> _gameFinished = StreamController.broadcast();
  Stream<void> get gameFinished => _gameFinished.stream;

  GameStart? _currentGame;
  GameStart? get currentGame => _currentGame;

  GameEnd? _currentGameEnd;
  GameEnd? get currentGameEnd => _currentGameEnd;

  GameState._internal();

  factory GameState() {
    _instance ??= GameState._internal();
    return _instance!;
  }

  void setGame(GameStart? game) {
    _currentGame = game;
    notifyListeners();
  }

  void setGameEnd(GameEnd? gameEnd) {
    _currentGameEnd = gameEnd;
    _gameFinished.add(null);
    notifyListeners();
  }
}