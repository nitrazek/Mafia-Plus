import 'Account.dart';
import 'Round.dart';

class GameHistory {
  final int id;
  final DateTime createTimestamp;
  final int roundsPlayed;
  final List<String> playersUsernames;
  final String winnerRole;

  GameHistory({
    required this.id,
    required this.createTimestamp,
    required this.roundsPlayed,
    required this.playersUsernames,
    required this.winnerRole,
  });

  factory GameHistory.fromJson(Map<String, dynamic> json) {
    return GameHistory(
      id: json['id'],
      createTimestamp: DateTime.parse(json['createTimestamp']),
      roundsPlayed: json['roundsPlayed'],
      playersUsernames: List<String>.from(json['playersUsernames']),
      winnerRole: json['winnerRole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createTimestamp': createTimestamp.toIso8601String(),
      'roundsPlayed': roundsPlayed,
      'playersUsernames': playersUsernames,
      'winnerRole': winnerRole,
    };
  }
}

