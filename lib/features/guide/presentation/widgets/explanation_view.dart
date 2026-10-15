import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'keep_all_text.dart';

/// 장소 설명 화면. 길 찾기 도착과 학교 투어가 같이 쓴다.
///
/// 위에 몇 번째 줄인지 작은 점과 글자, 가운데에 지금 줄을 자막처럼 크게
/// (다음 줄은 작고 옅게 미리), 아래에 [다시 듣기]와 [다음]을 둔다. 줄이 바뀔
/// 때는 아래에서 올라오며 바뀐다. 한 줄을 다 읽으면 [다음]이 강조되고
/// 저절로 넘어가기까지 남은 시간을 보여 준다. 마지막 줄에서는 [다음] 대신
/// [lastAction]을 둔다.
class ExplanationView extends StatelessWidget {
  const ExplanationView({
    super.key,
    required this.lines,
    required this.current,
    required this.isLineDone,
    required this.interval,
    required this.onReplay,
    required this.onNext,
    required this.lastAction,
  });

  final List<String> lines;
  final int current;

  /// 지금 줄을 다 읽고 다음 줄을 기다리는 중인지.
  final bool isLineDone;

  /// 줄 사이에 쉬는 시간 (장소의 '자동 넘김').
  final Duration interval;
  final VoidCallback onReplay;
  final VoidCallback onNext;

  /// 마지막 줄에서 [다음] 자리에 두는 버튼 ([마침], [다음 장소] 등).
  final Widget lastAction;

  static const _dotSize = 8.0;
  static const _activeDotWidth = 24.0;
  static const _subtitleLineHeight = 1.35;
  static const _lineSwitch = Duration(milliseconds: 450);

  /// 다음 줄 미리보기의 진하기.
  static const _nextAlpha = 0.4;

  /// 줄이 바뀔 때 오르내리는 거리 (자기 높이 대비).
  static const _rise = 0.35;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final colors = context.colors;
    final semantic = context.appColors;
    final hasNext = current + 1 < lines.length;
    final next = hasNext ? lines[current + 1] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 몇 번째 줄인지는 작은 점과 글자로만 보여 준다 (자막에 시선이 가도록).
        Row(
          children: [
            for (var i = 0; i < lines.length; i++)
              AnimatedContainer(
                duration: AppDuration.slow,
                margin: const EdgeInsets.only(right: AppSpacing.xs),
                width: i == current ? _activeDotWidth : _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: i <= current ? colors.primary : colors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${current + 1} / ${lines.length}',
              style: text.labelSmall?.copyWith(color: semantic.textSecondary),
            ),
          ],
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: _lineSwitch,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (currentChild, previous) => Stack(
              alignment: Alignment.center,
              children: [...previous, ?currentChild],
            ),
            // 지금 줄은 위로 올라가며 사라지고, 다음 줄은 아래에서 올라오며
            // 나타난다.
            transitionBuilder: (child, animation) {
              final incoming = child.key == ValueKey(current);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: Offset(0, incoming ? _rise : -_rise),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Column(
              key: ValueKey(current),
              mainAxisSize: MainAxisSize.min,
              children: [
                KeepAllText(
                  lines[current],
                  alignment: WrapAlignment.center,
                  style: text.displaySmall?.copyWith(
                    height: _subtitleLineHeight,
                  ),
                ),
                if (next != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  // 다음 줄은 작고 옅게 한 줄만 미리 보여 준다.
                  Text(
                    next,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: _nextAlpha),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GmButton(
              label: '다시 듣기',
              icon: Icons.replay_rounded,
              variant: GmButtonVariant.secondary,
              onPressed: onReplay,
            ),
            const SizedBox(width: AppSpacing.sm),
            if (hasNext)
              _NextButton(
                // 줄이 바뀌거나 다 읽으면 남은 시간을 처음부터 센다.
                key: ValueKey('next-$current-$isLineDone'),
                waiting: isLineDone,
                interval: interval,
                onPressed: onNext,
              )
            else
              lastAction,
          ],
        ),
      ],
    );
  }
}

/// [다음] 버튼. 읽는 중에는 테두리만, 다 읽으면 파랑으로 강조하고 저절로
/// 넘어가기까지 남은 초와 줄어드는 막대를 보여 준다.
class _NextButton extends StatelessWidget {
  const _NextButton({
    super.key,
    required this.waiting,
    required this.interval,
    required this.onPressed,
  });

  final bool waiting;
  final Duration interval;
  final VoidCallback onPressed;

  static const _barHeight = 3.0;
  static const _barBottom = 8.0;
  static const _barTrackAlpha = 0.25;

  @override
  Widget build(BuildContext context) {
    if (!waiting) {
      return GmButton(
        label: '다음',
        variant: GmButtonVariant.outline,
        onPressed: onPressed,
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: interval,
      builder: (context, remain, _) {
        final seconds = (remain * interval.inMilliseconds / 1000).ceil();
        return Stack(
          children: [
            GmButton(label: '다음 · $seconds초', onPressed: onPressed),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: _barBottom,
              child: IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: remain,
                    minHeight: _barHeight,
                    color: Colors.white,
                    backgroundColor: Colors.white.withValues(
                      alpha: _barTrackAlpha,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
