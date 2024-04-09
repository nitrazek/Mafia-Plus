class VotingEnd {
  final String votedUsername;

  VotingEnd({
    required this.votedUsername,
  });

  factory VotingEnd.fromJson(Map<String, dynamic> json) {
    return VotingEnd(
      votedUsername: json['votedUsername']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votedUsername': votedUsername
    };
  }
}