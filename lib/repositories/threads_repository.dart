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
}
