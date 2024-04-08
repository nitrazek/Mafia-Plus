import 'package:flutter/material.dart';

import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/VotingState.dart';

class VotedViewModel extends ChangeNotifier {
  final VotingState _votingState = VotingState();
  String? _votingType;
  String? get votingType => _votingType;

  String? _votedPlayerNickname;
  String? get votedPlayerNickname => _votedPlayerNickname;

  VotedViewModel() {
    _votingState.addListener(_updateVotingType); _updateVotingType();
    _votingState.addListener(_updateVotedPlayerNickname); _updateVotedPlayerNickname();
  }

  void _updateVotingType(){
    if (_votingState.currentVoting == null) return;
    else {
      _votingType = _votingState.currentVoting?.type;
      _votingType = _votingType![0].toUpperCase()+_votingType!.substring(1).toLowerCase();
    }
  }

  void _updateVotedPlayerNickname() {
    if (_votingState.currentVoting == null) return;
    else {
      if (_votingState.currentVotingEnd?.votedUsername != null)
        {
          _votedPlayerNickname = _votingState.currentVotingEnd?.votedUsername;
        }
      else {
        _votedPlayerNickname = "Nobody";
      }
    }
  }

}