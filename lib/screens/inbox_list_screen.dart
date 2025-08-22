import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 받은 편지함: 목록 → 항목 선택 → 단일 메시지 보기
class InboxListScreen extends StatelessWidget {
  const InboxListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ready = Firebase.apps.isNotEmpty;
    final uid = ready ? FirebaseAuth.instance.currentUser?.uid : null;
    return Scaffold(
      appBar: AppBar(title: const Text('받은 편지함')),
      body: !ready
          ? const Center(child: Text('Firebase 미설정: 받은 편지함은 미리보기 불가'))
          : uid == null
              ? const Center(child: Text('로그인이 필요합니다'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('messages')
                  .where('members', arrayContains: uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs
                        .where((d) => (d.data()['senderId'] as String?) != uid)
                        .toList() ??
                    const [];
                if (docs.isEmpty) {
                  return const Center(child: Text('받은 메시지가 없습니다'));
                }
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final d = docs[i];
                    final data = d.data();
                    final from = data['senderName'] as String? ?? '상대';
                    final body = data['body'] as String? ?? '';
                    // 메시지 단일 보기로 이동: threadId와 messageId 필요
                    final segments = d.reference.path.split('/');
                    // threads/{threadId}/messages/{messageId}
                    final threadId = segments[1];
                    final messageId = segments[3];
                    return ListTile(
                      leading: const Icon(Icons.mark_email_unread_outlined),
                      title: Text('$from — "${_ellipsis(body)}"'),
                      trailing: Icon(Icons.chevron_right,
                          color: isDark ? Colors.white30 : Colors.black26),
                      onTap: () => context.push('/letter/$threadId/$messageId'),
                    );
                  },
                );
              },
            ),
    );
  }
}

String _ellipsis(String s, {int max = 18}) {
  if (s.length <= max) return s;
  return s.substring(0, max) + '…';
}
