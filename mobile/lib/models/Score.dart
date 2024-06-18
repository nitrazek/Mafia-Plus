import 'Account.dart';

class Score {
  final Account winner;
  final int highestScore;
  final Map<String, int> scores;

  Score({
    required this.highestScore,
    required this.winner,
    required this.scores
});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      highestScore: json['highestScore'],
      winner: Account.fromJson(json['winner']),
      scores: Map<String, int>.from(json['scores']),
    );
  }
}