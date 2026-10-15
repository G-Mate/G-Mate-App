import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../../core/utils/korean.dart';
import '../../place/presentation/place_not_found.dart';
import '../../speech/presentation/bloc/voice_guide_cubit.dart';
import '../../speech/presentation/voice_guide_scope.dart';
import '../../speech/presentation/voice_scripts.dart';
import 'bloc/guide_bloc.dart';
import 'widgets/floor_map.dart';

/// 길 찾기 - 이동 중. 왼쪽에 어디로 가는지 크게, 오른쪽에 층 지도.
///
/// 도착하면 도착·설명으로, [안내 중지]를 누르면 홈으로 간다.
class GuidingPage extends StatelessWidget {
  const GuidingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 장소 확인에서 push로 들어오므로, 안내 중에는 뒤로 가기를 막고
    // [안내 중지]로만 나간다.
    return PopScope(
      canPop: false,
      // 출발 멘트 뒤에 '안내 중지'로 멈출 수 있다고 알리고, 그 말을 들으면 멈춘다.
      child: VoiceGuideScope(
        onCommand: (context, command) {
          if (command == VoiceScripts.stopCommand) {
            context.read<GuideBloc>().add(const GuideStopRequested());
          }
        },
        child: BlocListener<GuideBloc, GuideState>(
          listenWhen: (a, b) =>
              a.phase == GuidePhase.loading && b.phase == GuidePhase.moving,
          listener: (context, _) =>
              context.read<VoiceGuideCubit>().start(VoiceScripts.guiding),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    return BlocConsumer<GuideBloc, GuideState>(
      listenWhen: (prev, next) => prev.phase != next.phase,
      listener: (context, state) {
        switch (state.phase) {
          case GuidePhase.arrived:
            context.go(AppRoutes.arrival(state.place!.key));
          case GuidePhase.stopped:
            context.go(AppRoutes.home);
          default:
            break;
        }
      },
      builder: (context, state) {
        final place = state.place;
        if (state.phase == GuidePhase.notFound) return const PlaceNotFound();
        if (place == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final failed = state.phase == GuidePhase.failed;
        final bloc = context.read<GuideBloc>();

        return GmSplitLayout(
          hero: GmHeroPanel(
            top: GmStatusIndicator(
              label: failed ? '이동 멈춤' : '이동 중',
              type: failed ? GmStatusType.warning : GmStatusType.success,
              onDark: true,
            ),
            overline: '${Korean.withRo(place.meta)} 가는 중',
            title: failed
                ? '${Korean.withRo(place.name)}\n가지 못했어요'
                : '${Korean.withRo(place.name)}\n안내하고 있어요',
            subtitle: failed ? '길이 막혔을 수 있어요' : '로봇을 따라와 주세요',
            footer: failed
                ? Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      GmButton(
                        label: '다시 시도',
                        icon: Icons.replay_rounded,
                        onPressed: () => bloc.add(const GuideRetryRequested()),
                      ),
                      GmButton(
                        label: '처음으로',
                        icon: Icons.home_outlined,
                        variant: GmButtonVariant.outline,
                        onPressed: () => bloc.add(const GuideStopRequested()),
                      ),
                    ],
                  )
                // 도착했는데 로봇이 완료를 못 알리면 [안내 완료]로 직접 넘긴다.
                : Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      GmButton(
                        label: '안내 완료',
                        icon: Icons.check_rounded,
                        variant: GmButtonVariant.secondary,
                        onPressed: () =>
                            bloc.add(const GuideCompleteRequested()),
                      ),
                      GmButton(
                        label: '안내 중지',
                        icon: Icons.stop_rounded,
                        variant: GmButtonVariant.danger,
                        onPressed: () async {
                          if (await confirmGuideStop(context)) {
                            bloc.add(const GuideStopRequested());
                          }
                        },
                      ),
                    ],
                  ),
          ),
          child: FloorMap(
            floor: place.floor,
            destination: place.name,
            progress: state.progress,
          ),
        );
      },
    );
  }
}

/// [안내 중지]를 모르고 눌렀을 때를 위해 한 번 더 묻는다.
Future<bool> confirmGuideStop(BuildContext context) => showGmConfirmDialog(
  context,
  title: '안내를 멈출까요?',
  message: '처음 화면으로 돌아가요',
  confirmLabel: '안내 중지',
);
