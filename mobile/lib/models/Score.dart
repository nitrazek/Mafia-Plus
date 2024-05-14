import 'Account.dart';

class Score {
  final Account bestPlayer;
  final int bestScore;
  final Map<Account, int> playersScores;

  Score({
    required this.bestScore,
    required this.bestPlayer,
    required this.playersScores
});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
        bestScore: json['bestScore'],
      bestPlayer: json['bestPlayer'],
      playersScores: json['playersScores'],

    );
  }
}