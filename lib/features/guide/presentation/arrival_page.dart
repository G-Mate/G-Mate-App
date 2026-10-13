import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../place/presentation/place_not_found.dart';
import 'bloc/arrival_cubit.dart';
import 'bloc/arrival_state.dart';
import 'widgets/keep_all_text.dart';

/// 길 찾기 - 도착·설명. 로봇이 읽는 본 설명을 자막처럼 한 줄씩 크게 보여 준다.
///
/// 지금 줄 아래에 다음 줄을 흐리게 미리 보여 주고, 줄이 바뀔 때는 아래에서
/// 올라오며 부드럽게 바뀐다. 한 줄을 다 읽으면 [다음]이 강조되고 저절로
/// 넘어가기까지 남은 시간을 보여 준다.
class ArrivalPage extends StatelessWidget {
  const ArrivalPage({super.key});

  static const _dotSize = 8.0;
  static const _activeDotWidth = 24.0;
  static const _subtitleLineHeight = 1.35;
  static const _lineSwitch = Duration(milliseconds: 450);

  /// 다음 줄 미리보기의 진하기.
  static const _nextAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArrivalCubit, ArrivalState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final place = state.place;
        if (place == null) return const PlaceNotFound();

        final text = context.textStyles;
        final colors = context.colors;
        final semantic = context.appColors;
        final cubit = context.read<ArrivalCubit>();
        final lines = state.lines;
        final current = state.lineIndex;
        final next = current + 1 < lines.length ? lines[current + 1] : null;

        return GmSplitLayout(
          hero: GmHeroPanel(
            overline: '도착했어요',
            title: place.name,
            subtitle: place.meta,
            footer: GmStatusIndicator(
              label: state.isSpeaking ? '설명을 들려 드리는 중' : '설명을 다 들려 드렸어요',
              type: state.isSpeaking ? GmStatusType.info : GmStatusType.success,
              onDark: true,
            ),
          ),
          child: Column(
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
                        color: i <= current
                            ? colors.primary
                            : colors.outlineVariant,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${current + 1} / ${lines.length}',
                    style: text.labelSmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: _lineSwitch,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (currentChild, previous) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...previous, ?currentChild],
                  ),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Column(
                    key: ValueKey(current),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeepAllText(
                        lines[current],
                        style: text.displaySmall?.copyWith(
                          height: _subtitleLineHeight,
                        ),
                      ),
                      if (next != null) ...[
                        const SizedBox(height: AppSpacing.xl),
                        KeepAllText(
                          next,
                          style: text.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.onSurface.withValues(
                              alpha: _nextAlpha,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  GmButton(
                    label: '처음으로',
                    icon: Icons.home_outlined,
                    variant: GmButtonVariant.outline,
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  const Spacer(),
                  GmButton(
                    label: '다시 듣기',
                    icon: Icons.replay_rounded,
                    variant: GmButtonVariant.secondary,
                    onPressed: cubit.replay,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _NextButton(
                    // 줄이 바뀌거나 다 읽으면 남은 시간을 처음부터 센다.
                    key: ValueKey('next-$current-${state.isLineDone}'),
                    enabled: state.hasNext,
                    waiting: state.isLineDone,
                    interval: place.lineInterval,
                    onPressed: cubit.next,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// [다음] 버튼. 읽는 중에는 테두리만, 다 읽으면 파랑으로 강조하고 저절로
/// 넘어가기까지 남은 초와 줄어드는 막대를 보여 준다.
class _NextButton extends StatelessWidget {
  const _NextButton({
    super.key,
    required this.enabled,
    required this.waiting,
    required this.interval,
    required this.onPressed,
  });

  final bool enabled;
  final bool waiting;
  final Duration interval;
  final VoidCallback onPressed;

  static const _barHeight = 3.0;
  static const _barBottom = 8.0;
  static const _barTrackAlpha = 0.25;

  @override
  Widget build(BuildContext context) {
    if (!enabled || !waiting) {
      return GmButton(
        label: '다음',
        icon: Icons.arrow_forward_rounded,
        variant: GmButtonVariant.outline,
        onPressed: enabled ? onPressed : null,
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: interval,
      builder: (context, remain, _) {
        final seconds = (remain * interval.inMilliseconds / 1000).ceil();
        return Stack(
          children: [
            GmButton(
              label: '다음 · $seconds초',
              icon: Icons.arrow_forward_rounded,
              onPressed: onPressed,
            ),
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
