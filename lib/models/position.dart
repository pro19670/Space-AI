class Position {
  final String id;
  final String name;
  final List<Item> items; // 이 Position에 속한 물품 리스트

  Position({
    required this.id,
    required this.name,
    List<Item>? items,
  }) : items = items ?? [];

  // 예: JSON 변환 메서드
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      name: json['name'],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class Item {
  final String id;
  final String name;

  Item({
    required this.id,
    required this.name,
  });

  // JSON 변환
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}