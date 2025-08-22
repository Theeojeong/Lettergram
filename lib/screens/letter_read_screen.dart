import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 받은 편지 열람 화면(상대 메시지만 보여주는 장면)
class LetterReadScreen extends StatelessWidget {
  const LetterReadScreen({super.key, this.letterId, this.threadId, this.messageId});
  final String? letterId; // 데모용
  final String? threadId; // Firestore 경로용
  final String? messageId; // Firestore 경로용

  @override
  Widget build(BuildContext context) {
    if (threadId != null && messageId != null) {
      return _buildFromFirestore(context);
    }
    // 데모 데이터(레거시 경로: /letter/:id)
    final data = _demoLetters[letterId!] ?? _demoLetters.values.first;
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('편지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 상단 소인 영역 제거: 곧바로 본문 표시
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6, // 행간
                      fontFamilyFallback: const ['Georgia', 'serif'],
                      color: onSurface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 상단 여백만 유지 (구분선 제거)
                        const SizedBox(height: 12),
                        // 본문 메시지
                        Text(data['body'] as String),
                        const SizedBox(height: 16),
                        // 본문 아래 정보: 월/일 시:분 am/pm, 발신자 이름, 발신자 전화번호
                        Builder(builder: (_) {
                          final ts = (data['timestamp'] as DateTime?) ?? DateTime.now();
                          final name = data['from'] as String? ?? '';
                          final phone = data['phone'] as String? ?? '';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatTimeAmPm(ts),
                                style: TextStyle(
                                  color: onSurface.withOpacity(0.55),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: onSurface,
                                  fontWeight: FontWeight.w600, // iOS Notes 느낌의 세미볼드
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                phone,
                                style: TextStyle(
                                  color: onSurface.withOpacity(0.45),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 하단 액션과의 간격만 유지 (구분선 제거)
          const SizedBox(height: 8),
          _BottomActions(
            onMenu: () => _showMenu(context),
            onConfirm: () => context.go('/'),
            onReply: () => context.push('/compose/${data['from']}'),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildFromFirestore(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final docRef = FirebaseFirestore.instance
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .doc(messageId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('편지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: docRef.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!.data();
          if (data == null) return const Center(child: Text('메시지를 찾을 수 없습니다'));
          final body = data['body'] as String? ?? '';
          final ts = (data['createdAt'] as Timestamp?)?.toDate();
          final name = data['senderName'] as String? ?? '';
          final phone = data['senderPhone'] as String? ?? '';
          final attachments = (data['attachments'] as List?)?.cast<Map>() ?? const [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          fontFamilyFallback: const ['Georgia', 'serif'],
                          color: onSurface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            Text(body),
                            const SizedBox(height: 12),
                            if (attachments.isNotEmpty) ...[
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: attachments
                                    .map((a) => Chip(
                                          avatar: const Icon(Icons.attachment, size: 16),
                                          label: Text((a['name'] as String?) ?? '첨부'),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                            ],
                            Builder(builder: (_) {
                              final timeStr = ts != null ? _formatTimeAmPm(ts) : '';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      color: onSurface.withOpacity(0.55),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: onSurface,
                                          fontWeight: FontWeight.w600,
                                        ) ??
                                        const TextStyle(),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      color: onSurface.withOpacity(0.45),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _BottomActions(
                onMenu: () => _showMenu(context),
                onConfirm: () => context.go('/'),
                onReply: () => context.push('/compose/${threadId}'),
              ),
            ],
          );
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
              listTileTheme: const ListTileThemeData(
                textColor: Colors.white,
                iconColor: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('엽서로 저장(PDF)')),
                ListTile(leading: Icon(Icons.format_quote), title: Text('인용으로 모으기')),
                Divider(height: 1, color: Colors.white24),
                ListTile(leading: Icon(Icons.report_gmailerrorred), title: Text('신고/차단')),
                ListTile(leading: Icon(Icons.volume_off), title: Text('봉투음/개봉음 끄기')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onMenu,
    required this.onConfirm,
    required this.onReply,
  });
  final VoidCallback onMenu;
  final VoidCallback onConfirm;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: onMenu,
              icon: const Icon(Icons.more_horiz),
              tooltip: '메뉴',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                child: const Text('확인'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply),
                label: const Text('답장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

final Map<String, Map<String, Object>> _demoLetters = {
  'r1': {
    'from': '윤슬',
    'phone': '010-1234-5678',
    'timestamp': DateTime(2025, 8, 15, 15, 12),
    'body': '오늘은 방금 내린 비의 냄새가 유난히 오래 남았어.\n창틀에 기대면 흙 냄새와 섞여 들려오는 소리들이\n마치 작은 합창 같아서...'
  },
  'r2': {
    'from': '별비',
    'phone': '010-9876-5432',
    'timestamp': DateTime(2025, 8, 12, 21, 5),
    'body': '밤하늘에 스치는 별빛들을 모아 편지지에 눌러 담았어.'
  },
  'r3': {
    'from': '민호',
    'phone': '010-2222-3333',
    'timestamp': DateTime(2025, 8, 10, 10, 30),
    'body': '창밖의 비는 한참을 머물다 갔고,\n유리창엔 작은 강이 흘렀지.'
  },
};

String _formatTimeAmPm(DateTime dt) {
  int hour = dt.hour;
  final min = dt.minute.toString().padLeft(2, '0');
  final ampm = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour == 0) hour = 12;
  return '$hour:$min $ampm';
}

// (구분선 제거)
