import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 화면 한쪽을 채우는 남색 패널. 홈(대기), 도착 안내처럼 화면의 주제를
/// 크게 보여 줄 때 쓴다.
///
/// 위에서부터 작은 머리말 → 큰 제목 → 부제, 맨 아래에 [footer]를 둔다.
class GmHeroPanel extends StatelessWidget {
  const GmHeroPanel({
    super.key,
    required this.title,
    this.overline,
    this.subtitle,
    this.footer,
    this.top,
    this.showFloorPlan = true,
  });

  final String title;

  /// 제목 위 작은 글자 (예: 학교 이름).
  final String? overline;
  final String? subtitle;

  /// 패널 맨 아래에 둘 위젯 (예: 로봇 상태 표시).
  final Widget? footer;

  /// 패널 맨 위에 둘 위젯. 없으면 G-MATE 글자를 보여 준다
  /// (예: [GmHeroBackButton]).
  final Widget? top;

  /// false면 오른쪽 위 평면도 장식을 그리지 않는다.
  final bool showFloorPlan;

  static const _planTop = 84.0;
  static const _planWidth = 270.0;
  static const _planHeight = 195.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.navy),
      child: Stack(
        children: [
          // 장식은 오른쪽 위의 가는 선 평면도 하나뿐이다 (길 안내 로봇이라는 주제).
          if (showFloorPlan)
            const Positioned(
              top: _planTop,
              right: AppSpacing.xxl,
              width: _planWidth,
              height: _planHeight,
              child: IgnorePointer(
                child: CustomPaint(painter: _FloorPlanPainter()),
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  top ??
                      Text(
                        'G-MATE',
                        style: text.labelSmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                  const Spacer(),
                  if (overline != null) ...[
                    Text(
                      overline!,
                      style: text.bodySmall?.copyWith(
                        color: AppColors.onNavyMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Text(
                    title,
                    style: text.displaySmall?.copyWith(color: Colors.white),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      subtitle!,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.onNavyMuted,
                      ),
                    ),
                  ],
                  const Spacer(),
                  ?footer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 남색 패널 오른쪽 위에 깔리는 가는 선 평면도. 교실 칸과 복도, 목적지까지
/// 이어지는 점선 경로를 그린다. 360×260 격자 기준.
class _FloorPlanPainter extends CustomPainter {
  const _FloorPlanPainter();

  static const _w = 360.0;
  static const _h = 260.0;
  static const _wallAlpha = 0.12;
  static const _targetAlpha = 0.32;
  static const _dash = 8.0;
  static const _gap = 7.0;

  static const _rooms = [
    Rect.fromLTRB(0, 0, 80, 96),
    Rect.fromLTRB(92, 0, 172, 96),
    Rect.fromLTRB(184, 0, 264, 96),
    Rect.fromLTRB(0, 164, 120, 260),
    Rect.fromLTRB(132, 164, 200, 260),
    Rect.fromLTRB(212, 164, 360, 260),
  ];
  static const _target = Rect.fromLTRB(276, 0, 360, 96);
  static const _route = [Offset(36, 130), Offset(318, 130), Offset(318, 96)];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _w, size.height / _h);

    final wall = Paint()
      ..color = Colors.white.withValues(alpha: _wallAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const radius = Radius.circular(AppRadius.sm);
    for (final r in _rooms) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, radius), wall);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(_target, radius),
      wall..color = Colors.white.withValues(alpha: _targetAlpha),
    );

    // 점선 경로
    final route = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < _route.length - 1; i++) {
      final a = _route[i];
      final b = _route[i + 1];
      final length = (b - a).distance;
      final dir = (b - a) / length;
      for (var d = 0.0; d < length; d += _dash + _gap) {
        final end = (d + _dash).clamp(0.0, length);
        canvas.drawLine(a + dir * d, a + dir * end, route);
      }
    }
    // 출발점(흰 고리)과 목적지(파랑 점)
    canvas.drawCircle(
      _route.first,
      6,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(_route.last, 7, Paint()..color = AppColors.primary);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FloorPlanPainter oldDelegate) => false;
}

/// 남색 패널 위에 두는 뒤로 가기 버튼 (흰 아이콘 + 글자).
class GmHeroBackButton extends StatelessWidget {
  const GmHeroBackButton({super.key, required this.onPressed, this.label});

  final VoidCallback onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: AppSize.iconMd),
      label: Text(label ?? '뒤로'),
    );
  }
}

/// 왼쪽 남색 패널 + 오른쪽 본문으로 나뉜 화면 틀.
///
/// 홈, 장소 확인, 도착 화면처럼 화면의 주제를 크게 보여 줄 때 쓴다.
class GmSplitLayout extends StatelessWidget {
  const GmSplitLayout({
    super.key,
    required this.hero,
    required this.child,
    this.heroFlex = 5,
    this.childFlex = 7,
  });

  final Widget hero;
  final Widget child;
  final int heroFlex;
  final int childFlex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: heroFlex, child: hero),
          Expanded(
            flex: childFlex,
            child: SafeArea(
              left: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
