import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../../core/utils/korean.dart';
import '../../guide/presentation/widgets/floor_map.dart';
import '../../guide/presentation/widgets/explanation_view.dart';
import '../domain/tour.dart';
import 'bloc/tour_bloc.dart';
import 'tour_widgets.dart';

/// 학교 투어 - 진행. 들를 곳마다 이동 중에는 층 지도를, 도착하면 설명을
/// 자막처럼 한 줄씩 크게 보여 준다. 오른쪽 위에 몇 번째 곳인지 보여 준다.
///
/// 마지막 곳에서 [투어 마치기]를 누르면 투어 끝으로, [투어 중지]를 누르면
/// 홈으로 간다.
class TourRunPage extends StatelessWidget {
  const TourRunPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 코스 확인에서 push로 들어오므로, 투어 중에는 뒤로 가기를 막고
    // [투어 중지]로만 나간다.
    return PopScope(
      canPop: false,
      child: BlocConsumer<TourBloc, TourState>(
        listenWhen: (prev, next) => prev.phase != next.phase,
        listener: (context, state) {
          switch (state.phase) {
            case TourPhase.finished:
              context.go(AppRoutes.tourDone(state.tour!.key));
            case TourPhase.stopped:
              context.go(AppRoutes.home);
            default:
              break;
          }
        },
        builder: (context, state) {
          if (state.phase == TourPhase.notFound) return const TourNotFound();
          final tour = state.tour;
          final visit = state.visit;
          if (tour == null || visit == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final explaining =
              state.phase == TourPhase.explaining ||
              state.phase == TourPhase.finished;

          return GmSplitLayout(
            hero: _Hero(state: state, tour: tour, visit: visit),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StopSteps(visits: state.visits, current: state.stopIndex),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: AppDuration.slow,
                    child: explaining
                        ? _Explanation(
                            key: ValueKey('lines-${state.stopIndex}'),
                            state: state,
                          )
                        : FloorMap(
                            key: ValueKey('map-${state.stopIndex}'),
                            floor: visit.place.floor,
                            destination: visit.place.name,
                            progress: state.progress,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 왼쪽 남색 패널: 지금 무엇을 하는지 크게, 아래에 투어 중지 등 버튼.
class _Hero extends StatelessWidget {
  const _Hero({required this.state, required this.tour, required this.visit});

  final TourState state;
  final Tour tour;
  final TourVisit visit;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TourBloc>();
    final place = visit.place;
    final overline =
        '${tour.name} · ${state.stopIndex + 1} / ${state.visits.length}';

    final stop = GmButton(
      label: '투어 중지',
      icon: Icons.stop_rounded,
      variant: GmButtonVariant.danger,
      onPressed: () => _confirmStop(context, bloc),
    );
    // 도착했는데 로봇이 완료를 못 알리면 [도착했어요]로 직접 넘긴다.
    final arrived = GmButton(
      label: '도착했어요',
      icon: Icons.check_rounded,
      variant: GmButtonVariant.secondary,
      onPressed: () => bloc.add(const TourArrivalConfirmed()),
    );

    return switch (state.phase) {
      TourPhase.failed => GmHeroPanel(
        top: const GmStatusIndicator(
          label: '이동 멈춤',
          type: GmStatusType.warning,
          onDark: true,
        ),
        overline: overline,
        title: '${Korean.withRo(place.name)}\n가지 못했어요',
        subtitle: '길이 막혔을 수 있어요',
        // 세 버튼이 한 줄에 들어가도록 아이콘 없이 둔다.
        footer: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            GmButton(
              label: '다시 시도',
              onPressed: () => bloc.add(const TourRetryRequested()),
            ),
            GmButton(
              label: '건너뛰기',
              variant: GmButtonVariant.outline,
              onPressed: () => bloc.add(const TourNextRequested()),
            ),
            GmButton(
              label: '투어 중지',
              variant: GmButtonVariant.danger,
              onPressed: () => _confirmStop(context, bloc),
            ),
          ],
        ),
      ),
      TourPhase.explaining || TourPhase.finished => GmHeroPanel(
        top: GmStatusIndicator(
          label: state.isSpeaking ? '설명을 들려 드리는 중' : '설명을 다 들려 드렸어요',
          type: state.isSpeaking ? GmStatusType.info : GmStatusType.success,
          onDark: true,
        ),
        overline: overline,
        title: place.name,
        subtitle: place.meta,
        footer: GmButton(
          label: '투어 중지',
          icon: Icons.stop_rounded,
          variant: GmButtonVariant.outline,
          onPressed: () => _confirmStop(context, bloc),
        ),
      ),
      _ => GmHeroPanel(
        top: const GmStatusIndicator(
          label: '이동 중',
          type: GmStatusType.success,
          onDark: true,
        ),
        overline: overline,
        title: '${Korean.withRo(place.name)}\n가고 있어요',
        subtitle: '로봇을 따라와 주세요',
        footer: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [arrived, stop],
        ),
      ),
    };
  }
}

/// 들를 곳 진행 표시: 곳마다 짧은 막대와 이름. 지나온 곳과 지금 곳은 파랑.
class _StopSteps extends StatelessWidget {
  const _StopSteps({required this.visits, required this.current});

  final List<TourVisit> visits;
  final int current;

  static const _barHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;

    return Semantics(
      label: '${visits.length}곳 중 ${current + 1}번째',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 0; i < visits.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: AppDuration.slow,
                    height: _barHeight,
                    decoration: BoxDecoration(
                      color: i <= current
                          ? colors.primary
                          : colors.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    visits[i].place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelSmall?.copyWith(
                      color: i == current
                          ? colors.onSurface
                          : semantic.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 장소 설명: 길 찾기 도착 화면과 같은 [ExplanationView]. 마지막 줄에서는
/// [다음 장소](마지막 곳이면 [투어 마치기])를 두고, 다 읽으면 파랑으로 바뀐다.
class _Explanation extends StatelessWidget {
  const _Explanation({super.key, required this.state});

  final TourState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TourBloc>();
    final visit = state.visit!;
    return ExplanationView(
      lines: visit.lines,
      current: state.lineIndex,
      isLineDone: state.isLineDone,
      interval: visit.place.lineInterval,
      onReplay: () => bloc.add(const TourReplayRequested()),
      onNext: () => bloc.add(const TourNextLineRequested()),
      lastAction: GmButton(
        label: state.isLastStop ? '투어 마치기' : '다음 장소',
        variant: state.isSpeaking
            ? GmButtonVariant.outline
            : GmButtonVariant.primary,
        onPressed: () => bloc.add(const TourNextRequested()),
      ),
    );
  }
}

/// [투어 중지]를 모르고 눌렀을 때를 위해 한 번 더 묻는다.
Future<void> _confirmStop(BuildContext context, TourBloc bloc) async {
  final stop = await showGmConfirmDialog(
    context,
    title: '투어를 멈출까요?',
    message: '처음 화면으로 돌아가요',
    confirmLabel: '투어 중지',
  );
  if (stop) bloc.add(const TourStopRequested());
}
