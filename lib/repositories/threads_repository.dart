import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadsRepository {
  final _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchThreads(String uid) {
    return _db
        .collection('threads')
        .where('members', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<void> upsertThread(String threadId, List<String> members) async {
    final ref = _db.collection('threads').doc(threadId);
    await ref.set({
      'members': members,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> touchUpdatedAt(String threadId) async {
    await _db.collection('threads').doc(threadId).set({
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
