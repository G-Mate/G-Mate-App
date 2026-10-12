import 'package:flutter/material.dart';

/// G-Mate 색 팔레트.
///
/// 화면에서는 이 값을 직접 쓰지 말고 `Theme.of(context).colorScheme` 또는
/// `context.appColors`(의미 색)를 통해 꺼내 쓴다.
abstract final class AppColors {
  // 브랜드: 선명한 파랑 하나를 포인트로 쓰고 나머지는 차분한 회색으로 둔다.
  // 학교 로고의 남색(#003366)은 [navy]로 남겨 진한 글자·면에 쓴다.
  static const navy = Color(0xFF14254A);

  static const primary = Color(0xFF3B5BDB);
  static const primaryDark = Color(0xFF2F4AC0);
  static const primaryContainer = Color(0xFFE8EDFD);
  static const onPrimaryContainer = Color(0xFF1C2F80);

  static const secondary = Color(0xFF6E8BF0);
  static const secondaryContainer = Color(0xFFEEF2FE);
  static const onSecondaryContainer = Color(0xFF23367F);

  // 중립: 푸른빛이 아주 옅게 도는 회색
  static const background = Color(0xFFEEF1F6);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF4F6FA);
  static const outline = Color(0xFFE2E6ED);
  static const outlineStrong = Color(0xFFA9B0BF);

  static const textPrimary = Color(0xFF2A3142);
  static const textSecondary = Color(0xFF6B7489);
  static const textDisabled = Color(0xFFA9B0BF);

  /// 배경에 크게 깔아 두는 장식 글자(워터마크) 색.
  static const watermark = Color(0xFFE3E8F1);

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
