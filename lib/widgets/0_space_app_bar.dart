import 'package:flutter/material.dart';

class SpaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int totalItemCount;
  final VoidCallback onAddPressed;
  final String addButtonLabel;

  const SpaceAppBar({
    Key? key,
    required this.title,
    required this.totalItemCount,
    required this.onAddPressed,
    this.addButtonLabel = '공간추가',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 1,
            titleSpacing: 0.0,
            centerTitle: false,
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 20),
                  label: Text(
                    addButtonLabel,
                    style: const TextStyle(
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
            actions: const [
              // 오른쪽 끝 비우기(필요하면 추가)
              SizedBox(width: 16),
            ],
          ),
          // 중앙: 총 개수
          Center(
            child: Text(
              '총 $totalItemCount개',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
