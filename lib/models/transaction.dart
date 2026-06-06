class Transaction {
  final String date;
  final String type; // 'earn' или 'spend'
  final int itemId;
  final String name;
  final int points;
  final DateTime timestamp;

  Transaction({
    required this.date,
    required this.type,
    required this.itemId,
    required this.name,
    required this.points,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'itemId': itemId,
      'name': name,
      'points': points,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'] ?? '',
      type: json['type'] ?? 'earn',
      itemId: json['itemId'] ?? 0,
      name: json['name'] ?? '',
      points: json['points'] ?? 0,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
