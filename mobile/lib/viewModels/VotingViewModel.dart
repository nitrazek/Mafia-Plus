import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/state/RoomState.dart';
import '../models/Room.dart';
import '../models/VotingSummary.dart';
import '../services/network/GameService.dart';
import '../state/VotingState.dart';

class VotingViewModel extends ChangeNotifier {
  final VotingState _votingState = VotingState();
  final GameService _gameService = GameService();

  int? _votingId;

  List<String>? _playerUsernames;
  List<String>? get playerUsernames => _playerUsernames;

  String? _votedPlayer;
  String? get votedPlayer => _votedPlayer;

  Room? _room;
  Room? get room => _room;

  final _votingFinished = StreamController<void>.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  VotingViewModel() {
    _votingState.addListener(_updateVoting); _updateVoting();
    _votingState.votingFinished.listen((_) {
      if(_votingState.currentVotingSummary == null) return;
      _votedPlayer = null;
      _votingFinished.add(null);
      notifyListeners();
    });
  }

  void _updateVoting() {
    if(_votingState.currentVoting == null) return;
    _votingId = _votingState.currentVoting!.id;
    _playerUsernames = _votingState.currentVoting!.playerUsernames;
    notifyListeners();
  }

  void vote(String playerUsername) async {
    _votedPlayer = playerUsername;
    await _gameService.addVote(_votingId!, playerUsername);
    notifyListeners();
  }
}