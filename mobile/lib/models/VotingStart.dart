class VotingStart {
  final int id;
  final String type;
  final bool isAlive;
  final List<String>? playerUsernames;

  VotingStart({
    required this.id,
    required this.type,
    required this.isAlive,
    this.playerUsernames
  });

  factory VotingStart.fromJson(Map<String, dynamic> json) {
    var playerUsernames = json['playerUsernames'];
    return VotingStart(
      id: json['id'],
      type: json['type'],
      isAlive: json['isAlive'],
      playerUsernames: playerUsernames != null ? List<String>.from(json['playerUsernames']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'isAlive': isAlive,
      'playerUsernames': playerUsernames
    };
  }
}