
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/space.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static const String _spacesBoxName = 'spaces';
  late Box<Space> _spacesBox;

  // 싱글톤 패턴
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // 데이터베이스 초기화
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(SpaceAdapter());
      }

      _spacesBox = await Hive.openBox<Space>(_spacesBoxName);
      debugPrint('Hive 데이터베이스 초기화 완료');
    } catch (e) {
      debugPrint('Hive 초기화 오류: \$e');
      rethrow;
    }
  }

  // 샘플 데이터 추가
  Future<void> seedSampleData() async {
    try {
      if (_spacesBox.isEmpty) {
        final spaces = [
          Space(id: '1', name: '우리집', type: 'home', itemCount: 0, level: '1'),
          Space(id: '2', name: '사무실', type: 'office', itemCount: 0, level: '1'),
          Space(id: '3', name: '창고', type: 'storage', itemCount: 0, level: '1'),
        ];
        for (var space in spaces) {
          await insertSpace(space);
        }
        debugPrint('샘플 데이터 추가 완료');
      } else {
        debugPrint('데이터가 이미 존재하므로 샘플 데이터를 추가하지 않음');
      }
    } catch (e) {
      debugPrint('샘플 데이터 추가 오류: \$e');
      rethrow;
    }
  }

  // 공간 추가
  Future<void> insertSpace(Space space) async {
    try {
      await _spacesBox.put(space.id, space);
    } catch (e) {
      debugPrint('공간 추가 오류: \$e');
      rethrow;
    }
  }

  // 공간 가져오기
  Future<Space?> getSpace(String id) async {
    try {
      return _spacesBox.get(id);
    } catch (e) {
      debugPrint('공간 가져오기 오류: \$e');
      return null;
    }
  }

  // 공간 목록 가져오기
  Future<List<Space>> getSpaces() async {
    try {
      return _spacesBox.values.toList();
    } catch (e) {
      debugPrint('공간 목록 가져오기 오류: \$e');
      return [];
    }
  }

  // 공간 업데이트
  Future<void> updateSpace(Space space) async {
    try {
      await _spacesBox.put(space.id, space);
    } catch (e) {
      debugPrint('공간 업데이트 오류: \$e');
      rethrow;
    }
  }

  // 공간 삭제
  Future<void> deleteSpace(String id) async {
    try {
      await _spacesBox.delete(id);
    } catch (e) {
      debugPrint('공간 삭제 오류: \$e');
      rethrow;
    }
  }

  // 모든 데이터 삭제
  Future<void> clearAllData() async {
    try {
      await _spacesBox.clear();
    } catch (e) {
      debugPrint('데이터 초기화 오류: \$e');
      rethrow;
    }
  }

  // ✅ 공간이 있으면 업데이트, 없으면 추가
  Future<void> saveOrUpdateSpace(Space space) async {
    try {
      if (_spacesBox.containsKey(space.id)) {
        await _spacesBox.put(space.id, space);
      } else {
        await _spacesBox.add(space); // 신규일 경우 key 자동 생성
      }
    } catch (e) {
      debugPrint('공간 저장 또는 업데이트 오류: \$e');
      rethrow;
    }
  }
}
