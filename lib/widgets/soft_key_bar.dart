import 'package:flutter/material.dart';

/// 하단 소프트키 바: 메뉴 | 확인 | 답장
class SoftKeyBar extends StatelessWidget {
  final VoidCallback? onMenu;
  final VoidCallback? onOk;
  final VoidCallback? onReply;

  const SoftKeyBar({super.key, this.onMenu, this.onOk, this.onReply});

  Widget _btn(String label, VoidCallback? onTap) => InkWell(
        onTap: onTap,
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.grey.shade700)),
      ),
      child: Row(
        children: [
          Expanded(child: _btn('메뉴', onMenu)),
          Container(width: 1, color: Colors.grey.shade700),
          Expanded(child: _btn('확인', onOk)),
          Container(width: 1, color: Colors.grey.shade700),
          Expanded(child: _btn('답장', onReply)),
        ],
      ),
    );
  }
}
