import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system.dart';
import '../bloc/voice_guide_cubit.dart';
import '../bloc/voice_guide_state.dart';

/// 화면 오른쪽 위 가장자리에 두는 작은 음성 표시.
///
/// 듣는 중이면 초록 점과 '듣고 있어요'를, 명령을 알아들으면 체크와 그 말을
/// 같은 유리 알약 안에 잠깐 보여 준다. 그 밖에는 아무것도 보이지 않는다.
class VoiceIndicator extends StatelessWidget {
  const VoiceIndicator({super.key});

  static const listeningLabel = '듣고 있어요';

  static const _height = 36.0;
  static const _dotSize = 8.0;
  static const _iconSize = 16.0;

  /// 화면 모서리에서 떨어진 거리. 화면 여백 안에 들어가 본문과 겹치지 않는다.
  static const edgeInset = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    // 상태 표시줄이 보이는 기기에서도 가려지지 않게 그 아래에 둔다.
    final safe = MediaQuery.paddingOf(context);
    return Positioned(
      top: safe.top + edgeInset,
      right: safe.right + edgeInset,
      child: IgnorePointer(
        child: BlocBuilder<VoiceGuideCubit, VoiceGuideState>(
          buildWhen: (a, b) =>
              a.phase != b.phase || a.recognized != b.recognized,
          builder: (context, state) {
            final content = switch (state.phase) {
              VoicePhase.listening => const _Content(
                key: ValueKey('listening'),
                recognized: false,
                text: listeningLabel,
              ),
              VoicePhase.recognized => _Content(
                key: const ValueKey('recognized'),
                recognized: true,
                text: state.recognized!,
              ),
              _ => null,
            };
            return AnimatedSwitcher(
              duration: AppDuration.normal,
              child: content == null
                  ? const SizedBox.shrink()
                  : _Pill(child: content),
            );
          },
        ),
      ),
    );
  }
}

/// 유리 면 알약. 안의 글이 바뀌면 폭이 부드럽게 늘고 준다.
class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: VoiceIndicator._height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.glass,
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: AnimatedSize(
        duration: AppDuration.normal,
        curve: Curves.easeOutCubic,
        alignment: Alignment.centerRight,
        child: AnimatedSwitcher(duration: AppDuration.fast, child: child),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key, required this.recognized, required this.text});

  final bool recognized;
  final String text;

  @override
  Widget build(BuildContext context) {
    final success = context.appColors.success;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 점과 체크의 바깥 여백이 알약 양 끝 여백과 같아지도록 각자 크기로 둔다.
        if (recognized)
          Icon(
            Icons.check_rounded,
            size: VoiceIndicator._iconSize,
            color: success,
          )
        else
          Container(
            width: VoiceIndicator._dotSize,
            height: VoiceIndicator._dotSize,
            decoration: BoxDecoration(color: success, shape: BoxShape.circle),
          ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: context.textStyles.labelLarge?.copyWith(
            color: recognized
                ? context.colors.onSurface
                : context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
