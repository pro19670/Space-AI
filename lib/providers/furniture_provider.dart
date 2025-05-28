import 'package:flutter/material.dart';

class FurnitureProvider with ChangeNotifier {
  List<String> furnitures = [];

  void addFurniture(String name) {
    furnitures.add(name);
    notifyListeners();
  }

  void removeFurniture(String name) {
    furnitures.remove(name);
    notifyListeners();
  }

  // 필요하다면 더 많은 메서드 추가
}
