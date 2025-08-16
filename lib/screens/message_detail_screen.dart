import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/message_detail_provider.dart';
import '../widgets/index_bar.dart';
import '../widgets/soft_key_bar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/feature_status_bar.dart';
import '../services/time_util.dart';
import '../repositories/messages_repository.dart';

/// 메시지 상세 화면
class MessageDetailScreen extends ConsumerWidget {
  final String threadId;
  const MessageDetailScreen({super.key, required this.threadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(messageDetailProvider);
    final notifier = ref.read(messageDetailProvider.notifier);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FeatureStatusBar(timeText: '3:55'),
          Expanded(
            child: _MessageBody(
              threadId: threadId,
              state: state,
              onPrev: notifier.prev,
              onNext: (total) => notifier.next(total),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SoftKeyBar(
        onMenu: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.black,
            builder: (c) => ListView(children: const [
              ListTile(title: Text('통화 걸기', style: TextStyle(color: Colors.white))),
              ListTile(title: Text('즐겨찾기', style: TextStyle(color: Colors.white))),
              ListTile(title: Text('삭제', style: TextStyle(color: Colors.white))),
            ]),
          );
        },
        onOk: notifier.toggleRead,
        onReply: () => context.push('/compose/$threadId'),
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  final String threadId;
  final MessageDetailState state;
  final VoidCallback onPrev;
  final void Function(int total) onNext;

  const _MessageBody({
    required this.threadId,
    required this.state,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final demoMessages = [
      {
        'title': '약속 꼭 약속',
        'body': '오늘 스터디 7시에 보는 거 잊지 말기! 장소는 그대로.',
        'sender': '예지',
        'timestamp': '12/16 12:22 PM'
      },
      {
        'title': null,
        'body': '넵 내일 봬요. 자료는 공유드릴게요.',
        'sender': '010-0000-0000',
        'timestamp': '12/16 12:25 PM'
      }
    ];

    final canUseFirebase = Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null;

    if (!canUseFirebase) {
      final idx = state.index.clamp(0, demoMessages.length - 1);
      final msg = demoMessages[idx];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IndexBar(index: idx, total: demoMessages.length, onPrev: onPrev, onNext: () => onNext(demoMessages.length)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: MessageBubble(
              title: msg['title'] as String?,
              body: msg['body'] as String,
              sender: msg['sender'] as String,
              timestamp: msg['timestamp'] as String,
            ),
          ),
          const Spacer(),
        ],
      );
    }

    final repo = MessagesRepository();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: repo.watchMessages(threadId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IndexBar(index: 0, total: 0, onPrev: null, onNext: null),
              const Expanded(child: Center(child: Text('메시지가 없습니다'))),
            ],
          );
        }
        final idx = state.index.clamp(0, docs.length - 1);
        final data = docs[idx].data();
        final ts = (data['createdAt'] as Timestamp?)?.toDate();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IndexBar(index: idx, total: docs.length, onPrev: onPrev, onNext: () => onNext(docs.length)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MessageBubble(
                title: data['title'] as String?,
                body: (data['body'] as String?) ?? '',
                sender: (data['senderId'] as String?) ?? 'unknown',
                timestamp: ts != null ? formatTimestamp(ts) : '',
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
