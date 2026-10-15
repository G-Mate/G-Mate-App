import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../place/presentation/place_not_found.dart';
import 'bloc/arrival_cubit.dart';
import 'bloc/arrival_state.dart';
import 'guiding_page.dart';
import 'widgets/keep_all_text.dart';

/// 길 찾기 - 도착·설명. 도착하면 도착 멘트와 [설명 듣기]를 보여 주고, 누르면
/// 로봇이 읽는 본 설명을 자막처럼 한 줄씩 크게 보여 준다.
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
  static const _nextAlpha = 0.4;

  /// 줄이 바뀔 때 오르내리는 거리 (자기 높이 대비).
  static const _rise = 0.35;

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

        final (status, statusType) = switch (state) {
          ArrivalState(isSpeaking: true, isListening: false) => (
            '도착을 알려 드리는 중',
            GmStatusType.info,
          ),
          ArrivalState(isSpeaking: true) => ('설명을 들려 드리는 중', GmStatusType.info),
          ArrivalState(isListening: true) => (
            '설명을 다 들려 드렸어요',
            GmStatusType.success,
          ),
          _ when state.hasDescription => ('설명을 들을 수 있어요', GmStatusType.success),
          _ => ('안내를 마쳤어요', GmStatusType.success),
        };

        return GmSplitLayout(
          // 투어 설명 화면과 같이 상태는 위에, [안내 중지]는 아래에 둔다.
          hero: GmHeroPanel(
            top: GmStatusIndicator(
              label: status,
              type: statusType,
              onDark: true,
            ),
            overline: '도착했어요',
            title: place.name,
            subtitle: place.meta,
            footer: GmButton(
              label: '안내 중지',
              icon: Icons.stop_rounded,
              variant: GmButtonVariant.outline,
              onPressed: () async {
                if (await confirmGuideStop(context) && context.mounted) {
                  context.go(AppRoutes.home);
                }
              },
            ),
          ),
          // 도착하면 도착 멘트만 읽고, 본 설명은 방문객이 골라서 듣는다.
          child: !state.isListening
              ? _ArrivalPrompt(
                  message: place.speech.arrival,
                  lineCount: lines.length,
                  isSpeaking: state.isSpeaking,
                  onListen: cubit.listen,
                  onDone: () => context.go(AppRoutes.home),
                )
              : Column(
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
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
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
                          alignment: Alignment.center,
                          children: [...previous, ?currentChild],
                        ),
                        // 지금 줄은 위로 올라가며 사라지고, 다음 줄은 아래에서
                        // 올라오며 나타난다.
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GmButton(
                          label: '다시 듣기',
                          icon: Icons.replay_rounded,
                          variant: GmButtonVariant.secondary,
                          onPressed: cubit.replay,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // 마지막 줄에서는 [마침]으로 바뀌어 처음 화면으로 돌아간다.
                        if (state.hasNext)
                          _NextButton(
                            // 줄이 바뀌거나 다 읽으면 남은 시간을 처음부터 센다.
                            key: ValueKey('next-$current-${state.isLineDone}'),
                            waiting: state.isLineDone,
                            interval: place.lineInterval,
                            onPressed: cubit.next,
                          )
                        else
                          GmButton(
                            label: '마침',
                            variant: state.isSpeaking
                                ? GmButtonVariant.outline
                                : GmButtonVariant.primary,
                            onPressed: () => context.go(AppRoutes.home),
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

/// 도착하고 아직 설명을 듣지 않은 화면. 도착 멘트를 크게 보여 주고,
/// 본 설명이 있으면 [설명 듣기]를, 없으면 [마침]만 강조한다.
class _ArrivalPrompt extends StatelessWidget {
  const _ArrivalPrompt({
    required this.message,
    required this.lineCount,
    required this.isSpeaking,
    required this.onListen,
    required this.onDone,
  });

  final String message;

  /// 본 설명 줄 수. 0이면 [설명 듣기]를 보여 주지 않는다.
  final int lineCount;
  final bool isSpeaking;
  final VoidCallback onListen;
  final VoidCallback onDone;

  static const _messageLineHeight = 1.35;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    final hasDescription = lineCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KeepAllText(
                message,
                alignment: WrapAlignment.center,
                style: text.displaySmall?.copyWith(height: _messageLineHeight),
              ),
              if (hasDescription) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '설명을 들으시려면 [설명 듣기]를 눌러 주세요',
                  textAlign: TextAlign.center,
                  style: text.bodyLarge?.copyWith(
                    color: semantic.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GmButton(
              label: '마침',
              variant: hasDescription
                  ? GmButtonVariant.secondary
                  : GmButtonVariant.primary,
              onPressed: onDone,
            ),
            if (hasDescription) ...[
              const SizedBox(width: AppSpacing.sm),
              GmButton(
                label: '설명 듣기',
                icon: Icons.volume_up_outlined,
                // 도착 멘트를 읽는 동안에도 누르면 바로 설명으로 넘어간다.
                onPressed: onListen,
              ),
            ],
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
