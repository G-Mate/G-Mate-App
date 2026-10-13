import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 화면 전체 바탕: 위에서 아래로 짙어지는 남색과 오른쪽 아래에 번지는 파랑 빛.
///
/// [GmScaffold]와 [GmSplitLayout]이 깔아 준다. 화면에서 직접 쓸 일은 거의 없다.
class GmBackground extends StatelessWidget {
  const GmBackground({super.key, required this.child});

  final Widget child;

  /// 오른쪽 아래 빛의 크기(화면 짧은 변 대비)와 진하기.
  static const _glowScale = 1.3;
  static const _glowAlpha = 0.42;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final glow = constraints.biggest.shortestSide * _glowScale;
          return Stack(
            children: [
              Positioned(
                right: -glow * 0.3,
                bottom: -glow * 0.45,
                width: glow,
                height: glow,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.glow.withValues(alpha: _glowAlpha),
                          AppColors.glow.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: child),
            ],
          );
        },
      ),
    );
  }
}
