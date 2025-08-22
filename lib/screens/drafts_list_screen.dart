import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// 임시보관함: users/{uid}/drafts
class DraftsListScreen extends StatelessWidget {
  const DraftsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ready = Firebase.apps.isNotEmpty;
    final uid = ready ? FirebaseAuth.instance.currentUser?.uid : null;
    return Scaffold(
      appBar: AppBar(title: const Text('임시보관함')),
      body: !ready
          ? const _CenterText('Firebase 미설정: 임시보관함은 미리보기 불가')
          : uid == null
              ? const _CenterText('로그인이 필요합니다')
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('drafts')
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? const [];
                if (docs.isEmpty) return const _CenterText('임시 저장된 메시지가 없습니다');
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final d = docs[i];
                    final to = d.data()['to'] as String? ?? '상대';
                    final body = (d.data()['body'] as String?) ?? '';
                    return Dismissible(
                      key: ValueKey(d.id),
                      background: Container(color: Colors.redAccent),
                      onDismissed: (_) => d.reference.delete(),
                      child: ListTile(
                        leading: const Icon(Icons.drafts_outlined),
                        title: Text('[임시] → $to — "${_ellipsis(body)}"'),
                      ),
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
