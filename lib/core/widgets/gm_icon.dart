import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// G-Mate 전용 아이콘. 모서리가 둥근 선과 옅게 깐 면(두 톤)으로 그린다.
///
/// 모든 아이콘은 24×24 격자 위에 그리고 [GmIcon.size]에 맞춰 늘린다.
enum GmIcons {
  /// 길 찾기 (종이비행기 모양 화살표)
  navigate,

  /// 학교 투어 (깃발)
  tour,

  /// 과학실 (플라스크)
  science,

  /// 컴퓨터실 (모니터)
  computer,

  /// 교무실 (사원증)
  teacher,

  /// 행정실 (서류 가방)
  office,

  /// 도서관 (펼친 책)
  library,

  /// 강당 (의자)
  auditorium,

  /// 교실 (칠판)
  classroom,

  /// 그 밖의 장소 (위치 핀)
  place,

  /// 학교 개요 (학교 건물)
  school,

  /// 앞으로 (화살표)
  arrowForward,
}

/// [GmIcons]를 그리는 위젯. [color]는 선 색, 면은 같은 색을 옅게 쓴다.
class GmIcon extends StatelessWidget {
  const GmIcon(
    this.icon, {
    super.key,
    this.size = AppSize.iconMd,
    this.color,
    this.fillOpacity = defaultFillOpacity,
    this.semanticLabel,
  });

  final GmIcons icon;
  final double size;

  /// 선 색. 없으면 [IconTheme]의 색을 쓴다.
  final Color? color;

  /// 면 색의 진하기 (선 색 기준). 0이면 선만 그린다.
  final double fillOpacity;
  final String? semanticLabel;

  static const defaultFillOpacity = 0.16;

  @override
  Widget build(BuildContext context) {
    final stroke =
        color ??
        IconTheme.of(context).color ??
        Theme.of(context).colorScheme.onSurface;
    final painted = CustomPaint(
      size: Size.square(size),
      painter: _GmIconPainter(
        icon: icon,
        stroke: stroke,
        fillOpacity: fillOpacity,
      ),
    );
    return Semantics(
      label: semanticLabel,
      excludeSemantics: semanticLabel == null,
      child: SizedBox.square(dimension: size, child: painted),
    );
  }
}

class _GmIconPainter extends CustomPainter {
  _GmIconPainter({
    required this.icon,
    required this.stroke,
    required this.fillOpacity,
  });

  final GmIcons icon;
  final Color stroke;
  final double fillOpacity;

  /// 24 격자 기준 선 굵기.
  static const _strokeWidth = 1.7;
  static const _grid = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    // 반투명 색이면 선과 면이 겹치는 곳이 진하게 겹쳐 보인다. 불투명하게
    // 한 겹에 그린 뒤 그 겹 전체에 투명도를 준다.
    final solid = stroke.withValues(alpha: 1);
    canvas.saveLayer(
      Offset.zero & size,
      Paint()..color = Color.fromRGBO(0, 0, 0, stroke.a),
    );
    canvas.scale(size.width / _grid, size.height / _grid);

    final line = Paint()
      ..color = solid
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final face = Paint()
      ..color = solid.withValues(alpha: fillOpacity)
      ..style = PaintingStyle.fill;

    void shape(Path p, {bool filled = true}) {
      if (filled) canvas.drawPath(p, face);
      canvas.drawPath(p, line);
    }

    void outline(Path p) => canvas.drawPath(p, line);

    RRect rr(double l, double t, double w, double h, double r) =>
        RRect.fromLTRBR(l, t, l + w, t + h, Radius.circular(r));

