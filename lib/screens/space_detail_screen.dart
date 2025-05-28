// 📄 lib/screens/space_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // ✅ Hive 추가
import '../models/space.dart';
import '../services/database_service.dart';
import '../screens/furniture_screen.dart'; // 반드시 import 추가!
import '../widgets/0_space_app_bar.dart'; // 반드시 import

class SpaceDetailScreen extends StatefulWidget {
  final Space space;

  const SpaceDetailScreen({Key? key, required this.space}) : super(key: key);

  @override
  State<SpaceDetailScreen> createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  late Space currentSpace;
  final DatabaseService _databaseService = DatabaseService();
  List<String> structures = [];

  // ✅ Hive 박스 선언 추가
  late Box<Space> _spacesBox;

  @override
  void initState() {
    super.initState();
    currentSpace = widget.space;
    _initializeHive(); // ✅ Hive 초기화
    _loadSpace();
    structures = currentSpace.structures ?? [];
  }

  // ✅ Hive Box 초기화 함수
  Future<void> _initializeHive() async {
    _spacesBox = await Hive.openBox<Space>('spaces');
  }

  Future<void> _loadSpace() async {
    try {
      final space = await _databaseService.getSpace(widget.space.id);
      if (space != null && mounted) {
        setState(() {
          currentSpace = space;
          structures = currentSpace.structures ?? [];
        });
      }
    } catch (e) {
      debugPrint('Error loading space: $e');
    }
  }

  final TextEditingController _structureNameController = TextEditingController();

  void _showAddStructureDialog() {
    _structureNameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공간(방) 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: const Icon(Icons.meeting_room, size: 32, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _structureNameController,
              decoration: const InputDecoration(
                labelText: '방 이름',
                border: OutlineInputBorder(),
                hintText: '예: 안방, 거실 등',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_structureNameController.text.trim().isNotEmpty) {
                setState(() {
                  final newStructure = _structureNameController.text.trim();
                  structures.add(newStructure);
                  currentSpace.structures = structures;
                });

                // ✅ Hive에 변경된 구조 저장
                try {
                  await _spacesBox.put(currentSpace.id, currentSpace);
                  debugPrint('Hive 저장 완료');
                } catch (e) {
                  debugPrint('Hive 저장 오류: $e');
                }

                Navigator.pop(context);
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalStructureCount = structures.length;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: SpaceAppBar(
        title: '${currentSpace.name} 구조',
        totalItemCount: totalStructureCount,
        onAddPressed: _showAddStructureDialog,
        addButtonLabel: '방추가',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            if (structures.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: structures
                    .map((str) => _buildStructureBox(str))
                    .toList(),
              ),
            const SizedBox(height: 16),
            const Text(
              '물품 목록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('물품 추가 기능은 아직 개발 중입니다')),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('물품 추가'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '아직 등록된 물품이 없습니다',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 구조(방) 박스 UI
  Widget _buildStructureBox(String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FurnitureScreen(roomName: title),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
