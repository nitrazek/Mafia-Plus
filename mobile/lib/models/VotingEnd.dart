class VotingEnd {
  final String votingType;
  final String votedUsername;
  final bool isAlive;

  VotingEnd({
    required this.votingType,
    required this.votedUsername,
    required this.isAlive,
  });

  factory VotingEnd.fromJson(Map<String, dynamic> json) {
    return VotingEnd(
      votingType: json['votingType'],
      votedUsername: json['votedUsername'],
      isAlive: json['isAlive']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votingType': votingType,
      'votedUsername': votedUsername,
      'isAlive' : isAlive
    };
  }
}