import 'package:flutter/material.dart';

/// 2014년 피처폰 분위기의 테마 정의
final ThemeData retroTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'NotoSansKR',
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.deepPurple,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white, textColor: Colors.white),
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.black),
);
