import 'package:flutter/material.dart';

/// G-Mate 색 팔레트.
///
/// 화면에서는 이 값을 직접 쓰지 말고 `Theme.of(context).colorScheme` 또는
/// `context.appColors`(의미 색)를 통해 꺼내 쓴다.
abstract final class AppColors {
  // 브랜드: 남색 면 하나와 파랑 포인트 하나만 쓴다.
  /// 학교 로고(#003366)에서 가져온 짙은 남색. 화면의 큰 면(히어로 패널)에 쓴다.
  static const navy = Color(0xFF13213F);
  static const navyLight = Color(0xFF1C2F57);

  /// 남색 면 위의 보조 글자색.
  static const onNavyMuted = Color(0xFF9DAACB);

  static const primary = Color(0xFF3360E0);
  static const primaryDark = Color(0xFF274CB8);
  static const primaryContainer = Color(0xFFEBF0FD);
  static const onPrimaryContainer = Color(0xFF1B3577);

  static const secondary = primary;
  static const secondaryContainer = primaryContainer;
  static const onSecondaryContainer = onPrimaryContainer;

  // 중립
  static const background = Color(0xFFF4F5F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0F2F6);
  static const outline = Color(0xFFE4E7EC);
  static const outlineStrong = Color(0xFFB4BAC6);

  static const textPrimary = Color(0xFF161C2B);
  static const textSecondary = Color(0xFF6A7182);
  static const textDisabled = Color(0xFFADB3BF);

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
