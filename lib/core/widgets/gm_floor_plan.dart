import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../floor_plan/first_floor_layout.dart';
import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 학교 1층 평면도([FirstFloorLayout]). 목적지 방을 강조하고, 출발점(앞 장소,
/// 없으면 충전 위치)에서 복도를 따라 목적지까지의 경로를 그린다.
///
/// 장소 확인 화면의 미리보기([GmFloorPlanTour])와 이동 중 화면의 지도가 같은
/// 그림을 써서, 화면이 넘어갈 때 [heroTag]로 이어진다. 목적지가 배치도에 없는
/// 장소(관리 모드에서 새로 만든 장소 등)면 경로 없이 1층 전체만 보여 준다.
class GmFloorPlan extends StatelessWidget {
  const GmFloorPlan({
    super.key,
    required this.destination,
    this.destinationKey,
    this.fromKey,
    this.progress = 0,
    this.cameraFocus = 0,
    this.cameraZoom = 1,
    this.startLabel,
  });

  /// 두 화면의 평면도를 잇는 Hero 태그.
  static const heroTag = 'gm-floor-plan';

  /// 목적지 이름 (배치도에 없는 장소일 때는 쓰지 않는다).
  final String destination;

  /// 목적지 장소 키. 배치도의 방 키와 같으면 그 방까지 경로를 그린다.
  final String? destinationKey;

  /// 출발 장소 키. 없으면 충전 위치에서 출발한다.
  final String? fromKey;

  /// 로봇이 경로를 얼마나 왔는지 (0~1).
  final double progress;

  /// 카메라가 바라보는 경로 위 지점 (0 = 출발, 1 = 목적지).
  final double cameraFocus;

  /// 카메라 배율. 1이면 경로 둘레를 보여 준다.
  final double cameraZoom;

  /// 출발점 아래에 쓸 이름 (예: '현재 위치'). 없으면 쓰지 않는다.
  final String? startLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    final key = destinationKey;
    return CustomPaint(
      painter: _FloorPlanPainter(
        routePoints: key == null
            ? null
            : FirstFloorLayout.route(from: fromKey, to: key),
        destinationKey: key,
        progress: progress,
        focus: cameraFocus,
        zoom: cameraZoom,
        roomStyle: text.labelSmall?.copyWith(color: semantic.textSecondary),
        destinationStyle: text.titleSmall?.copyWith(color: colors.onSurface),
        startLabel: startLabel,
        startStyle: text.labelSmall?.copyWith(color: semantic.textSecondary),
        wall: semantic.textDisabled,
        room: colors.surfaceContainerHighest,
        route: colors.primary,
        destination: colors.onSurface,
      ),
    );
  }
}

class GmFloorPlanTour extends StatefulWidget {
  const GmFloorPlanTour({
    super.key,
    required this.destination,
    this.destinationKey,
    this.startLabel = '현재 위치',
  });

  final String destination;

  /// 목적지 장소 키 ([GmFloorPlan.destinationKey]).
  final String? destinationKey;
  final String startLabel;

  @override
  State<GmFloorPlanTour> createState() => GmFloorPlanTourState();
}

