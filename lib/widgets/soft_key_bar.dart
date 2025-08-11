import 'package:flutter/material.dart';

/// 하단 소프트키 바: 메뉴 | 확인 | 답장
class SoftKeyBar extends StatelessWidget {
  final VoidCallback? onMenu;
  final VoidCallback? onOk;
  final VoidCallback? onReply;

  const SoftKeyBar({super.key, this.onMenu, this.onOk, this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onMenu,
              child: const Text('메뉴', semanticsLabel: '메뉴'),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: onOk,
              child: const Text('확인', semanticsLabel: '확인'),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: onReply,
              child: const Text('답장', semanticsLabel: '답장'),
            ),
          ),
        ],
      ),
    );
  }
}
