import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_detail_provider.dart';
import '../widgets/index_bar.dart';
import '../widgets/soft_key_bar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/feature_status_bar.dart';

/// 메시지 상세 화면
class MessageDetailScreen extends ConsumerWidget {
  final String threadId;
  const MessageDetailScreen({super.key, required this.threadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 데모용 메시지 리스트
    final messages = [
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

    final state = ref.watch(messageDetailProvider);
    final notifier = ref.read(messageDetailProvider.notifier);
    final msg = messages[state.index];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FeatureStatusBar(timeText: '3:55'),
          IndexBar(
            index: state.index,
            total: messages.length,
            onPrev: () => notifier.prev(),
            onNext: () => notifier.next(messages.length),
          ),
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
