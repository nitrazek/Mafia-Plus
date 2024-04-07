class VotingStart {
  final int id;
  final String type;
  final List<String>? playerUsernames;

  VotingStart({
    required this.id,
    required this.type,
    this.playerUsernames
  });

  factory VotingStart.fromJson(Map<String, dynamic> json) {
    return VotingStart(
      id: json['id'],
      type: json['type'],
      playerUsernames: List<String>.from(json['playerUsernames'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'playerUsernames': playerUsernames
    };
  }
}