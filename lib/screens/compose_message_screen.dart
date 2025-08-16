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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('답장: ${widget.threadId}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '메시지를 입력하세요'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
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
                  await threadsRepo.upsertThread(widget.threadId, [uid]);
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
              child: const Text('보내기', semanticsLabel: '보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
