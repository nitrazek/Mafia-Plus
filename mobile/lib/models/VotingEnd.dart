class VotingEnd {
  final String votingType;
  final String votedUsername;

  VotingEnd({
    required this.votingType,
    required this.votedUsername,
  });

  factory VotingEnd.fromJson(Map<String, dynamic> json) {
    return VotingEnd(
      votingType: json['votingType'],
      votedUsername: json['votedUsername']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votingType': votingType,
      'votedUsername': votedUsername
    };
  }
}