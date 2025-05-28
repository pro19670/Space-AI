class Furniture {
  final String id;
  final String name;
  final String type; // 예: 서랍장, 침대 등
  final String roomName; // 어떤 방에 속하는지

  Furniture({
    required this.id,
    required this.name,
    required this.type,
    required this.roomName,
  });
}
