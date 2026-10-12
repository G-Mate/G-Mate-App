import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 길 찾기 - 이동 중. 왼쪽에 어디로 가는지 크게, 오른쪽에 층 지도로
/// 지금 위치와 목적지를 보여 준다.
///
/// 실제 화면에서는 temi의 지도 이미지와 로봇 위치를 받아 그린다. 시안의 지도는
/// 예시 평면도다.
class GuidingScreen extends StatelessWidget {
  const GuidingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final place = samplePlaces.first;

    return GmSplitLayout(
      hero: GmHeroPanel(
        top: const GmStatusIndicator(
          label: '이동 중',
          type: GmStatusType.success,
          onDark: true,
        ),
        overline: '${place.meta}로 가는 중',
        title: '${place.name}로\n안내하고 있어요',
        subtitle: '로봇을 따라와 주세요',
        footer: GmButton(
          label: '안내 중지',
          icon: Icons.stop_rounded,
          variant: GmButtonVariant.danger,
          size: GmButtonSize.large,
          onPressed: () {},
        ),
      ),
      child: _MapCard(floor: place.floor, destination: place.name),
    );
  }
}

/// 층 지도 카드: 위에 층 이름과 범례, 아래에 지도.
class _MapCard extends StatelessWidget {
  const _MapCard({required this.floor, required this.destination});

  final int floor;
  final String destination;

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
              _Legend(color: AppColors.navy, label: destination),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: CustomPaint(
              painter: _FloorMapPainter(
                label: TextPainter(
                  text: TextSpan(
                    text: destination,
                    style: text.titleMedium?.copyWith(color: AppColors.navy),
                  ),
                  textDirection: TextDirection.ltr,
                )..layout(),
                wall: semantic.textDisabled,
                room: colors.surfaceContainerHighest,
                route: colors.primary,
                destination: AppColors.navy,
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
          width: 12,
          height: 12,
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

/// 시안용 예시 평면도. 복도 하나에 교실이 위아래로 붙어 있고, 로봇이 왼쪽에서
/// 오른쪽 끝 과학실로 가는 경로를 그린다. 좌표는 0~1 비율.
class _FloorMapPainter extends CustomPainter {
  _FloorMapPainter({
    required this.label,
    required this.wall,
    required this.room,
    required this.route,
    required this.destination,
  });

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
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect(dl, 0, dw, _corridorTop - 0.02), r),
      Paint()
        ..color = destination
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final destRect = rect(dl, 0, dw, _corridorTop - 0.02);
    label.paint(
      canvas,
      destRect.center - Offset(label.width / 2, label.height / 2),
    );

    // 경로: 복도 가운데를 따라 오른쪽으로 가서 목적지 문 앞까지.
    const midY = (_corridorTop + _corridorBottom) / 2;
    final start = at(0.12, midY);
    final turn = at(0.86, midY);
    final door = at(0.86, _corridorTop - 0.02);
    final robotAt = at(0.38, midY);

    final done = Paint()
      ..color = route.withValues(alpha: 0.25)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final todo = Paint()
      ..color = route
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(start, robotAt, done)
      ..drawLine(robotAt, turn, todo)
      ..drawLine(turn, door, todo);

    // 목적지 점.
    canvas
      ..drawCircle(door, 14, Paint()..color = destination)
      ..drawCircle(door, 5, Paint()..color = room);

    // 로봇(지금 위치): 옅은 원 + 흰 테두리 점.
    canvas
      ..drawCircle(robotAt, 26, Paint()..color = route.withValues(alpha: 0.18))
      ..drawCircle(robotAt, 13, Paint()..color = Colors.white)
      ..drawCircle(robotAt, 10, Paint()..color = route);
  }

  @override
  bool shouldRepaint(_FloorMapPainter old) =>
      old.label.text != label.text ||
      old.wall != wall ||
      old.room != room ||
      old.route != route ||
      old.destination != destination;
}
