import 'package:flutter/material.dart';
import '../widgets/0_space_app_bar.dart';

class ItemScreen extends StatefulWidget {
  final String positionName;

  const ItemScreen({Key? key, required this.positionName}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  List<String> items = [];

  void _showAddItemDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('물품 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '물품 이름',
            hintText: '예: 계란, 우유, 치즈 등',
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
                  items.add(controller.text.trim());
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
        title: '${widget.positionName} 물품',
        totalItemCount: items.length,
        onAddPressed: _showAddItemDialog,
        addButtonLabel: '물품추가',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: items.isEmpty
            ? const Center(
                child: Text(
                  '아직 등록된 물품이 없습니다',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children: items
                    .map(
                      (item) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
