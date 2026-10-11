import 'package:flutter/material.dart';

/// temi 머리 태블릿(가로 10인치대, 허리 높이 시점)에 맞춘 테마.
abstract final class AppTheme {
  /// 키오스크 버튼 최소 높이. 설계안 기준 64dp.
  static const minButtonHeight = 64.0;

  static ThemeData light() {
    final base = ThemeData(
      colorSchemeSeed: const Color(0xFF1E5AA8),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(fontSizeFactor: 1.2),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(200, minButtonHeight),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
