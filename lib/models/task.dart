class Task {
  final int id;
  String name;
  final int points;

  Task({
    required this.id,
    required this.name,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'points': points,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      points: json['points'] ?? 1,
    );
  }
}
