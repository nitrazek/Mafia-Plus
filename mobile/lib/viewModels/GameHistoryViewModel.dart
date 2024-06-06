import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/GameHistory.dart';

class GameHistoryViewModel extends ChangeNotifier {
  final GameService _gameService = GameService();
  List<GameHistory> _gameHistory = [];

  List<GameHistory> get gameHistory => _gameHistory;

  Future<void> fetchGameHistory() async {
    try{
      //zakomentowane bo serwsue ni ma
       // List <Game> games = await _gameHistory.getGames();
      _gameHistory =
        notifyListeners();
      } catch (e) {
        print('Error: $e');
      }
  }
}
