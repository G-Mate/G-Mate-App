import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../place/presentation/place_icons.dart';
import '../../speech/presentation/bloc/voice_guide_cubit.dart';
import '../../speech/presentation/voice_guide_scope.dart';
import '../../speech/presentation/voice_scripts.dart';
import '../domain/tour.dart';
import 'bloc/tour_detail_cubit.dart';
import 'tour_widgets.dart';

/// 학교 투어 - 끝. 둘러본 곳을 한눈에 보여 주고 처음으로 돌아간다.
class TourDonePage extends StatelessWidget {
  const TourDonePage({super.key});

  /// 버튼 줄의 [다른 코스 보기] : [처음으로] 너비 비율.
  static const _otherFlex = 3;
  static const _homeFlex = 7;

  @override
  Widget build(BuildContext context) {
    // 마침 멘트는 투어가 읽었으니, 기다렸다가 다른 코스·처음으로만 안내한다.
    return VoiceGuideScope(
      onCommand: (context, command) {
        if (command == VoiceScripts.cancelCommand) {
          context.go(AppRoutes.tourSelect);
        } else if (command == VoiceScripts.doneCommand) {
          context.go(AppRoutes.home);
        }
      },
      child: BlocListener<TourDetailCubit, TourDetailState>(
        listenWhen: (a, b) => a.isLoading && !b.isLoading,
        listener: (context, state) =>
            context.read<VoiceGuideCubit>().start(VoiceScripts.tourDone),
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return BlocBuilder<TourDetailCubit, TourDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final tour = state.tour;
        if (tour == null) return const TourNotFound();

        return GmSplitLayout(
          hero: GmHeroPanel(
            overline: '${tour.name} 끝',
            title: '둘러봐 주셔서\n고마워요',
            subtitle: '궁금한 곳은 길 찾기로 다시 가 볼 수 있어요',
            footer: GmStatRow(
              stats: [
                GmStat(value: '${state.visits.length}곳', label: '둘러본 곳'),
                GmStat(value: tour.durationLabel, label: '코스 시간'),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GmOverline('둘러본 곳', color: context.appColors.textSecondary),
              const SizedBox(height: AppSpacing.lg),
              Expanded(child: _VisitedGrid(visits: state.visits)),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    flex: _otherFlex,
                    child: GmButton(
                      label: '다른 코스 보기',
                      variant: GmButtonVariant.outline,
                      size: GmButtonSize.large,
                      expanded: true,
                      onPressed: () => context.go(AppRoutes.tourSelect),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: _homeFlex,
                    child: GmButton(
                      label: '처음으로',
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

/// 둘러본 곳을 두 줄로 나란히 놓은 작은 카드들.
class _VisitedGrid extends StatelessWidget {
  const _VisitedGrid({required this.visits});

  final List<TourVisit> visits;

  static const _columns = 2;
  static const _tileExtent = 96.0;

  @override
  Widget build(BuildContext context) {
    final semantic = context.appColors;
    final text = context.textStyles;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: _tileExtent,
      ),
      itemCount: visits.length,
      itemBuilder: (context, i) {
        final place = visits[i].place;
        return GmCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              GmIcon(
                placeIcon(place),
                size: AppSize.iconMd,
                color: semantic.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: text.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      place.meta,
                      style: text.bodySmall?.copyWith(
                        color: semantic.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_rounded,
                size: AppSize.iconSm,
                color: semantic.success,
              ),
            ],
          ),
        );
      },
    );
  }
}
