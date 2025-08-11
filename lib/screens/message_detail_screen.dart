import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_detail_provider.dart';
import '../widgets/index_bar.dart';
import '../widgets/soft_key_bar.dart';
import '../widgets/message_bubble.dart';

/// 메시지 상세 화면
class MessageDetailScreen extends ConsumerWidget {
  final String threadId;
  const MessageDetailScreen({super.key, required this.threadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 데모용 메시지 리스트
    final messages = [
      {
        'body': '안녕? 오늘 저녁에 시간 돼?',
        'sender': '친구',
        'timestamp': '12/16 12:22 PM'
      },
      {
        'body': '네 내일 봐요!',
        'sender': '010-0000-0000',
        'timestamp': '12/16 12:25 PM'
      }
    ];

    final state = ref.watch(messageDetailProvider);
    final notifier = ref.read(messageDetailProvider.notifier);
    final msg = messages[state.index];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 24,
        title: const Text('3:55', textAlign: TextAlign.right),
      ),
      body: Column(
        children: [
          IndexBar(
            index: state.index,
            total: messages.length,
            onPrev: () => notifier.prev(),
            onNext: () => notifier.next(messages.length),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: MessageBubble(
              body: msg['body']!,
              sender: msg['sender']!,
              timestamp: msg['timestamp']!,
            ),
          ),
          const Spacer(),
          SoftKeyBar(
            onMenu: () {
              showModalBottomSheet(
                  context: context,
                  builder: (c) => ListView(children: const [
                        ListTile(title: Text('통화 걸기')), // 더미
                        ListTile(title: Text('즐겨찾기')),
                        ListTile(title: Text('삭제')),
                      ]));
            },
            onOk: notifier.toggleRead,
            onReply: () => context.push('/compose/$threadId'),
          ),
        ],
      ),
    );
  }
}
