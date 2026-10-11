import 'package:flutter/material.dart';

/// G-Mate 색 팔레트.
///
/// 화면에서는 이 값을 직접 쓰지 말고 `Theme.of(context).colorScheme` 또는
/// `context.appColors`(의미 색)를 통해 꺼내 쓴다.
abstract final class AppColors {
  // 브랜드
  static const primary = Color(0xFF1F5BD8);
  static const primaryDark = Color(0xFF1546AD);
  static const primaryContainer = Color(0xFFDDE7FF);
  static const onPrimaryContainer = Color(0xFF0B2A6B);

  static const secondary = Color(0xFF00A3A3);
  static const secondaryContainer = Color(0xFFD3F4F2);
  static const onSecondaryContainer = Color(0xFF00403F);

  // 중립
  static const background = Color(0xFFF5F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEEF1F6);
  static const outline = Color(0xFFCBD2DE);
  static const outlineStrong = Color(0xFF8A94A6);

  static const textPrimary = Color(0xFF141A26);
  static const textSecondary = Color(0xFF4A5468);
  static const textDisabled = Color(0xFF9AA3B2);

  // 의미 색 (로봇 상태, 안내 배너)
  static const success = Color(0xFF1E8E4E);
  static const successContainer = Color(0xFFDDF4E6);
  static const warning = Color(0xFFB36B00);
  static const warningContainer = Color(0xFFFFEFD2);
  static const danger = Color(0xFFD32F2F);
  static const dangerContainer = Color(0xFFFDE2E1);
  static const info = primary;
  static const infoContainer = primaryContainer;

  static const scrim = Color(0x99141A26);
}
