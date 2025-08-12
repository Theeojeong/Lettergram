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
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.grey.shade700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: onPrev, icon: const Icon(Icons.arrow_left, color: Colors.white)),
          Text('< ${index + 1}/$total >', style: const TextStyle(fontSize: 14, color: Colors.white)),
          IconButton(onPressed: onNext, icon: const Icon(Icons.arrow_right, color: Colors.white)),
        ],
      ),
    );
  }
}
