import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 받은 편지함: 목록 → 항목 선택 → 단일 메시지 보기
class InboxListScreen extends StatelessWidget {
  const InboxListScreen({super.key});

  // 데모용 데이터
  static const _inbox = [
    {'id': 'r1', 'from': '윤슬', 'title': '여름 한 구절', 'status': '도착·미개봉'},
    {'id': 'r2', 'from': '별비', 'title': '밤하늘 소인', 'status': '도착·개봉'},
    {'id': 'r3', 'from': '민호', 'title': '창밖의 비', 'status': '도착·미개봉'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('받은 편지함')),
      body: ListView.separated(
        itemCount: _inbox.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final it = _inbox[i];
          final opened = (it['status']?.toString().contains('개봉') ?? false);
          return ListTile(
            leading: Icon(opened
                ? Icons.mark_email_read_outlined
                : Icons.mark_email_unread_outlined),
            title: Text('${it['from']} — "${it['title']}"'),
            trailing: Icon(Icons.chevron_right,
                color: isDark ? Colors.white30 : Colors.black26),
            onTap: () => context.push('/letter/${it['id']}'),
          );
        },
      ),
    );
  }
}

