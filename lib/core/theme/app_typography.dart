import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 글자 크기 체계.
///
/// 방문객이 태블릿에서 60cm~1m 떨어져 읽는 것을 기준으로 일반 앱보다 한 단계씩 크다.
/// 글꼴은 기기 기본(Android의 Noto Sans CJK KR)을 쓰고, 전용 글꼴을 넣을 때는
/// [fontFamily]만 바꾸면 된다.
abstract final class AppTypography {
  static const String? fontFamily = null;

  static const _height = 1.35;

  static TextTheme get textTheme =>
      const TextTheme(
        // 홈 화면 환영 문구, 도착 안내 등 가장 큰 글자
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.8,
        ),
        displaySmall: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        // 화면 제목
        headlineLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.6,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.3,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: -0.4,
        ),
        // 카드 제목, 섹션 제목
        titleLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: _height,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: _height,
          letterSpacing: -0.2,
        ),
        titleSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: _height,
        ),
        // 본문, 자막
        bodyLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        // 버튼, 칩
        labelLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        labelMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        labelSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ).apply(
        fontFamily: fontFamily,
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      );
}
