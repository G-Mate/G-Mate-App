import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 층 지도 카드: 위에 층 이름과 범례, 아래에 지도.
///
/// 지금은 예시 평면도에 [progress]만큼 지나온 길과 로봇 위치를 그린다.
/// temi 지도 이미지와 로봇 위치를 받을 수 있게 되면 그 값으로 그린다.
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
    final semantic = context.appColors;

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
            // 이동 상태가 바뀔 때 로봇 점이 부드럽게 따라가도록.
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress),
              duration: _moveAnimation,
              curve: Curves.easeInOut,
              builder: (context, value, _) => CustomPaint(
                painter: _FloorMapPainter(
                  progress: value,
                  label: TextPainter(
                    text: TextSpan(
                      text: destination,
                      style: text.titleMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  )..layout(),
                  wall: semantic.textDisabled,
                  room: colors.surfaceContainerHighest,
                  route: colors.primary,
                  destination: colors.onSurface,
                ),
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

/// 예시 평면도. 복도 하나에 교실이 위아래로 붙어 있고, 로봇이 왼쪽에서
/// 오른쪽 끝 목적지로 가는 경로를 그린다. 좌표는 0~1 비율.
class _FloorMapPainter extends CustomPainter {
  _FloorMapPainter({
    required this.progress,
    required this.label,
    required this.wall,
    required this.room,
    required this.route,
    required this.destination,
  });

  final double progress;

  /// 목적지 교실 가운데에 쓸 이름.
  final TextPainter label;
  final Color wall;
  final Color room;
  final Color route;
  final Color destination;

  // 위쪽 줄, 아래쪽 줄 교실 (left, width). 마지막 위쪽 칸이 목적지.
  static const _top = [(0.0, 0.22), (0.24, 0.22), (0.48, 0.22), (0.72, 0.28)];
  static const _bottom = [(0.0, 0.3), (0.32, 0.2), (0.54, 0.46)];
  static const _corridorTop = 0.42;
  static const _corridorBottom = 0.58;
  static const _routeWidth = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(double x, double y) => Offset(x * size.width, y * size.height);
    Rect rect(double l, double t, double w, double h) => Rect.fromLTWH(
      l * size.width,
      t * size.height,
      w * size.width,
      h * size.height,
    );

    final roomFill = Paint()..color = room;
    final roomLine = Paint()
      ..color = wall.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const r = Radius.circular(AppRadius.sm);

    for (final (l, w) in _top) {
      final rr = RRect.fromRectAndRadius(rect(l, 0, w, _corridorTop - 0.02), r);
      canvas
        ..drawRRect(rr, roomFill)
        ..drawRRect(rr, roomLine);
    }
    for (final (l, w) in _bottom) {
      final rr = RRect.fromRectAndRadius(
        rect(l, _corridorBottom + 0.02, w, 1 - _corridorBottom - 0.02),
        r,
      );
      canvas
        ..drawRRect(rr, roomFill)
        ..drawRRect(rr, roomLine);
    }

    // 목적지 교실은 테두리를 진하게.
    final (dl, dw) = _top.last;
    final destRect = rect(dl, 0, dw, _corridorTop - 0.02);
    canvas.drawRRect(
      RRect.fromRectAndRadius(destRect, r),
      Paint()
        ..color = destination
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    label.paint(
      canvas,
      destRect.center - Offset(label.width / 2, label.height / 2),
    );

    // 경로: 복도 가운데를 따라 오른쪽으로 가서 목적지 문 앞까지.
    const midY = (_corridorTop + _corridorBottom) / 2;
    final path = [
      at(0.12, midY),
      at(0.86, midY),
      at(0.86, _corridorTop - 0.02),
    ];
    final robotAt = _pointAlong(path, progress.clamp(0, 1));

    final done = Paint()
      ..color = route.withValues(alpha: 0.25)
      ..strokeWidth = _routeWidth
      ..strokeCap = StrokeCap.round;
    final todo = Paint()
      ..color = route
      ..strokeWidth = _routeWidth
      ..strokeCap = StrokeCap.round;
    _drawSplit(canvas, path, robotAt, done, todo);

    // 목적지 점.
    final door = path.last;
    canvas
      ..drawCircle(door, 14, Paint()..color = destination)
      ..drawCircle(door, 5, Paint()..color = room);

    // 로봇(지금 위치): 옅은 원 + 흰 테두리 점.
    canvas
      ..drawCircle(robotAt, 26, Paint()..color = route.withValues(alpha: 0.18))
      ..drawCircle(robotAt, 13, Paint()..color = Colors.white)
      ..drawCircle(robotAt, 10, Paint()..color = route);
  }

  /// 꺾인 선 [path]에서 길이 비율 [t] 지점.
  static Offset _pointAlong(List<Offset> path, double t) {
    final lengths = [
      for (var i = 1; i < path.length; i++) (path[i] - path[i - 1]).distance,
    ];
    var remain = lengths.fold<double>(0, (a, b) => a + b) * t;
    for (var i = 0; i < lengths.length; i++) {
      if (remain <= lengths[i]) {
        return Offset.lerp(path[i], path[i + 1], remain / lengths[i])!;
      }
      remain -= lengths[i];
    }
    return path.last;
  }

  /// 로봇 위치 [split]를 기준으로 지나온 길은 [done], 남은 길은 [todo]로 그린다.
  static void _drawSplit(
    Canvas canvas,
    List<Offset> path,
    Offset split,
    Paint done,
    Paint todo,
  ) {
    var passed = true;
    for (var i = 1; i < path.length; i++) {
      final a = path[i - 1];
      final b = path[i];
      if (passed && _isOnSegment(split, a, b)) {
        canvas
          ..drawLine(a, split, done)
          ..drawLine(split, b, todo);
        passed = false;
      } else {
        canvas.drawLine(a, b, passed ? done : todo);
      }
    }
  }

  static bool _isOnSegment(Offset p, Offset a, Offset b) =>
      ((p - a).distance + (b - p).distance - (b - a).distance).abs() < 0.5;

  @override
  bool shouldRepaint(_FloorMapPainter old) =>
      old.progress != progress ||
      old.label.text != label.text ||
      old.wall != wall ||
      old.room != room ||
      old.route != route ||
      old.destination != destination;
}
