import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../bloc/voice_guide_cubit.dart';
import '../bloc/voice_guide_state.dart';

/// 안내를 마친 화면([마침]·[처음으로]가 보이는 화면)에서 방문객이 아무것도
/// 하지 않으면 홈으로 돌아간다.
///
/// [active]인 동안 로봇이 말하거나 듣지 않는 채로 [delay]가 지나면 홈으로 간다.
/// 화면을 누르거나 음성 안내가 다시 말하기·듣기를 시작하면 처음부터 다시 센다.
/// [VoiceGuideScope] 안에 둔다.
class IdleHomeTimer extends StatefulWidget {
  const IdleHomeTimer({
    super.key,
    required this.active,
    this.delay = defaultDelay,
    required this.child,
  });

  /// 아무 명령이 없을 때 홈으로 돌아가기까지 기다리는 시간.
  static const defaultDelay = Duration(seconds: 10);

  /// 안내를 마친 상태인지. false면 세지 않는다.
  final bool active;
  final Duration delay;
  final Widget child;

  @override
  State<IdleHomeTimer> createState() => _IdleHomeTimerState();
}

class _IdleHomeTimerState extends State<IdleHomeTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restart());
  }

  @override
  void didUpdateWidget(IdleHomeTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _restart();
  }

  /// 조건이 맞으면 처음부터 다시 세고, 아니면 멈춘다.
  void _restart() {
    _timer?.cancel();
    _timer = null;
    if (!mounted || !widget.active) return;
    final phase = context.read<VoiceGuideCubit>().state.phase;
    if (phase != VoicePhase.idle) return;
    _timer = Timer(widget.delay, _goHome);
  }

  void _goHome() {
    // 다른 화면이 위에 덮여 있으면 그 화면을 두고 돌아가지 않는다.
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? true)) return;
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceGuideCubit, VoiceGuideState>(
      listenWhen: (a, b) => a.phase != b.phase,
      listener: (_, _) => _restart(),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _restart(),
        child: widget.child,
      ),
    );
  }
}
