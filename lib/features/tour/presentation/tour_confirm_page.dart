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

/// 학교 투어 - 코스 확인. 들를 곳을 차례로 보여 주고 투어를 시작한다.
class TourConfirmPage extends StatelessWidget {
  const TourConfirmPage({super.key});

  /// 버튼 줄의 [다른 코스] : [투어 시작] 너비 비율 (장소 확인과 같다).
  static const _backFlex = 3;
  static const _startFlex = 7;

  @override
  Widget build(BuildContext context) {
    // 코스와 들를 곳을 읽고, 기다렸다가 투어 시작·다른 코스를 안내한다.
    return VoiceGuideScope(
      onCommand: (context, command) {
        final tour = context.read<TourDetailCubit>().state.tour;
        if (tour == null) return;
        if (command == VoiceScripts.startCommand) {
          context.push(AppRoutes.tourRun(tour.key));
        } else if (command == VoiceScripts.cancelCommand) {
          _back(context);
        }
      },
      child: BlocListener<TourDetailCubit, TourDetailState>(
        listenWhen: (a, b) => a.isLoading && !b.isLoading,
        listener: (context, state) {
          final tour = state.tour;
          if (tour == null || state.visits.isEmpty) return;
          context.read<VoiceGuideCubit>().start(
            VoiceScripts.tourConfirm(tour, [
              for (final v in state.visits) v.place.name,
            ]),
          );
        },
        child: _content(),
      ),
    );
  }

  static void _back(BuildContext context) =>
      context.canPop() ? context.pop() : context.go(AppRoutes.tourSelect);

  Widget _content() {
    return BlocBuilder<TourDetailCubit, TourDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final tour = state.tour;
        if (tour == null || state.visits.isEmpty) return const TourNotFound();

        void back() => _back(context);

        return GmSplitLayout(
          hero: GmHeroPanel(
            top: GmHeroBackButton(onPressed: back),
            overline: '학교 투어',
            title: tour.name,
            subtitle: tour.description,
            footer: GmStatRow(
              stats: [
                GmStat(value: '${state.visits.length}곳', label: '둘러볼 곳'),
                GmStat(value: tour.durationLabel, label: '걸리는 시간'),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GmOverline('이 순서로 안내해요', color: context.appColors.textSecondary),
              const SizedBox(height: AppSpacing.lg),
              Expanded(child: _StopList(visits: state.visits)),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    flex: _backFlex,
                    child: GmButton(
                      label: '다른 코스',
                      variant: GmButtonVariant.outline,
                      size: GmButtonSize.large,
                      expanded: true,
                      onPressed: back,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: _startFlex,
                    child: GmButton(
                      label: '투어 시작',
                      size: GmButtonSize.large,
                      expanded: true,
                      onPressed: () =>
                          context.push(AppRoutes.tourRun(tour.key)),
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

/// 들를 곳 목록. 번호 동그라미를 세로 선으로 이어 순서를 보여 준다.
class _StopList extends StatelessWidget {
  const _StopList({required this.visits});

  final List<TourVisit> visits;

  static const _rowExtent = 80.0;
  static const _markerSize = 40.0;
  static const _railWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;

    return ListView.builder(
      itemCount: visits.length,
      itemExtent: _rowExtent,
      itemBuilder: (context, i) {
        final place = visits[i].place;
        return Row(
          children: [
            SizedBox(
              width: _markerSize,
              height: _rowExtent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 앞뒤 번호를 잇는 선. 처음과 끝에서는 반만 그린다.
                  Positioned(
                    top: i == 0 ? _rowExtent / 2 : 0,
                    bottom: i == visits.length - 1 ? _rowExtent / 2 : 0,
                    child: Container(
                      width: _railWidth,
                      color: colors.outlineVariant,
                    ),
                  ),
                  Container(
                    width: _markerSize,
                    height: _markerSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Text('${i + 1}', style: text.labelSmall),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                place.name,
                style: text.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              place.meta,
              style: text.bodySmall?.copyWith(color: semantic.textSecondary),
            ),
            const SizedBox(width: AppSpacing.lg),
            GmIcon(
              placeIcon(place),
              size: AppSize.iconMd,
              color: semantic.textSecondary,
            ),
          ],
        );
      },
    );
  }
}
