import 'package:flutter/material.dart';

import 'package:mobile/state/GameState.dart';

class VotedViewModel extends ChangeNotifier {
  final GameState _gameState = GameState();

  String _votedPlayerNickname = 'Nobody';
  String get votedPlayerNickname => _votedPlayerNickname;

  String _votingType = 'City';
  String get votingType => _votingType;

}