import 'package:flutter/material.dart';

/// 피처폰 스타일 상단 상태바
class FeatureStatusBar extends StatelessWidget {
  final String timeText;
  const FeatureStatusBar({super.key, required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          const Icon(Icons.battery_full, color: Colors.white, size: 14),
          const Spacer(),
          Text(timeText, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}