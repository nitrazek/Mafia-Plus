class RoomSettings {
  final bool isPublic;
  final int maxNumberOfPlayers;

  RoomSettings({
    required this.isPublic,
    required this.maxNumberOfPlayers,
  });

  factory RoomSettings.fromJson(Map<String, dynamic> json) {
    return RoomSettings(
      isPublic: json['isPublic'],
      maxNumberOfPlayers: json['maxNumberOfPlayers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPublic': isPublic,
      'maxNumberOfPlayers': maxNumberOfPlayers,
    };
  }
}