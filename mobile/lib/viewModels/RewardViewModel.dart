import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/state/MinigameState.dart';
import '../models/Room.dart';
import '../services/network/GameService.dart';
import '../state/RoomState.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

class RewardViewModel extends ChangeNotifier{
  final GameService _gameService = GameService();
  final MinigameState _minigameState = MinigameState();
  final RoomState _roomState = RoomState();

  String? _reward;
  String? get reward => _reward;

  List<String> _deadPlayers = [];
  List<String> get deadPlayers => _deadPlayers;

  List<String>? _playerUsernames;
  List<String>? get playerUsernames => _playerUsernames;

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
    await _gameService.useReward(room!.id, playerUsername);
  }

  void fetchPlayerUsernamesFromVoting(VotingViewModel votingViewModel) {
    _playerUsernames = votingViewModel.playerUsernames;
    notifyListeners();
  }

  void fetchDeadPlayerUsernamesFromVoting(VotingViewModel votingViewModel) {
    _deadPlayers = votingViewModel.deadPlayers;
    notifyListeners();
  }

}