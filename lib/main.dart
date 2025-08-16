import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'device_preview_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/thread_list_screen.dart';
import 'screens/message_detail_screen.dart';
import 'screens/compose_message_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/letter_read_screen.dart';
import 'retro_theme.dart';
import 'services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool firebaseReady = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
    // iOS 포그라운드 알림 표시 옵션
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // 익명 로그인으로 최소 인증 보장
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    // 토큰 등록 등 알림 초기화
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await NotificationService().init(uid: uid);
  } catch (_) {
    firebaseReady = false; // Firebase 설정이 없어도 UI 미리보기 가능
  }
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      devices: preferredDevices(),
      builder: (context) => const ProviderScope(child: RetroApp()),
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (c, s) => const ThreadListScreen()),
    // 새 편지 열람 화면(받은 편지 단일 장면)
    GoRoute(path: '/letter/:id', builder: (c, s) {
      final id = s.pathParameters['id']!;
      return LetterReadScreen(letterId: id);
    }),
    GoRoute(path: '/thread/:id', builder: (c, s) {
      final id = s.pathParameters['id']!;
      return MessageDetailScreen(threadId: id);
    }),
    GoRoute(path: '/compose/:id', builder: (c, s) {
      final id = s.pathParameters['id']!;
      return ComposeMessageScreen(threadId: id);
    }),
    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
  ],
);

class RetroApp extends ConsumerWidget {
  const RetroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // DevicePreview 연동으로 화면 크기/픽셀 비율/방향을 미리보기와 동기화
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      title: 'Retro Messenger',
      theme: retroTheme,
      routerConfig: _router,
      supportedLocales: const [Locale('ko'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
