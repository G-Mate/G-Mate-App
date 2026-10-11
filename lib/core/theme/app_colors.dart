import 'package:flutter/material.dart';

/// G-Mate 색 팔레트.
///
/// 화면에서는 이 값을 직접 쓰지 말고 `Theme.of(context).colorScheme` 또는
/// `context.appColors`(의미 색)를 통해 꺼내 쓴다.
abstract final class AppColors {
  // 브랜드: 파랑 계열
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryContainer = Color(0xFFE6EEFF);
  static const onPrimaryContainer = Color(0xFF1E3A8A);

  // 보조: 하늘색 (투어 등 두 번째 메뉴 강조)
  static const secondary = Color(0xFF0EA5E9);
  static const secondaryContainer = Color(0xFFE0F4FE);
  static const onSecondaryContainer = Color(0xFF075985);

  // 중립: 푸른빛이 살짝 도는 회색
  static const background = Color(0xFFF3F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEAF0F8);
  static const outline = Color(0xFFDDE4EE);
  static const outlineStrong = Color(0xFF94A3B8);

  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textDisabled = Color(0xFF94A3B8);

  // 의미 색 (로봇 상태, 안내 배너)
  static const success = Color(0xFF16A34A);
  static const successContainer = Color(0xFFE3F7EA);
  static const warning = Color(0xFFD97706);
  static const warningContainer = Color(0xFFFEF3E2);
  static const danger = Color(0xFFDC2626);
  static const dangerContainer = Color(0xFFFDE8E8);
  static const info = primary;
  static const infoContainer = primaryContainer;

  static const scrim = Color(0x990F172A);

  /// 카드 그림자 (파랑빛 회색).
  static const shadow = Color(0xFF1E3A8A);
}
