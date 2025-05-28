import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class Item {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String spaceId;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final List<String> tags;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final Map<String, dynamic>? customAttributes;

  Item({
    String? id,
    required this.name,
    required this.category,
    this.quantity = 1,
    required this.spaceId,
    this.description,
    List<String>? tags,
    this.customAttributes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.id = id ?? const Uuid().v4(),
    this.tags = tags ?? [],
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();

  // 복사 메서드
  Item copyWith({
    String? name,
    String? category,
    int? quantity,
    String? spaceId,
    String? description,
    List<String>? tags,
    Map<String, dynamic>? customAttributes,
  }) {
    return Item(
      id: this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      spaceId: spaceId ?? this.spaceId,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      customAttributes: customAttributes ?? this.customAttributes,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
