import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/messages_repository.dart';
import '../repositories/threads_repository.dart';

/// 답장 작성 화면
class ComposeMessageScreen extends StatefulWidget {
  final String threadId;
  const ComposeMessageScreen({super.key, required this.threadId});

  @override
  State<ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final _controller = TextEditingController();
  // 프롬프트 사용 여부만 유지
  bool _promptOn = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipient = widget.threadId == 'new' ? '상대' : widget.threadId;
    return Scaffold(
      appBar: AppBar(title: Text('새 편지 — ${recipient}에게')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 프롬프트 토글만 유지
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✦ 프롬프트'),
                  Switch(
                      value: _promptOn,
                      onChanged: (v) => setState(() => _promptOn = v)),
                ],
              ),
              const SizedBox(height: 8),
              if (_promptOn)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '문학 프롬프트: 창밖의 소리를 묘사해볼까요?',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        fontSize: 13),
                  ),
                ),
              // 박스(테두리) 없이 메모장처럼 입력
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: '여름의 공기에는 비밀이 숨어있대.\n(…)',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                    isDense: false,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('임시 저장됨(데모)')),
                        );
                      },
                      child: const Text('임시 저장'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final text = _controller.text.trim();
                        if (text.isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                        final canUseFirebase = Firebase.apps.isNotEmpty;
                        if (canUseFirebase) {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            await FirebaseAuth.instance.signInAnonymously();
                          }
                          final uid = FirebaseAuth.instance.currentUser!.uid;
                          final threadsRepo = ThreadsRepository();
                          await threadsRepo
                              .upsertThread(widget.threadId, [uid]);
                          final messagesRepo = MessagesRepository();
                          await messagesRepo.sendMessage(widget.threadId, {
                            'body': text,
                            'senderId': uid,
                            'title': null,
                          });
                          await threadsRepo.touchUpdatedAt(widget.threadId);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.mark_email_read_outlined),
                      label: const Text('발송✉'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