    switch (icon) {
      case GmIcons.navigate:
        shape(
          Path()
            ..moveTo(19.5, 4.5)
            ..lineTo(4.5, 10.6)
            ..quadraticBezierTo(3.6, 11.1, 4.6, 11.6)
            ..lineTo(10.6, 13.4)
            ..lineTo(12.4, 19.4)
            ..quadraticBezierTo(12.9, 20.4, 13.4, 19.5)
            ..close(),
        );

      case GmIcons.tour:
        shape(
          Path()
            ..moveTo(6, 4.8)
            ..cubicTo(9, 3.2, 11.4, 6.4, 14.2, 5.2)
            ..cubicTo(15.8, 4.5, 17.2, 4.4, 18.5, 4.8)
            ..lineTo(18.5, 13.4)
            ..cubicTo(17.2, 13, 15.8, 13.1, 14.2, 13.8)
            ..cubicTo(11.4, 15, 9, 11.8, 6, 13.4)
            ..close(),
        );
        outline(
          Path()
            ..moveTo(6, 4)
            ..lineTo(6, 20.5),
        );

      case GmIcons.science:
        // 액체가 담긴 아랫부분만 면으로 칠한다.
        canvas.drawPath(
          Path()
            ..moveTo(7.6, 14.2)
            ..lineTo(16.4, 14.2)
            ..lineTo(18.3, 17.6)
            ..quadraticBezierTo(19.2, 20, 16.6, 20)
            ..lineTo(7.4, 20)
            ..quadraticBezierTo(4.8, 20, 5.7, 17.6)
            ..close(),
          face,
        );
        outline(
          Path()
            ..moveTo(10, 4)
            ..lineTo(10, 9.2)
            ..lineTo(5.7, 17.6)
            ..quadraticBezierTo(4.8, 20, 7.4, 20)
            ..lineTo(16.6, 20)
            ..quadraticBezierTo(19.2, 20, 18.3, 17.6)
            ..lineTo(14, 9.2)
            ..lineTo(14, 4),
        );
        outline(
          Path()
            ..moveTo(8.8, 4)
            ..lineTo(15.2, 4),
        );

      case GmIcons.computer:
        shape(Path()..addRRect(rr(3.5, 4.5, 17, 11.5, 2.2)));
        outline(
          Path()
            ..moveTo(12, 16)
            ..lineTo(12, 19.5)
            ..moveTo(8.5, 19.8)
            ..lineTo(15.5, 19.8),
        );

      case GmIcons.teacher:
        shape(Path()..addRRect(rr(4, 6.5, 16, 13.5, 2.6)));
        outline(
          Path()
            ..moveTo(10, 6.5)
            ..lineTo(10, 4.5)
            ..lineTo(14, 4.5)
            ..lineTo(14, 6.5),
        );
        outline(
          Path()..addOval(
            Rect.fromCircle(center: const Offset(9.4, 12), radius: 1.8),
          ),
        );
        outline(
          Path()
            ..moveTo(6.8, 16.8)
            ..quadraticBezierTo(9.4, 13.8, 12, 16.8)
            ..moveTo(14, 11.2)
            ..lineTo(17, 11.2)
            ..moveTo(14, 14.2)
            ..lineTo(16, 14.2),
        );

      case GmIcons.office:
        shape(Path()..addRRect(rr(3.5, 7.5, 17, 12, 2.6)));
        outline(
          Path()
            ..moveTo(9, 7.5)
            ..lineTo(9, 6)
            ..quadraticBezierTo(9, 4.5, 10.5, 4.5)
            ..lineTo(13.5, 4.5)
            ..quadraticBezierTo(15, 4.5, 15, 6)
            ..lineTo(15, 7.5)
            ..moveTo(3.5, 12.5)
            ..lineTo(20.5, 12.5)
            ..moveTo(12, 11.5)
            ..lineTo(12, 13.5),
        );

      case GmIcons.library:
        final left = Path()
          ..moveTo(12, 6.8)
          ..cubicTo(10, 5.2, 7, 4.8, 4, 5.4)
          ..lineTo(4, 18.4)
          ..cubicTo(7, 17.8, 10, 18.2, 12, 19.8)
          ..close();
        final right = Path()
          ..moveTo(12, 6.8)
          ..cubicTo(14, 5.2, 17, 4.8, 20, 5.4)
          ..lineTo(20, 18.4)
          ..cubicTo(17, 17.8, 14, 18.2, 12, 19.8)
          ..close();
        shape(left);
        shape(right, filled: false);

      case GmIcons.auditorium:
        shape(Path()..addRRect(rr(7, 4, 10, 9, 2.6)));
        outline(
          Path()
            ..moveTo(5, 13.2)
            ..lineTo(19, 13.2)
            ..moveTo(7, 13.2)
            ..lineTo(7, 20)
            ..moveTo(17, 13.2)
            ..lineTo(17, 20)
            ..moveTo(7, 16.8)
            ..lineTo(17, 16.8),
        );

      case GmIcons.classroom:
        shape(Path()..addRRect(rr(3.5, 4.5, 17, 11, 2.2)));
        outline(
          Path()
            ..moveTo(7, 8.5)
            ..lineTo(12.5, 8.5)
            ..moveTo(7, 11.5)
            ..lineTo(10.5, 11.5)
            ..moveTo(8.5, 15.5)
            ..lineTo(7, 20)
            ..moveTo(15.5, 15.5)
            ..lineTo(17, 20),
        );

      case GmIcons.place:
        shape(
          Path()
            ..moveTo(12, 20.5)
            ..cubicTo(12, 20.5, 5.2, 14.6, 5.2, 9.8)
            ..arcToPoint(
              const Offset(18.8, 9.8),
              radius: const Radius.circular(6.8),
            )
            ..cubicTo(18.8, 14.6, 12, 20.5, 12, 20.5)
            ..close(),
        );
        outline(
          Path()..addOval(
            Rect.fromCircle(center: const Offset(12, 9.8), radius: 2.4),
          ),
        );

      case GmIcons.school:
        shape(Path()..addRRect(rr(4.5, 10, 15, 10, 1.8)));
        outline(
          Path()
            ..moveTo(3, 10.8)
            ..lineTo(12, 4.5)
            ..lineTo(21, 10.8)
            ..moveTo(10.3, 20)
            ..lineTo(10.3, 15.6)
            ..quadraticBezierTo(10.3, 14.6, 11.3, 14.6)
            ..lineTo(12.7, 14.6)
            ..quadraticBezierTo(13.7, 14.6, 13.7, 15.6)
            ..lineTo(13.7, 20),
        );
        outline(
          Path()..addOval(
            Rect.fromCircle(center: const Offset(12, 10.6), radius: 1.4),
          ),
        );

      case GmIcons.arrowForward:
        outline(
          Path()
            ..moveTo(4.5, 12)
            ..lineTo(19, 12)
            ..moveTo(13.5, 6.5)
            ..lineTo(19, 12)
            ..lineTo(13.5, 17.5),
        );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GmIconPainter old) =>
      old.icon != icon ||
      old.stroke != stroke ||
      old.fillOpacity != fillOpacity;
}
