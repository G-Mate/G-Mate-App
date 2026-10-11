import 'package:flutter/material.dart';

/// G-Mate 색 팔레트.
///
/// 화면에서는 이 값을 직접 쓰지 말고 `Theme.of(context).colorScheme` 또는
/// `context.appColors`(의미 색)를 통해 꺼내 쓴다.
abstract final class AppColors {
  // 브랜드: 학교 로고의 남색(#003366)을 바탕으로 더 맑게 고른 파랑 계열
  /// 로고 느낌의 짙은 남색. 브랜드 글자, 강조 면에 쓴다.
  static const navy = Color(0xFF0B2A5B);

  static const primary = Color(0xFF2257D6);
  static const primaryDark = Color(0xFF1A44AD);
  static const primaryContainer = Color(0xFFE6EDFB);
  static const onPrimaryContainer = navy;

  // 보조: 밝은 파랑 (투어 등 두 번째 메뉴 강조)
  static const secondary = Color(0xFF3D8FE6);
  static const secondaryContainer = Color(0xFFE3F0FC);
  static const onSecondaryContainer = Color(0xFF0C3F75);

  // 중립: 푸른빛이 살짝 도는 회색
  static const background = Color(0xFFF3F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEAF0F8);
  static const outline = Color(0xFFDDE4EE);
  static const outlineStrong = Color(0xFF94A3B8);

  static const textPrimary = Color(0xFF0E1B33);
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
  static const shadow = navy;
}
