import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system.dart';
import '../bloc/voice_guide_cubit.dart';
import '../bloc/voice_guide_state.dart';

/// 화면 오른쪽 위 가장자리에 두는 작은 음성 표시.
///
/// 듣는 중이면 작은 동그라미를 켜고, 명령을 알아들으면 그 말을 동그라미 옆에
/// 잠깐 보여 준다. 그 밖에는 아무것도 보이지 않는다.
class VoiceIndicator extends StatelessWidget {
  const VoiceIndicator({super.key});

  static const dotSize = 12.0;
  static const _iconSize = 18.0;

  /// 화면 모서리에서 떨어진 거리. 화면 여백 안에 들어가 본문과 겹치지 않는다.
  static const edgeInset = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceGuideCubit, VoiceGuideState>(
      buildWhen: (a, b) => a.phase != b.phase || a.recognized != b.recognized,
      builder: (context, state) {
        final child = switch (state.phase) {
          VoicePhase.listening => const _Dot(key: ValueKey('listening')),
          VoicePhase.recognized => _Recognized(
            key: const ValueKey('recognized'),
            text: state.recognized!,
          ),
          _ => const SizedBox.shrink(),
        };
        // 상태 표시줄이 보이는 기기에서도 가려지지 않게 그 아래에 둔다.
        final safe = MediaQuery.paddingOf(context);
        return Positioned(
          top: safe.top + edgeInset,
          right: safe.right + edgeInset,
          child: IgnorePointer(
            child: AnimatedSwitcher(
              duration: AppDuration.normal,
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topRight,
                children: [...previous, ?current],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '듣는 중',
      child: Container(
        width: VoiceIndicator.dotSize,
        height: VoiceIndicator.dotSize,
        decoration: BoxDecoration(
          color: context.appColors.success,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// 알아들은 말. 동그라미가 글자를 품은 알약 모양으로 늘어난 모습이다.
class _Recognized extends StatelessWidget {
  const _Recognized({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.appColors.successContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_rounded,
            size: VoiceIndicator._iconSize,
            color: context.appColors.success,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            text,
            style: context.textStyles.labelLarge?.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
