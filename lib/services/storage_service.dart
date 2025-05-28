// services/storage_service.dart
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/space.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static const String _spacesBoxName = 'spaces';
  late Box<Space> _spacesBox;
  
  // 싱글톤 패턴
  factory StorageService() => _instance;
  
  StorageService._internal();

  // 스토리지 서비스 초기화
  Future<void> initialize() async {
    try {
      // 앱이 Hive.initFlutter()를 main.dart에서 이미 호출했는지 확인
      if (!Hive.isBoxOpen(_spacesBoxName)) {
        _spacesBox = await Hive.openBox<Space>(_spacesBoxName);
      } else {
        _spacesBox = Hive.box<Space>(_spacesBoxName);
      }
    } catch (e) {
      print('스토리지 서비스 초기화 오류: $e');
      rethrow;
    }
  }

  // 공간 목록 저장
  Future<void> saveSpaces(List<Space> spaces) async {
    try {
      // 기존 데이터 초기화
      await _spacesBox.clear();
      
      // 공간 목록 저장
      for (final space in spaces) {
        await _spacesBox.put(space.id, space);
      }
    } catch (e) {
      print('공간 목록 저장 오류: $e');
      rethrow;
    }
  }

  // 저장된 공간 목록 불러오기
  Future<List<Space>> getSpaces() async {
    try {
      return _spacesBox.values.toList();
    } catch (e) {
      print('공간 목록 불러오기 오류: $e');
      return [];
    }
  }

  // 특정 ID의 공간 삭제
  Future<List<Space>> deleteSpaces(List<String> ids) async {
    try {
      // 주어진 ID 목록을 포함하는 공간과 그 하위 공간 찾기
      final spaces = await getSpaces();
      bool foundNew = true;
      while (foundNew) {
        foundNew = false;
        for (final space in spaces) {
          if (space.parentId != null && 
              ids.contains(space.parentId) && 
              !ids.contains(space.id)) {
            ids.add(space.id);
            foundNew = true;
          }
        }
      }
      
      // 삭제할 공간 목록에서 제거
      for (final id in ids) {
        await _spacesBox.delete(id);
      }
      
      // 업데이트된 공간 목록 반환
      return await getSpaces();
    } catch (e) {
      print('공간 삭제 오류: $e');
      return await getSpaces();
    }
  }
}
