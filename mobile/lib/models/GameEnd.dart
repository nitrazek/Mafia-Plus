class GameEnd {
  final String winnerRole;

  GameEnd({
    required this.winnerRole
  });

  factory GameEnd.fromJson(Map<String, dynamic> json) {
    return GameEnd(
      winnerRole: json['winnerRole']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'winnerRole': winnerRole
    };
  }
}