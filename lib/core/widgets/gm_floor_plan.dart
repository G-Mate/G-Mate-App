import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 예시 층 평면도. 복도 하나에 교실이 위아래로 붙어 있고, 지금 위치(왼쪽)에서
/// 오른쪽 끝 목적지 교실까지의 경로를 그린다.
///
/// 장소 확인 화면의 미리보기([GmFloorPlanTour])와 이동 중 화면의 지도가 같은
/// 그림을 써서, 화면이 넘어갈 때 [heroTag]로 이어진다. 실제 temi 지도가 생기면
/// 이 그림을 바꾼다.
class GmFloorPlan extends StatelessWidget {
  const GmFloorPlan({
    super.key,
    required this.destination,
    this.progress = 0,
    this.cameraFocus = 0,
    this.cameraZoom = 1,
    this.startLabel,
  });

  /// 두 화면의 평면도를 잇는 Hero 태그.
  static const heroTag = 'gm-floor-plan';

  /// 목적지 교실 가운데에 쓸 이름.
  final String destination;

  /// 로봇이 경로를 얼마나 왔는지 (0~1).
  final double progress;

  /// 카메라가 바라보는 경로 위 지점 (0 = 출발, 1 = 목적지).
  final double cameraFocus;

  /// 카메라 배율. 1이면 평면도 전체를 보여 준다.
  final double cameraZoom;

  /// 출발점 아래에 쓸 이름 (예: '현재 위치'). 없으면 쓰지 않는다.
  final String? startLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    TextPainter label(String s, TextStyle? style) => TextPainter(
      text: TextSpan(text: s, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    return CustomPaint(
      painter: _FloorPlanPainter(
        progress: progress,
        focus: cameraFocus,
        zoom: cameraZoom,
        destinationLabel: label(
          destination,
          text.titleSmall?.copyWith(color: colors.onSurface),
        ),
        startLabel: startLabel == null
            ? null
            : label(
                startLabel!,
                text.labelSmall?.copyWith(color: semantic.textSecondary),
              ),
        wall: semantic.textDisabled,
        room: colors.surfaceContainerHighest,
        route: colors.primary,
        destination: colors.onSurface,
      ),
    );
  }
}

/// 장소 확인 화면의 평면도 미리보기. 전체 → 지금 위치로 다가가기 → 경로를
/// 따라 목적지까지 → 전체로 물러나기를 부드럽게 되풀이한다.
class GmFloorPlanTour extends StatefulWidget {
  const GmFloorPlanTour({
    super.key,
    required this.destination,
    this.startLabel = '현재 위치',
  });

  final String destination;
  final String startLabel;

  @override
  State<GmFloorPlanTour> createState() => GmFloorPlanTourState();
}

class GmFloorPlanTourState extends State<GmFloorPlanTour>
    with TickerProviderStateMixin {
  static const _period = Duration(seconds: 8);
  static const _settleDuration = Duration(milliseconds: 280);
  static const _closeZoom = 2.2;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period,
  )..repeat();

  /// [settle]에서 전체 보기로 물러나는 진행 (0 = 돌던 자리, 1 = 전체).
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: _settleDuration,
  );

  // 한 바퀴 안의 구간 (0~1).
  static const _zoomInEnd = 0.15;
  static const _holdStartEnd = 0.25;
  static const _followEnd = 0.65;
  static const _holdEndEnd = 0.8;

  @override
  void dispose() {
    _controller.dispose();
    _settle.dispose();
    super.dispose();
  }

  /// 되풀이를 멈추고 전체 보기로 부드럽게 물러나며 가장자리 흐림을 걷는다.
  /// 다음 화면 지도로 이어지기(Hero) 전에 부른다.
  Future<void> settle() async {
    _controller.stop();
    await _settle.animateTo(1, curve: Curves.easeOutCubic);
  }

  (double focus, double zoom) _camera(double t) {
    double ease(double a, double b) =>
        Curves.easeInOut.transform(((t - a) / (b - a)).clamp(0.0, 1.0));
    if (t < _zoomInEnd) {
      return (0, 1 + (_closeZoom - 1) * ease(0, _zoomInEnd));
    }
    if (t < _holdStartEnd) return (0, _closeZoom);
    if (t < _followEnd) return (ease(_holdStartEnd, _followEnd), _closeZoom);
    if (t < _holdEndEnd) return (1, _closeZoom);
    return (1, _closeZoom - (_closeZoom - 1) * ease(_holdEndEnd, 1));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _settle]),
      builder: (context, _) {
        final (focus, zoom) = _camera(_controller.value);
        // 가장자리 흐림도 물러나면서 걷혀, 날아갈 때는 깔끔한 평면도가 된다.
        return GmFloorPlanFade(
          strength: 1 - _settle.value,
          child: GmFloorPlan(
            destination: widget.destination,
            cameraFocus: focus,
            cameraZoom: zoom + (1 - zoom) * _settle.value,
            startLabel: widget.startLabel,
          ),
        );
      },
    );
  }
}

