import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 2014년 피처폰 분위기의 테마 정의
final ThemeData retroTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: CupertinoColors.systemYellow.color,
    secondary: CupertinoColors.systemGrey.color,
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF111315),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white70,
    textColor: Colors.white,
    dense: true,
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.white12,
    thickness: 0.6,
    space: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white10,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white24),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white38),
    ),
    hintStyle: const TextStyle(color: Colors.white54),
  ),
  cardColor: const Color(0xFF1C1D21),
);
