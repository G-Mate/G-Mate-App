import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system.dart';
import '../bloc/voice_guide_cubit.dart';
import '../bloc/voice_guide_state.dart';

/// 화면 오른쪽 위 가장자리에 두는 작은 음성 표시.
///
/// 듣는 중이면 초록 점이 든 작은 유리 동그라미를 켜고, 명령을 알아들으면 그
/// 동그라미가 왼쪽으로 늘어나 알아들은 말을 감싸는 말풍선이 된다.
/// 그 밖에는 아무것도 보이지 않는다.
class VoiceIndicator extends StatelessWidget {
  const VoiceIndicator({super.key});

  /// 동그라미 지름이자 말풍선 몸통 높이.
  static const size = 32.0;
  static const _dotSize = 8.0;
  static const _iconSize = 16.0;

  /// 말풍선 꼬리 높이.
  static const _tailHeight = 6.0;

  /// 화면 모서리에서 떨어진 거리. 화면 여백 안에 들어가 본문과 겹치지 않는다.
  static const edgeInset = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    // 상태 표시줄이 보이는 기기에서도 가려지지 않게 그 아래에 둔다.
    final safe = MediaQuery.paddingOf(context);
    return Positioned(
      top: safe.top + edgeInset,
      right: safe.right + edgeInset,
      child: IgnorePointer(
        child: BlocBuilder<VoiceGuideCubit, VoiceGuideState>(
          buildWhen: (a, b) =>
              a.phase != b.phase || a.recognized != b.recognized,
          builder: (context, state) {
            final recognized = state.phase == VoicePhase.recognized;
            final visible = recognized || state.phase == VoicePhase.listening;
            return AnimatedSwitcher(
              duration: AppDuration.normal,
              child: visible
                  ? _Bubble(text: recognized ? state.recognized : null)
                  : const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}

/// [text]가 없으면 동그라미, 있으면 그 말을 감싼 말풍선.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final text = this.text;
    final success = context.appColors.success;
    // 점과 체크가 같은 자리에 오도록 오른쪽 여백을 각자 크기에 맞춘다.
    final content = text == null
        ? Container(
            key: const ValueKey('dot'),
            width: VoiceIndicator._dotSize,
            height: VoiceIndicator._dotSize,
            margin: const EdgeInsets.symmetric(
              horizontal: (VoiceIndicator.size - VoiceIndicator._dotSize) / 2,
            ),
            decoration: BoxDecoration(color: success, shape: BoxShape.circle),
          )
        : Padding(
            key: ValueKey(text),
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              right: (VoiceIndicator.size - VoiceIndicator._iconSize) / 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Icon(
                  Icons.check_rounded,
                  size: VoiceIndicator._iconSize,
                  color: success,
                ),
              ],
            ),
          );

    return TweenAnimationBuilder<double>(
      tween: Tween(end: text == null ? 0 : 1),
      duration: AppDuration.normal,
      curve: Curves.easeOutCubic,
      builder: (context, tail, child) => Container(
        decoration: ShapeDecoration(
          color: AppColors.glass,
          shape: _BubbleBorder(
            side: const BorderSide(color: AppColors.glassBorder),
            tailHeight: VoiceIndicator._tailHeight * tail,
          ),
        ),
        child: child,
      ),
      child: SizedBox(
        height: VoiceIndicator.size,
        child: AnimatedSize(
          duration: AppDuration.normal,
          curve: Curves.easeOutCubic,
          alignment: Alignment.centerRight,
          child: AnimatedSwitcher(
            duration: AppDuration.fast,
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.centerRight,
              children: [...previous, ?current],
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// 둥근 몸통 아래 오른쪽에 작은 꼬리가 달린 말풍선 모양.
/// 꼬리 높이가 0이면 몸통만 남는다 (동그라미·알약).
class _BubbleBorder extends ShapeBorder {
  const _BubbleBorder({this.side = BorderSide.none, this.tailHeight = 0});

  final BorderSide side;
  final double tailHeight;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: tailHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Rect.fromLTRB(
      rect.left,
      rect.top,
      rect.right,
      rect.bottom - tailHeight,
    );
    final radius = body.height / 2;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(radius)));
    if (tailHeight <= 0) return path;
    // 꼬리는 오른쪽 둥근 끝이 시작하는 곳에서 아래로 살짝 기울게 뺀다.
    final start = body.right - radius;
    final tail = Path()
      ..moveTo(start - tailHeight * 1.5, body.bottom - 1)
      ..lineTo(start + tailHeight * 0.5, rect.bottom)
      ..lineTo(start + tailHeight * 0.5, body.bottom - 1)
      ..close();
    return Path.combine(PathOperation.union, path, tail);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(getOuterPath(rect), side.toPaint());
  }

  @override
  ShapeBorder scale(double t) =>
      _BubbleBorder(side: side.scale(t), tailHeight: tailHeight * t);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is _BubbleBorder
      ? _BubbleBorder(
          side: BorderSide.lerp(a.side, side, t),
          tailHeight: a.tailHeight + (tailHeight - a.tailHeight) * t,
        )
      : super.lerpFrom(a, t);

  @override
  bool operator ==(Object other) =>
      other is _BubbleBorder &&
      other.side == side &&
      other.tailHeight == tailHeight;

  @override
  int get hashCode => Object.hash(side, tailHeight);
}
