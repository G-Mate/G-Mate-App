import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../place/presentation/place_not_found.dart';
import '../../speech/presentation/bloc/voice_guide_cubit.dart';
import '../../speech/presentation/voice_guide_scope.dart';
import '../../speech/presentation/voice_scripts.dart';
import '../../speech/presentation/widgets/idle_home_timer.dart';
import 'bloc/arrival_cubit.dart';
import 'bloc/arrival_state.dart';
import 'guiding_page.dart';
import 'widgets/explanation_view.dart';
import 'widgets/keep_all_text.dart';

/// 길 찾기 - 도착·설명. 도착하면 도착 멘트와 [설명 듣기]를 보여 주고, 누르면
/// 로봇이 읽는 본 설명을 자막처럼 한 줄씩 크게 보여 준다.
///
/// 설명 부분은 학교 투어와 같은 [ExplanationView]를 쓴다.
class ArrivalPage extends StatelessWidget {
  const ArrivalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 도착 멘트를 읽은 뒤 누르지 않으면 '설명 듣기'와 '마침'을 말할 수 있다고
    // 안내한다. 설명을 듣기 시작하면 더 안내하지 않는다.
    return VoiceGuideScope(
      onCommand: (context, command) {
        final cubit = context.read<ArrivalCubit>();
        if (command == VoiceScripts.listenCommand) cubit.listen();
        if (command == VoiceScripts.doneCommand) context.go(AppRoutes.home);
      },
      child: BlocListener<ArrivalCubit, ArrivalState>(
        listenWhen: (a, b) => a.isLoading && !b.isLoading,
        listener: (context, state) {
          if (state.hasDescription) {
            context.read<VoiceGuideCubit>().start(VoiceScripts.arrival);
          }
        },
        // 도착 멘트를 다 읽었거나 본 설명 마지막 줄까지 읽은 뒤([마침]이
        // 보일 때) 아무 명령이 없으면 홈으로 돌아간다.
        child: BlocSelector<ArrivalCubit, ArrivalState, bool>(
          selector: (s) =>
              !s.isLoading &&
              s.place != null &&
              !s.isSpeaking &&
              (!s.isListening || !s.hasNext),
          builder: (context, isFinished) =>
              IdleHomeTimer(active: isFinished, child: _content()),
        ),
      ),
    );
  }

  Widget _content() {
    return BlocBuilder<ArrivalCubit, ArrivalState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final place = state.place;
        if (place == null) return const PlaceNotFound();

        final cubit = context.read<ArrivalCubit>();
        final lines = state.lines;

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
              : ExplanationView(
                  lines: lines,
                  current: state.lineIndex,
                  isLineDone: state.isLineDone,
                  interval: place.lineInterval,
                  onReplay: cubit.replay,
                  onNext: cubit.next,
                  // 마지막 줄에서는 [마침]으로 처음 화면으로 돌아간다.
                  lastAction: GmButton(
                    label: '마침',
                    variant: state.isSpeaking
                        ? GmButtonVariant.outline
                        : GmButtonVariant.primary,
                    onPressed: () => context.go(AppRoutes.home),
                  ),
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
