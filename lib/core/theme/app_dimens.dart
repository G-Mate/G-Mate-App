import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// 간격 (4dp 단위).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// 화면 가장자리 여백 (가로 10인치 태블릿 기준).
  static const double screenHorizontal = 48;
  static const double screenVertical = 32;
}

/// 모서리 둥글기.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;
  static const double full = 999;
}

/// 터치 대상과 아이콘 크기.
///
/// 키오스크는 허리 높이에서 서서 누르므로 버튼 최소 높이를 64dp로 잡는다.
abstract final class AppSize {
  static const double touchTargetMin = 64;
  static const double buttonLarge = 88;
  static const double buttonMedium = 64;
  static const double buttonSmall = 48; // 관리 모드 전용

  static const double iconSm = 24;
  static const double iconMd = 32;
  static const double iconLg = 48;
  static const double iconXl = 72;
}

/// 애니메이션 시간.
abstract final class AppDuration {
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 320);
}

/// 그림자. 테두리 대신 옅은 그림자로 면을 나눈다.
abstract final class AppShadow {
  static final soft = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static final raised = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];
}
