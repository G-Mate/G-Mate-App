import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 지금 위치에서 목적지까지를 어림해 보여 주는 가는 선 평면도.
///
/// 교실 칸과 복도, 출발점(흰 고리)에서 목적지 칸(파랑 점)까지 이어지는 점선
/// 경로를 그리고, 두 점에 [startLabel]과 [destination] 이름을 단다.
/// 실제 temi 지도가 아니라 장소 확인 화면의 미리보기다.
class GmRoutePreview extends StatelessWidget {
  const GmRoutePreview({
    super.key,
    required this.destination,
    this.startLabel = '현재 위치',
  });

  final String destination;
  final String startLabel;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    TextPainter label(String text, Color color) => TextPainter(
      text: TextSpan(
        text: text,
        style: style?.copyWith(color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return CustomPaint(
      painter: _RoutePainter(
        start: label(startLabel, AppColors.onNavyMuted),
        end: label(destination, Colors.white),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  _RoutePainter({required this.start, required this.end});

  final TextPainter start;
  final TextPainter end;

  // 360×260 격자 기준
  static const _w = 360.0;
  static const _h = 260.0;
  static const _wallAlpha = 0.14;
  static const _targetAlpha = 0.4;
  static const _dash = 8.0;
  static const _gap = 7.0;
  static const _labelGap = 12.0;
  static const _labelInset = 6.0;

  static const _rooms = [
    Rect.fromLTRB(0, 0, 80, 88),
    Rect.fromLTRB(92, 0, 172, 88),
    Rect.fromLTRB(184, 0, 264, 88),
    Rect.fromLTRB(0, 188, 120, 260),
    Rect.fromLTRB(132, 188, 200, 260),
    Rect.fromLTRB(212, 188, 360, 260),
  ];
  static const _target = Rect.fromLTRB(276, 0, 360, 88);
  static const _route = [Offset(36, 130), Offset(318, 130), Offset(318, 88)];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _w;
    final sy = size.height / _h;
    Offset at(Offset p) => Offset(p.dx * sx, p.dy * sy);
    Rect box(Rect r) =>
        Rect.fromLTRB(r.left * sx, r.top * sy, r.right * sx, r.bottom * sy);

    final wall = Paint()
      ..color = Colors.white.withValues(alpha: _wallAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const radius = Radius.circular(AppRadius.sm);
    for (final r in _rooms) {
      canvas.drawRRect(RRect.fromRectAndRadius(box(r), radius), wall);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(box(_target), radius),
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(box(_target), radius),
      wall..color = Colors.white.withValues(alpha: _targetAlpha),
    );

    // 점선 경로
    final route = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < _route.length - 1; i++) {
      final a = at(_route[i]);
      final b = at(_route[i + 1]);
      final length = (b - a).distance;
      final dir = (b - a) / length;
      for (var d = 0.0; d < length; d += _dash + _gap) {
        final e = (d + _dash).clamp(0.0, length);
        canvas.drawLine(a + dir * d, a + dir * e, route);
      }
    }

    final from = at(_route.first);
    final to = at(_route.last);
    canvas.drawCircle(
      from,
      6,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(to, 7, Paint()..color = AppColors.primary);

    // 이름표: 출발점 아래, 목적지 칸 가운데
    start.paint(canvas, from + const Offset(-_labelInset, _labelGap));
    final targetCenter = box(_target).center;
    end.paint(canvas, targetCenter - Offset(end.width / 2, end.height / 2));
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.start.plainText != start.plainText ||
      old.end.plainText != end.plainText;
}
