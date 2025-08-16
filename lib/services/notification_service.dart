import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 푸시 알림 서비스 스텁
class NotificationService {
  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  Future<void> init({required String uid}) async {
    await _fcm.requestPermission();
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(const InitializationSettings(android: android, iOS: ios));

    final token = await _fcm.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({'token': token}, SetOptions(merge: true));
    }
    _fcm.onTokenRefresh.listen((t) async {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({'token': t}, SetOptions(merge: true));
    });
  }

  Future<void> showLocal(String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('msg', 'Messages'),
      iOS: DarwinNotificationDetails(),
    );
    await _local.show(0, title, body, details);
  }
}
