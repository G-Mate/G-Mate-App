import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 글자 크기 체계.
///
/// 방문객이 태블릿에서 60cm~1m 떨어져 읽는 것을 기준으로 일반 앱보다 한 단계씩 크다.
/// 글꼴은 Pretendard(assets/fonts/pretendard)를 쓰고, 큰 글자일수록 자간을 좁혀
/// 단단한 인상을 준다.
abstract final class AppTypography {
  static const String fontFamily = 'Pretendard';

  /// 글자 크기에 비례한 자간. Pretendard는 큰 글자에서 -2~-3%가 자연스럽다.
  static double _tracking(double size, double ratio) => size * ratio;

  static TextStyle _style(
    double size,
    FontWeight weight, {
    double height = 1.4,
    double tracking = -0.01,
  }) => TextStyle(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: _tracking(size, tracking),
  );

  static TextTheme get textTheme =>
      TextTheme(
        // 인사말, 도착 안내 등 가장 큰 글자
        displayLarge: _style(
          64,
          FontWeight.w800,
          height: 1.15,
          tracking: -0.03,
        ),
        displayMedium: _style(
          56,
          FontWeight.w800,
          height: 1.15,
          tracking: -0.03,
        ),
        displaySmall: _style(48, FontWeight.w700, height: 1.2, tracking: -0.03),
        // 화면 제목, 메뉴 카드 제목
        headlineLarge: _style(
          40,
          FontWeight.w700,
          height: 1.25,
          tracking: -0.025,
        ),
        headlineMedium: _style(
          34,
          FontWeight.w700,
          height: 1.3,
          tracking: -0.02,
        ),
        headlineSmall: _style(
          30,
          FontWeight.w600,
          height: 1.3,
          tracking: -0.02,
        ),
        // 카드 제목, 섹션 제목
        titleLarge: _style(28, FontWeight.w600, height: 1.35, tracking: -0.015),
        titleMedium: _style(24, FontWeight.w600, height: 1.35, tracking: -0.01),
        titleSmall: _style(20, FontWeight.w600, height: 1.35, tracking: -0.01),
        // 본문, 자막
        bodyLarge: _style(26, FontWeight.w400, height: 1.55),
        bodyMedium: _style(22, FontWeight.w400, height: 1.55),
        bodySmall: _style(18, FontWeight.w400, height: 1.5, tracking: 0),
        // 버튼, 칩
        labelLarge: _style(26, FontWeight.w600, height: 1.2),
        labelMedium: _style(22, FontWeight.w600, height: 1.2),
        labelSmall: _style(18, FontWeight.w600, height: 1.2, tracking: 0),
      ).apply(
        fontFamily: fontFamily,
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      );
}
