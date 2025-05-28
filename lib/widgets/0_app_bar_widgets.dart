import 'package:flutter/material.dart';

class SpaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int totalItemCount;
  final VoidCallback onAddPressed;

  const SpaceAppBar({
    Key? key,
    required this.title,
    required this.totalItemCount,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      centerTitle: false,
      title: Stack(
        children: [
          // 정중앙: 총 개수
          Center(
            child: Text(
              '총 $totalItemCount개',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
          ),
          // 좌측: 타이틀 + 버튼
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 20),
                label: const Text(
                  '공간추가',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
