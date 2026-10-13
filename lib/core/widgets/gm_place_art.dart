import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import 'gm_icon.dart';

/// 장소 사진이 없을 때 사진 자리를 채우는 그림.
///
/// 장소 아이콘을 칸보다 크게 키워 옅게 깔고, 왼쪽 아래 모서리 밖으로 살짝
/// 넘쳐 잘리게 둔다. 바탕은 위에서 아래로 아주 옅게 밝아지는 남색이다.
class GmPlaceArt extends StatelessWidget {
  const GmPlaceArt({super.key, required this.icon});

  final GmIcons icon;

  /// 칸 높이 대비 아이콘 크기와, 왼쪽·아래로 넘치는 정도.
  static const _iconScale = 0.9;
  static const _overflowLeft = 0.06;
  static const _overflowBottom = 0.12;
  static const _iconAlpha = 0.09;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxHeight * _iconScale;
        return ClipRect(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colors.surfaceContainerHighest,
                  Color.alphaBlend(
                    colors.primary.withValues(alpha: 0.12),
                    colors.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -size * _overflowLeft,
                  bottom: -size * _overflowBottom,
                  child: GmIcon(
                    icon,
                    size: size,
                    color: colors.onSurface.withValues(alpha: _iconAlpha),
                    fillOpacity: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
