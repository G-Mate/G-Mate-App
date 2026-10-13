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
class ArrivalPage extends StatelessWidget {
  const ArrivalPage({super.key});

  static const _dotSize = 8.0;
  static const _activeDotWidth = 24.0;
  static const _subtitleLineHeight = 1.4;

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
              const Spacer(),
              KeepAllText(
                lines[current],
                style: text.headlineLarge?.copyWith(
                  height: _subtitleLineHeight,
                ),
              ),
              if (next != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  next,
                  style: text.bodyMedium?.copyWith(
                    color: semantic.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  GmButton(
                    label: '처음으로',
                    icon: Icons.home_outlined,
                    variant: GmButtonVariant.outline,
                    size: GmButtonSize.large,
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  const Spacer(),
                  GmButton(
                    label: '다시 듣기',
                    icon: Icons.replay_rounded,
                    variant: GmButtonVariant.secondary,
                    size: GmButtonSize.large,
                    onPressed: cubit.replay,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // 정한 시간이 지나면 저절로 넘어가지만, 기다리지 않고 넘길 수 있다.
                  GmButton(
                    label: '다음',
                    icon: Icons.arrow_forward_rounded,
                    size: GmButtonSize.large,
                    onPressed: state.hasNext ? cubit.next : null,
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
