import 'dart:math' as math;

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

  /// 머리줄(층 이름, 범례) 높이.
  static const _headerExtent = 40.0;

  @override
  Widget build(BuildContext context) {
    // 카드 전체가 Hero다. 장소 확인의 평면도 미리보기에서 카드 바탕이 차오르며
    // 이 자리까지 커진다([_flight]).
    return Hero(
      tag: GmFloorPlan.heroTag,
      flightShuttleBuilder: _flight,
      child: _card(
        context,
        reveal: 1,
        // 이동 상태가 바뀔 때 로봇 점이 부드럽게 따라가도록.
        plan: TweenAnimationBuilder<double>(
          tween: Tween(end: progress),
          duration: _moveAnimation,
          curve: Curves.easeInOut,
          builder: (context, value, _) =>
              GmFloorPlan(destination: destination, progress: value),
        ),
      ),
    );
  }

  /// [reveal]이 0이면 바탕·여백·머리줄 없이 평면도만, 1이면 완성된 카드.
  Widget _card(
    BuildContext context, {
    required double reveal,
    required Widget plan,
  }) {
    final colors = context.colors;
    final text = context.textStyles;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg * reveal),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: colors.surface.a * reveal),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _headerExtent * reveal,
            child: Opacity(
              opacity: reveal,
              // 칸이 좁을 때(날아오는 중)는 머리줄을 줄여서 그린다.
              child: LayoutBuilder(
                builder: (context, constraints) => FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: math.max(constraints.maxWidth, _headerMinWidth),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('$floor층', style: text.titleLarge),
                        ),
                        _Legend(color: colors.primary, label: '지금 위치'),
                        const SizedBox(width: AppSpacing.lg),
                        _Legend(color: colors.onSurface, label: destination),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md * reveal),
          Expanded(child: plan),
        ],
      ),
    );
  }

  /// 머리줄을 이보다 좁게는 그리지 않고 줄여서 맞춘다.
  static const _headerMinWidth = 560.0;

  Widget _flight(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) => _card(
        context,
        reveal: curved.value,
        plan: GmFloorPlan(destination: destination, progress: progress),
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
