import 'package:cloud_firestore/cloud_firestore.dart';

/// 메시지 관련 Firestore 액세스
class MessagesRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> sendMessage(String threadId, Map<String, dynamic> data) async {
    await _db.collection('threads').doc(threadId).collection('messages').add(data);
  }
}
