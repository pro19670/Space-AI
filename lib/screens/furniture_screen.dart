import 'package:flutter/material.dart';
import '../widgets/0_space_app_bar.dart';
import 'position_screen.dart'; // 반드시 import!

class FurnitureScreen extends StatefulWidget {
  final String roomName;

  const FurnitureScreen({Key? key, required this.roomName}) : super(key: key);

  @override
  State<FurnitureScreen> createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  List<String> furnitures = [];

  void _showAddFurnitureDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('가구 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '가구 이름',
            hintText: '예: 서랍장, 침대',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  furnitures.add(controller.text.trim());
                });
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
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: SpaceAppBar(
        title: '${widget.roomName} 가구배치',
        totalItemCount: furnitures.length,
        onAddPressed: _showAddFurnitureDialog,
        addButtonLabel: '가구추가',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: furnitures.isEmpty
            ? const Center(
                child: Text(
                  '아직 등록된 가구가 없습니다',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children: furnitures
                    .map(
                      (item) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PositionScreen(furnitureName: item),
                            ),
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            border: Border.all(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