/// 가장자리가 흐려지며 바탕에 녹아드는 평면도 (장소 확인 미리보기).
///
/// [strength]가 0이면 흐림 없이 그대로 보여 준다.
class GmFloorPlanFade extends StatelessWidget {
  const GmFloorPlanFade({super.key, required this.child, this.strength = 1});

  final Widget child;
  final double strength;

  static const _solidRadius = 0.35;

  @override
  Widget build(BuildContext context) {
    if (strength <= 0) return child;
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => RadialGradient(
        radius: 0.68,
        colors: [
          Colors.white,
          Colors.white,
          Colors.white.withValues(alpha: 1 - strength),
        ],
        stops: const [0, _solidRadius, 1],
      ).createShader(rect),
      child: child,
    );
  }
}

class _FloorPlanPainter extends CustomPainter {
  _FloorPlanPainter({
    required this.progress,
    required this.focus,
    required this.zoom,
    required this.destinationLabel,
    required this.startLabel,
    required this.wall,
    required this.room,
    required this.route,
    required this.destination,
  });

  final double progress;
  final double focus;
  final double zoom;
  final TextPainter destinationLabel;
  final TextPainter? startLabel;
  final Color wall;
  final Color room;
  final Color route;
  final Color destination;

  // 위쪽 줄, 아래쪽 줄 교실 (left, width). 마지막 위쪽 칸이 목적지. 0~1 비율.
  static const _top = [(0.0, 0.22), (0.24, 0.22), (0.48, 0.22), (0.72, 0.28)];
  static const _bottom = [(0.0, 0.3), (0.32, 0.2), (0.54, 0.46)];
  static const _corridorTop = 0.42;
  static const _corridorBottom = 0.58;
  static const _routeWidth = 8.0;
  static const _labelGap = 18.0;

  /// 평면도 가로:세로 비율.
  static const _aspect = 1.25;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    // 평면도는 정해진 비율로 칸 안에 맞춰 넣는다 (칸 모양에 따라 늘어나지 않게).
    final plan = _fit(size);
    Offset at(double x, double y) =>
        plan.topLeft + Offset(x * plan.width, y * plan.height);
    Rect rect(double l, double t, double w, double h) => Rect.fromLTWH(
      plan.left + l * plan.width,
      plan.top + t * plan.height,
      w * plan.width,
      h * plan.height,
    );

    const midY = (_corridorTop + _corridorBottom) / 2;
    final path = [
      at(0.12, midY),
      at(0.86, midY),
      at(0.86, _corridorTop - 0.02),
    ];

    // 카메라: 배율이 커질수록 화면 가운데에서 경로 위 [focus] 지점으로 옮겨 간다.
    final center = size.center(Offset.zero);
    final target = _pointAlong(path, focus.clamp(0, 1));
    final f = Offset.lerp(center, target, math.min(1.0, (zoom - 1) / 1.2))!;

    /// 카메라를 거친 화면 위 위치 (글자는 배율과 상관없이 같은 크기로 쓴다).
    Offset view(Offset p) => center + (p - f) * zoom;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    if (zoom > 1) {
      canvas
        ..translate(center.dx, center.dy)
        ..scale(zoom)
        ..translate(-f.dx, -f.dy);
    }

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

    canvas.restore();

    // 이름표는 카메라 배율을 따라 커지지 않게 변환을 푼 뒤에 쓴다.
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final destCenter = view(destRect.center);
    destinationLabel.paint(
      canvas,
      destCenter -
          Offset(destinationLabel.width / 2, destinationLabel.height / 2),
    );
    final start = startLabel;
    if (start != null) {
      start.paint(
        canvas,
        view(path.first) +
            Offset(-start.width / 2, _labelGap + _routeWidth * zoom / 2),
      );
    }
    canvas.restore();
  }

  /// 가로세로 [_aspect] 비율의 평면도를 [size] 안 가운데에 맞춘 칸.
  static Rect _fit(Size size) {
    final byWidth = size.width / _aspect;
    final w = byWidth <= size.height ? size.width : size.height * _aspect;
    final h = w / _aspect;
    return Rect.fromCenter(
      center: size.center(Offset.zero),
      width: w,
      height: h,
    );
  }

  /// 꺾인 선 [path]에서 길이 비율 [t] 지점.
  static Offset _pointAlong(List<Offset> path, double t) {
    final lengths = [
      for (var i = 1; i < path.length; i++) (path[i] - path[i - 1]).distance,
    ];
    var remain = lengths.fold<double>(0, (a, b) => a + b) * t;
    for (var i = 0; i < lengths.length; i++) {
      if (lengths[i] > 0 && remain <= lengths[i]) {
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
  bool shouldRepaint(_FloorPlanPainter old) =>
      old.progress != progress ||
      old.focus != focus ||
      old.zoom != zoom ||
      old.destinationLabel.text != destinationLabel.text ||
      old.startLabel?.text != startLabel?.text ||
      old.wall != wall ||
      old.room != room ||
      old.route != route ||
      old.destination != destination;
}
