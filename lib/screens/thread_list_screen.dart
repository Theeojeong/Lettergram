import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 대화 목록 화면
class ThreadListScreen extends StatelessWidget {
  const ThreadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 데모용 쓰레드 목록
    final threads = [
      {'id': '1', 'name': '친구', 'preview': '안녕? 오늘 저녁에 시간 돼?', 'time': '12:22'},
      {'id': '2', 'name': '동료', 'preview': '회의는 내일로', 'time': '11:11'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('대화 목록')),
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          final t = threads[index];
          return ListTile(
            title: Text(t['name']!),
            subtitle: Text(t['preview']!),
            trailing: Text(t['time']!),
            onTap: () => context.push('/thread/${t['id']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/compose/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
