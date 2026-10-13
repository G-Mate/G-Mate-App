import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 층 지도 카드: 위에 층 이름과 범례, 아래에 지도.
///
/// 지금은 예시 평면도([GmFloorPlan])에 [progress]만큼 지나온 길과 로봇 위치를
/// 그린다. 장소 확인 화면의 미리보기에서 Hero로 이어진다. temi 지도 이미지와
/// 로봇 위치를 받을 수 있게 되면 그 값으로 그린다.
class FloorMap extends StatelessWidget {
  const FloorMap({
    super.key,
    required this.floor,
    required this.destination,
    required this.progress,
  });

  final int floor;
  final String destination;

  /// 경로를 얼마나 왔는지 (0~1).
  final double progress;

  static const _legendDotSize = 12.0;

  /// 로봇 점이 다음 위치로 옮겨 가는 시간.
  static const _moveAnimation = Duration(milliseconds: 800);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('$floor층', style: text.titleLarge)),
              _Legend(color: colors.primary, label: '지금 위치'),
              const SizedBox(width: AppSpacing.lg),
              _Legend(color: colors.onSurface, label: destination),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Hero(
              tag: GmFloorPlan.heroTag,
              // 이동 상태가 바뀔 때 로봇 점이 부드럽게 따라가도록.
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: progress),
                duration: _moveAnimation,
                curve: Curves.easeInOut,
                builder: (context, value, _) =>
                    GmFloorPlan(destination: destination, progress: value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: FloorMap._legendDotSize,
          height: FloorMap._legendDotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
