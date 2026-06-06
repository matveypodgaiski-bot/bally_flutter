class ShopItem {
  final int id;
  String name;
  final int points;

  ShopItem({
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

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      points: json['points'] ?? 3,
    );
  }
}
