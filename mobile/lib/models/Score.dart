class Score {
  final int score;

  Score({
    required this.score,
});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
        score: json['score'],
    );
  }
}