class GmFloorPlanTourState extends State<GmFloorPlanTour>
    with TickerProviderStateMixin {
  static const _period = Duration(seconds: 8);
  static const _settleDuration = Duration(milliseconds: 280);
  static const _closeZoom = 1.8;

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
            destinationKey: widget.destinationKey,
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
    required this.routePoints,
    required this.destinationKey,
    required this.progress,
    required this.focus,
    required this.zoom,
    required this.roomStyle,
    required this.destinationStyle,
    required this.startLabel,
    required this.startStyle,
    required this.wall,
    required this.room,
    required this.route,
    required this.destination,
  });

  /// 배치도 좌표의 경로. 목적지가 배치도에 없으면 null.
  final List<Offset>? routePoints;
  final String? destinationKey;
  final double progress;
  final double focus;
  final double zoom;
  final TextStyle? roomStyle;
  final TextStyle? destinationStyle;
  final String? startLabel;
  final TextStyle? startStyle;
  final Color wall;
  final Color room;
  final Color route;
  final Color destination;

  static const _routeWidth = 8.0;
  static const _labelGap = 18.0;

  /// 방 이름은 본문 작은 글자보다 더 줄여서 쓴다 (칸이 작아서).
  static const _roomLabelScale = 0.7;

  /// 경로 둘레로 남기는 여백 (배치도 좌표).
  static const _routeMargin = 60.0;

  /// 경로 둘레를 보여 줄 때 1층 전체 보기보다 최대 몇 배까지 키우는지.
  static const _maxRouteZoom = 1.8;

  /// 목적지 이름을 칸에 맞춰 줄일 때 가장 작은 배율.
  static const _minDestinationScale = 0.6;

  /// 건물 바깥 벽 두께 (배치도 좌표).
  static const _outline = 7.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final bounds = FirstFloorLayout.bounds.inflate(_outline * 2);
    final routeRoom = FirstFloorLayout.room(destinationKey);
    final routePath = routePoints;

    // 기본 보기: 경로와 목적지 방 둘레, 없으면 1층 전체.
    final fitAll = math.min(
      size.width / bounds.width,
      size.height / bounds.height,
    );
    var scale = fitAll;
    var viewCenter = bounds.center;
    if (routePath != null && routeRoom != null) {
      final frame = routePath
          .fold(routeRoom.rect, (r, p) => r.expandToInclude(p & Size.zero))
          .inflate(_routeMargin);
      scale = math
          .min(size.width / frame.width, size.height / frame.height)
          .clamp(fitAll, fitAll * _maxRouteZoom);
      // 보이는 칸이 배치도 밖으로 나가지 않게 가운데를 옮긴다.
      double clampAxis(double c, double half, double lo, double hi) =>
          hi - lo <= half * 2 ? (lo + hi) / 2 : c.clamp(lo + half, hi - half);
      viewCenter = Offset(
        clampAxis(
          frame.center.dx,
          size.width / scale / 2,
          bounds.left,
          bounds.right,
        ),
        clampAxis(
          frame.center.dy,
          size.height / scale / 2,
          bounds.top,
          bounds.bottom,
        ),
      );
    }
    final center = size.center(Offset.zero);
    Offset at(Offset p) => center + (p - viewCenter) * scale;
    Rect rectOf(Rect r) => Rect.fromPoints(at(r.topLeft), at(r.bottomRight));

    final path = routePath?.map(at).toList();

    // 카메라: 배율이 커질수록 화면 가운데에서 경로 위 [focus] 지점으로 옮겨 간다.
    final target = path == null ? center : _pointAlong(path, focus.clamp(0, 1));
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

    // 바깥 벽: 모든 칸을 조금 키워 겹쳐 그리면 건물 모양이 된다.
    final outline = Paint()..color = wall.withValues(alpha: 0.25);
    final floor = Paint()..color = room.withValues(alpha: 0.35);
    final r = Radius.circular(AppRadius.sm * scale / fitAll / 2);
    for (final rect in [
      for (final room in FirstFloorLayout.rooms) room.rect,
      ...FirstFloorLayout.corridors,
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rectOf(rect.inflate(_outline)), r),
        outline,
      );
    }
    for (final c in FirstFloorLayout.corridors) {
      canvas.drawRect(rectOf(c), floor);
    }

    final roomFill = Paint()..color = room;
    final serviceFill = Paint()..color = room.withValues(alpha: 0.55);
    final doorFill = Paint()..color = route.withValues(alpha: 0.18);
    final roomLine = Paint()
      ..color = wall.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final fr in FirstFloorLayout.rooms) {
      final rr = RRect.fromRectAndRadius(rectOf(fr.rect).deflate(1), r);
      canvas.drawRRect(rr, switch (fr.kind) {
        FloorRoomKind.room => roomFill,
        FloorRoomKind.service => serviceFill,
        FloorRoomKind.door => doorFill,
      });
      if (fr.kind == FloorRoomKind.room) canvas.drawRRect(rr, roomLine);
    }

    // 목적지 방은 테두리를 진하게.
    if (routeRoom != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rectOf(routeRoom.rect).deflate(1), r),
        Paint()
          ..color = destination
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }

    final robotAt = path == null
        ? at(FirstFloorLayout.homeBase)
        : _pointAlong(path, progress.clamp(0, 1));
    if (path != null) {
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
    }

    // 로봇(지금 위치): 옅은 원 + 흰 테두리 점.
    canvas
      ..drawCircle(robotAt, 26, Paint()..color = route.withValues(alpha: 0.18))
      ..drawCircle(robotAt, 13, Paint()..color = Colors.white)
      ..drawCircle(robotAt, 10, Paint()..color = route);

    canvas.restore();

    // 이름표는 카메라 배율을 따라 커지지 않게 변환을 푼 뒤에 쓴다.
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (final fr in FirstFloorLayout.rooms) {
      final box = rectOf(fr.rect);
      final width = box.width * zoom - 4;
      final height = box.height * zoom - 4;
      if (fr == routeRoom) {
        // 목적지 이름은 한 줄로 쓰고, 칸이 좁으면 칸 이름 줄바꿈대로 쓰고,
        // 그래도 넘치면 칸에 맞게 줄인다.
        var label = _label(_oneLine(fr.label), destinationStyle);
        if (label.width > width) label = _label(fr.label, destinationStyle);
        final fit = math.min(width / label.width, height / label.height);
        if (fit < 1) {
          label = _label(
            fr.label,
            destinationStyle,
            scale: math.max(fit, _minDestinationScale),
          );
        }
        label.paint(
          canvas,
          view(box.center) - Offset(label.width / 2, label.height / 2),
        );
        continue;
      }
      final label = _label(fr.label, roomStyle, scale: _roomLabelScale);
      // 칸보다 큰 이름은 쓰지 않는다.
      if (label.width > width || label.height > height) continue;
      label.paint(
        canvas,
        view(box.center) - Offset(label.width / 2, label.height / 2),
      );
    }
    final start = startLabel;
    if (start != null) {
      final label = TextPainter(
        text: TextSpan(text: start, style: startStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(
        canvas,
        view(path?.first ?? robotAt) +
            Offset(-label.width / 2, _labelGap + _routeWidth * zoom / 2),
      );
    }
    canvas.restore();
  }

  /// 줄바꿈을 지운 한 줄 이름. 영문 단어 사이는 띄어 쓴다 (Community Zone).
  static String _oneLine(String label) => label
      .replaceAllMapped(RegExp(r'([A-Za-z])\n'), (m) => '${m[1]} ')
      .replaceAll('\n', '');

  static TextPainter _label(
    String text,
    TextStyle? style, {
    double scale = 1,
  }) => TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.linear(scale),
  )..layout();

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
      old.destinationKey != destinationKey ||
      !listEquals(old.routePoints, routePoints) ||
      old.progress != progress ||
      old.focus != focus ||
      old.zoom != zoom ||
      old.roomStyle != roomStyle ||
      old.destinationStyle != destinationStyle ||
      old.startLabel != startLabel ||
      old.wall != wall ||
      old.room != room ||
      old.route != route ||
      old.destination != destination;
}
