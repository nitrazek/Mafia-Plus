import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/GameHistory.dart';
import '../services/network/GameService.dart';

class GameHistoryViewModel extends ChangeNotifier {
  final GameService _gameService = GameService();
  List<GameHistory> _gameHistory = [];

  List<GameHistory> get gameHistory => _gameHistory;

  Future<void> fetchGameHistory() async {
    try{
        _gameHistory = await _gameService.getHistory();
        notifyListeners();
      } catch (e) {
        print('Error: $e');
      }
    }
}
