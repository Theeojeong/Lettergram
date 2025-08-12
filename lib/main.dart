import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/thread_list_screen.dart';
import 'screens/message_detail_screen.dart';
import 'screens/compose_message_screen.dart';
import 'screens/settings_screen.dart';
import 'retro_theme.dart';

void main() {
  // Firestore 오프라인 퍼스트를 위해 초기화 과정이 필요하지만 여기서는 스텁 처리
  runApp(const ProviderScope(child: RetroApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (c, s) => const ThreadListScreen()),
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
      title: 'Retro Messenger',
      theme: retroTheme,
      routerConfig: _router,
      locale: const Locale('ko'),
      supportedLocales: const [Locale('ko'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
