import 'package:flutter/material.dart';

/// 인덱스 바 위젯: < 23/100 > 형태
class IndexBar extends StatelessWidget {
  final int index;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const IndexBar({
    super.key,
    required this.index,
    required this.total,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 0) {
          onPrev?.call();
        } else {
          onNext?.call();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: onPrev, icon: const Icon(Icons.arrow_left)),
          Text('< ${index + 1}/$total >', style: const TextStyle(fontSize: 16)),
          IconButton(onPressed: onNext, icon: const Icon(Icons.arrow_right)),
        ],
      ),
    );
  }
}
