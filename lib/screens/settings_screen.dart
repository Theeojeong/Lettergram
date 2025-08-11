import 'package:flutter/material.dart';

/// 설정 및 계정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('알림 허용'),
            value: true,
            onChanged: (v) {},
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('계정 삭제'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('개인정보 처리방침'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
