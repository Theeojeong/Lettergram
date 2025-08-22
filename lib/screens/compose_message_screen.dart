import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../repositories/messages_repository.dart';
import '../repositories/threads_repository.dart';
import '../repositories/drafts_repository.dart';

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
  List<PlatformFile> _picked = [];

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
                    tooltip: '첨부(사진/오디오/파일)',
                    onPressed: _pickFiles,
                    icon: const Icon(Icons.attachment_outlined),
                  ),
                  if (_picked.isNotEmpty)
                    Text('${_picked.length}개 첨부됨', style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      child: const Text('임시 저장'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _send,
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

  Future<void> _pickFiles() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: true, withData: true);
    if (res != null && mounted) {
      setState(() => _picked = res.files);
    }
  }

  Future<void> _saveDraft() async {
    final to = widget.threadId == 'new' ? _recipientController.text.trim() : widget.threadId!;
    final body = _controller.text.trim();
    if (to.isEmpty && widget.threadId == 'new') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('수신인 번호를 입력하세요')));
      return;
    }
    if (!Firebase.apps.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firebase 미설정: 로컬 임시 저장은 미지원')));
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    final drafts = DraftsRepository();
    await drafts.saveDraft(
      to: to,
      body: body,
      attachments: _picked.map((p) => {'name': p.name, 'size': p.size, 'mime': p.extension}).toList(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('임시 저장됨')));
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final to = widget.threadId == 'new' ? _recipientController.text.trim() : widget.threadId!;
    if (widget.threadId == 'new' && to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('수신인 번호를 입력하세요')));
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
      // 간단히 members를 [나, 수신인]으로 기록(데모)
      final members = {uid, to}.toList();
      await threadsRepo.upsertThread(to, members);

      // 첨부 업로드(Firebase Storage에 저장) -> 다운로드 URL 수집
      List<Map<String, dynamic>> attachments = [];
      if (_picked.isNotEmpty) {
        final storage = FirebaseStorage.instance;
        for (final f in _picked) {
          try {
            final bytes = f.bytes;
            if (bytes == null) continue; // 일부 플랫폼에서는 path만 제공될 수 있음
            final ref = storage
                .ref()
                .child('attachments')
                .child(uid)
                .child('${DateTime.now().millisecondsSinceEpoch}_${f.name}');
            final task = await ref.putData(bytes, SettableMetadata(contentType: _guessMime(f.name)));
            final url = await task.ref.getDownloadURL();
            attachments.add({
              'name': f.name,
              'size': f.size,
              'url': url,
              'mime': _guessMime(f.name),
            });
          } catch (_) {
            // 개별 첨부 실패는 무시하고 진행
          }
        }
      }

      final messagesRepo = MessagesRepository();
      await messagesRepo.sendMessage(to, {
        'body': text,
        'senderId': uid,
        'senderName': '나',
        'senderPhone': '',
        'title': null,
        'members': members,
        'attachments': attachments,
      });
      await threadsRepo.touchUpdatedAt(to);
    }
    if (mounted) Navigator.pop(context);
  }
}

String _guessMime(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.mp3')) return 'audio/mpeg';
  if (lower.endsWith('.wav')) return 'audio/wav';
  if (lower.endsWith('.mp4')) return 'video/mp4';
  return 'application/octet-stream';
}
