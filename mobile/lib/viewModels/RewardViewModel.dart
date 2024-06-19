import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/state/MinigameState.dart';
import '../models/Room.dart';
import '../services/network/GameService.dart';
import '../state/RoomState.dart';

class RewardViewModel extends ChangeNotifier{
  final GameService _gameService = GameService();
  final MinigameState _minigameState = MinigameState();
  final RoomState _roomState = RoomState();

  String? _reward;
  String? get reward => _reward;

  RewardViewModel(){
    _minigameState.addListener(_updateReward); _updateReward();
  }

  void _updateReward(){
    if(_minigameState.reward ==null) return;
    _reward=_minigameState.reward;
    notifyListeners();
  }

  Future<void> useReward(String playerUsername) async{
  Room? room = _roomState.currentRoom;
    await _gameService.useReward(playerUsername);
  }
}