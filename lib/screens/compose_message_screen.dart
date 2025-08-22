import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/messages_repository.dart';
import '../repositories/threads_repository.dart';

/// 새 메시지/답장 작성 화면 (문자: SMS/MMS)
class ComposeMessageScreen extends StatefulWidget {
  final String threadId;
  const ComposeMessageScreen({super.key, required this.threadId});

  @override
  State<ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final _controller = TextEditingController();
  final _recipientController = TextEditingController();
  // 프롬프트 사용 여부만 유지
  bool _promptOn = true;

  @override
  void dispose() {
    _controller.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipient = widget.threadId == 'new' ? '수신인' : widget.threadId;
    return Scaffold(
      appBar: AppBar(title: Text('새 메시지 — 문자(SMS/MMS)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1) 수신인 입력(새 메시지일 때 표시)
              if (widget.threadId == 'new') ...[
                TextField(
                  controller: _recipientController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '수신인(번호)',
                    hintText: '예: 01012345678',
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
                    hintText: '본문을 입력하세요…',
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
                  // (옵션) 멀티미디어 첨부(데모)
                  IconButton(
                    tooltip: '첨부(사진/오디오) — 데모',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('첨부'),
                          content: const Text('데모 환경: 파일 선택 없이 첨부 옵션만 표시합니다.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.attachment_outlined),
                  ),
                  const Spacer(),
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
                        final to = widget.threadId == 'new'
                            ? _recipientController.text.trim()
                            : widget.threadId;
                        if (widget.threadId == 'new' && to.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('수신인 번호를 입력하세요')),
                          );
                          return;
                        }
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
                          await threadsRepo.upsertThread(to, [uid]);
                          final messagesRepo = MessagesRepository();
                          await messagesRepo.sendMessage(to, {
                            'body': text,
                            'senderId': uid,
                            'title': null,
                          });
                          await threadsRepo.touchUpdatedAt(to);
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
