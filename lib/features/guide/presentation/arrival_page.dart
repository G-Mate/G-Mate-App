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

  static const _progressHeight = 4.0;
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
              Row(
                children: [
                  Text(
                    '${current + 1}',
                    style: text.titleMedium?.copyWith(color: colors.primary),
                  ),
                  Text(
                    ' / ${lines.length}',
                    style: text.titleMedium?.copyWith(
                      color: semantic.textDisabled,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_progressHeight / 2),
                      child: LinearProgressIndicator(
                        value: (current + 1) / lines.length,
                        minHeight: _progressHeight,
                        backgroundColor: colors.outlineVariant,
                      ),
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
                    color: semantic.textDisabled,
                  ),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: GmButton(
                      label: '다시 듣기',
                      icon: Icons.replay_rounded,
                      variant: GmButtonVariant.secondary,
                      size: GmButtonSize.large,
                      expanded: true,
                      onPressed: context.read<ArrivalCubit>().replay,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: GmButton(
                      label: '처음으로',
                      icon: Icons.home_outlined,
                      variant: GmButtonVariant.outline,
                      size: GmButtonSize.large,
                      expanded: true,
                      onPressed: () => context.go(AppRoutes.home),
                    ),
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
