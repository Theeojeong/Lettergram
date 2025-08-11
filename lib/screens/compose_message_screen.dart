import 'package:flutter/material.dart';

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
              onPressed: () {
                // Firestore에 메시지 추가 및 푸시 전송은 서비스 레이어에서 처리. 여기서는 스텁.
                Navigator.pop(context);
              },
              child: const Text('보내기', semanticsLabel: '보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
