import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/voice_guide_cubit.dart';
import 'bloc/voice_guide_state.dart';

/// 화면을 [VoiceGuideCubit]에 잇는다.
///
/// 화면 어디든 누르면 음성 안내를 멈추고, 알아들은 명령은 [onCommand]로,
/// 대본의 신호(예: 카드 반짝임)는 [onCue]로 넘긴다.
class VoiceGuideScope extends StatelessWidget {
  const VoiceGuideScope({
    super.key,
    required this.onCommand,
    this.onCue,
    required this.child,
  });

  final void Function(BuildContext context, String command) onCommand;
  final void Function(String cue)? onCue;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 다른 화면이 위에 덮이면(push) 이 화면의 음성 안내를 멈춘다.
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
      final voice = context.read<VoiceGuideCubit>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!voice.isClosed) voice.pause();
      });
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<VoiceGuideCubit, VoiceGuideState>(
          listenWhen: (a, b) => a.commandCount != b.commandCount,
          // 뒤에 깔린 화면(push로 덮인 화면)도 말을 듣고 있으므로, 맨 위 화면만
          // 명령을 따른다.
          listener: (context, state) {
            if (ModalRoute.of(context)?.isCurrent ?? true) {
              onCommand(context, state.command!);
            }
          },
        ),
        if (onCue != null)
          BlocListener<VoiceGuideCubit, VoiceGuideState>(
            listenWhen: (a, b) => a.cueCount != b.cueCount,
            listener: (context, state) => onCue!(state.cue!),
          ),
      ],
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => context.read<VoiceGuideCubit>().interact(),
        child: child,
      ),
    );
  }
}
