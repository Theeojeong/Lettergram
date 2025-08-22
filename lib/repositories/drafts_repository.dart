import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DraftsRepository {
  final _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchDrafts() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('drafts')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<void> saveDraft({required String to, required String body, List<Map<String, dynamic>> attachments = const []}) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('drafts')
        .add({
      'to': to,
      'body': body,
      'attachments': attachments,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDraft(String draftId) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('drafts')
        .doc(draftId)
        .delete();
  }
}

