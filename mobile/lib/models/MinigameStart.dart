import 'MinigameType.dart';

class MinigameStart {
  final int id;
  final MinigameType type;

  MinigameStart({
    required this.id,
    required this.type
  });

  factory MinigameStart.fromJson(Map<String, dynamic> json) {
    MinigameType type = MinigameType.values.firstWhere(
      (e) => e.name.toLowerCase() == json['type'].toLowerCase(),
      orElse: () => throw Exception('Invalid type')
    );
    return MinigameStart(
      id: json['id'],
      type: type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name.toUpperCase()
    };
  }
}