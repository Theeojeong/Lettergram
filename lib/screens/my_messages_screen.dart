import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 내 메시지: 보조함 목록 (Inbox / Drafts / Outbox / Sentbox / Templates / Broadcast / Memory status)
class MyMessagesScreen extends StatelessWidget {
  const MyMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Folder(icon: Icons.inbox_outlined, title: '받은 편지함 (Inbox)', route: '/inbox'),
      _Folder(icon: Icons.drafts_outlined, title: '임시보관함 (Drafts)', route: '/folders/drafts'),
      _Folder(icon: Icons.outbox_outlined, title: '보낼 편지함 (Outbox)', route: '/folders/outbox'),
      _Folder(icon: Icons.send_outlined, title: '보낸 편지함 (Sentbox)', route: '/folders/sent'),
      _Folder(icon: Icons.note_alt_outlined, title: '템플릿 (Templates)', route: '/folders/templates'),
      _Folder(icon: Icons.wifi_tethering_outlined, title: '방송메시지 (Cell Broadcast)', route: '/folders/broadcast'),
      _Folder(icon: Icons.sd_storage_outlined, title: '메모리 상태 (Memory status)', route: '/folders/memory'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('내 메시지')),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final it = items[i];
          return ListTile(
            leading: Icon(it.icon),
            title: Text(it.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(it.route),
          );
        },
      ),
    );
  }
}

class _Folder {
  final IconData icon;
  final String title;
  final String route;
  const _Folder({required this.icon, required this.title, required this.route});
}

