import 'package:flutter/material.dart';

/// G-Mate 색 팔레트 (어두운 남색 테마).
///
/// 화면 전체를 짙은 남색 바탕으로 깔고, 그 위에 한 단계 밝은 남색 카드와
/// 밝은 파랑(페리윙클) 강조 하나를 올린다. 글자는 흰색 계열이다.
///
/// 화면에서는 이 값을 직접 쓰지 말고 `Theme.of(context).colorScheme` 또는
/// `context.appColors`(의미 색)를 통해 꺼내 쓴다.
abstract final class AppColors {
  // 바탕: 위에서 아래로 짙어지는 남색 그라데이션과 오른쪽 아래의 파랑 빛.
  static const backgroundTop = Color(0xFF1C2A70);
  static const backgroundBottom = Color(0xFF0E1640);
  static const glow = Color(0xFF3D5BFF);

  /// 학교 로고(#003366)에서 가져온 짙은 남색. 왼쪽 패널을 바탕보다 한 톤
  /// 어둡게 깔 때 쓴다.
  static const navy = Color(0xFF0B1235);
  static const navyLight = Color(0xFF26337C);

  /// 남색 면 위의 보조 글자색.
  static const onNavyMuted = Color(0xFFA3AEDB);

  /// 강조 파랑. 선택된 카드, 주 버튼.
  static const primary = Color(0xFF5C6CFA);
  static const primaryDark = Color(0xFF4655E0);
  static const primaryContainer = Color(0xFF2E3B8C);
  static const onPrimaryContainer = Color(0xFFDDE2FF);

  static const secondary = primary;
  static const secondaryContainer = primaryContainer;
  static const onSecondaryContainer = onPrimaryContainer;

  // 면
  static const background = backgroundBottom;

  /// 카드 면 (바탕보다 한 단계 밝은 남색).
  static const surface = Color(0xFF232F72);
  static const surfaceVariant = Color(0xFF2B3880);
  static const outline = Color(0xFF34418A);

  /// 바탕의 빛이 비치는 반투명 유리 면 (카드, 칩, 입력 칸)과 그 테두리.
  static const glass = Color(0x14FFFFFF);
  static const glassBorder = Color(0x1FFFFFFF);
  static const outlineStrong = Color(0xFF5562A8);

  static const textPrimary = Color(0xFFF4F6FF);
  static const textSecondary = Color(0xFFA3AEDB);
  static const textDisabled = Color(0xFF6874AD);

  // 의미 색 (로봇 상태, 안내 배너)
  static const success = Color(0xFF8BDC5E);
  static const successContainer = Color(0xFF263F3A);
  static const warning = Color(0xFFFFB648);
  static const warningContainer = Color(0xFF453A3A);
  static const danger = Color(0xFFFF5D6E);
  static const dangerContainer = Color(0xFF4A2A48);
  static const info = primary;
  static const infoContainer = primaryContainer;

  static const scrim = Color(0xCC070B22);

  /// 떠 있는 요소의 그림자.
  static const shadow = Color(0xFF050920);
}
