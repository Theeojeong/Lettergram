import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// 보낸 편지함: senderId == uid 인 메시지 모아보기
class SentListScreen extends StatelessWidget {
  const SentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ready = Firebase.apps.isNotEmpty;
    final uid = ready ? FirebaseAuth.instance.currentUser?.uid : null;
    return Scaffold(
      appBar: AppBar(title: const Text('보낸 편지함')),
      body: !ready
          ? const _CenterText('Firebase 미설정: 보낸 편지함은 미리보기 불가')
          : uid == null
              ? const _CenterText('로그인이 필요합니다')
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('messages')
                  .where('senderId', isEqualTo: uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? const [];
                if (docs.isEmpty) return const _CenterText('보낸 메시지가 없습니다');
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final d = docs[i].data();
                    final to = (d['members'] as List?)?.firstWhere(
                          (m) => m != uid,
                          orElse: () => '상대',
                        ) ??
                        '상대';
                    final body = (d['body'] as String?) ?? '';
                    return ListTile(
                      leading: const Icon(Icons.outbox_outlined),
                      title: Text('→ $to — "${_ellipsis(body)}"'),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _CenterText extends StatelessWidget {
  const _CenterText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Center(child: Text(text));
}

String _ellipsis(String s, {int max = 18}) {
  if (s.length <= max) return s;
  return s.substring(0, max) + '…';
}
