import 'package:hive/hive.dart';

part 'space.g.dart'; // build_runner로 자동 생성되는 파일

@HiveType(typeId: 0)
class Space extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type; // 예: home, office 등

  @HiveField(3)
  String level; // 계층(예: '1')

  @HiveField(4)
  int itemCount; // 물품 개수

  @HiveField(5)
  String? parentId; // 상위 공간 ID (null 가능)

  @HiveField(6)
  List<String>? structures; // 방/구조 리스트 (간단 예시)

  Space({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    required this.itemCount,
    this.parentId,
    this.structures,
  });
}
