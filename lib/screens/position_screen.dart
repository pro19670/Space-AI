import 'package:flutter/material.dart';
import '../widgets/0_space_app_bar.dart';
import 'item_screen.dart'; // 반드시 import!

class PositionScreen extends StatefulWidget {
  final String furnitureName;

  const PositionScreen({Key? key, required this.furnitureName}) : super(key: key);

  @override
  State<PositionScreen> createState() => _PositionScreenState();
}

class _PositionScreenState extends State<PositionScreen> {
  List<String> positions = [];

  void _showAddPositionDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('위치 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '위치 이름',
            hintText: '예: 상단, 하단, 문 쪽 등',
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
                  positions.add(controller.text.trim());
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
        title: '${widget.furnitureName} 위치',
        totalItemCount: positions.length,
        onAddPressed: _showAddPositionDialog,
        addButtonLabel: '위치추가',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: positions.isEmpty
            ? const Center(
                child: Text(
                  '아직 등록된 위치가 없습니다',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children: positions
                    .map(
                      (item) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemScreen(positionName: item),
                            ),
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal[50],
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.teal,
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