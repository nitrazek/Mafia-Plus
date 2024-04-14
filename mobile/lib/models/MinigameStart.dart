class MinigameStart {
  final MinigameTitle title;

  MinigameStart({
    required this.title
  });

  factory MinigameStart.fromJson(Map<String, dynamic> json) {
    MinigameTitle title = MinigameTitle.values.firstWhere(
      (e) => e.name.toLowerCase() == json['title'].toLowerCase(),
      orElse: () => throw Exception('Invalid title')
    );
    return MinigameStart(
      title: title
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.name.toLowerCase()
    };
  }
}

enum MinigameTitle {
  TEST
}