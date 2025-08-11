import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 푸시 알림 서비스 스텁
class NotificationService {
  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _fcm.requestPermission();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(const InitializationSettings(android: android, iOS: ios));
  }

  Future<void> showLocal(String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('msg', 'Messages'),
      iOS: DarwinNotificationDetails(),
    );
    await _local.show(0, title, body, details);
  }
}
