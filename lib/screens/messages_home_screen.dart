import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 최상위: 메시지 홈 화면 (메뉴)
/// - 새 메시지 작성 → 문자(SMS/MMS)
/// - 내 메시지 → 받은 편지함 등 보조함 목록
class MessagesHomeScreen extends StatelessWidget {
  const MessagesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메시지')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('새 메시지 작성'),
            subtitle: const Text('문자(SMS/MMS)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/compose/new'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('내 메시지'),
            subtitle: const Text('받은 편지함, 임시보관함 등'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/my'),
          ),
        ],
      ),
    );
  }
}

