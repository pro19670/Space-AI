// 📄 lib/providers/space_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/space.dart';

class SpaceProvider extends ChangeNotifier {
  final Box<Space> spaceBox;

  SpaceProvider(this.spaceBox) {
    _loadSpaces();
  }

  List<Space> _spaces = [];

  List<Space> get spaces => _spaces;

  void _loadSpaces() {
    _spaces = spaceBox.values.toList();
    notifyListeners();
  }

  Future<void> addSpace(Space space) async {
    await spaceBox.put(space.id, space);
    _loadSpaces();
  }

  Future<void> updateSpace(Space space) async {
    await spaceBox.put(space.id, space);
    _loadSpaces();
  }

  Future<void> deleteSpace(String id) async {
    await spaceBox.delete(id);
    _loadSpaces();
  }

  Space? getSpaceById(String id) {
    return spaceBox.get(id);
  }

  int get totalItemCount {
    return _spaces.fold(0, (sum, space) => sum + space.itemCount);
  }
}
