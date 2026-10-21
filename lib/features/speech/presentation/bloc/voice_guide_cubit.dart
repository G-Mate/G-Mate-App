import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../domain/speech_settings_repository.dart';
import '../../domain/voice_script.dart';
import 'voice_guide_state.dart';

/// 화면 하나의 음성 안내와 음성 명령.
///
/// [start]로 받은 대본의 글을 읽고, 관리 모드에서 정한 시간 동안 방문객이
/// 화면을 누르지 않으면 할 수 있는 말을 안내한 뒤 듣는다. 알아들은 명령은
/// [VoiceGuideState.command]로 화면에 알리고, 화면이 그 일을 한다.
/// 방문객이 화면을 누르면([interact]) 읽던 말과 듣기를 멈춘다.
class VoiceGuideCubit extends Cubit<VoiceGuideState> {
  VoiceGuideCubit({
    required this._robot,
    required this._settings,
    this.commandDelay = defaultCommandDelay,
  }) : super(const VoiceGuideState());

  /// 알아들은 명령을 보여 준 뒤 수행하기까지 기다리는 시간.
  static const defaultCommandDelay = Duration(milliseconds: 1200);

  /// TTS 완료 이벤트가 오지 않을 때 다음으로 넘어가기까지 기다리는 시간.
  static const speakTimeout = Duration(seconds: 30);

  static const notUnderstood = '잘 알아듣지 못했어요.';

  final RobotController _robot;
  final SpeechSettingsRepository _settings;
  final Duration commandDelay;
  StreamSubscription<RobotEvent>? _subscription;
  Timer? _hintTimer;
  Timer? _commandTimer;

  /// 지금 읽는 말이 끝나기를 기다리는 것들.
  Completer<void>? _speech;
  StreamSubscription<RobotEvent>? _speechSubscription;
  Timer? _speechTimer;

  VoiceScript _script = const VoiceScript();
  Duration? _commandWait;
  int _hintsLeft = 0;

  /// 물어본 뒤 로봇이 실제로 듣기 시작했는지. 그 뒤에 온 대화 끝(idle)만 대답 없음으로 본다.
  bool _micOpened = false;

  /// 물어본 뒤 알아듣지 못한 말이 들렸는지. 듣기가 끝나면 바로 다시 묻는다.
  bool _misheard = false;

  /// 새로 읽기 시작하거나 멈출 때마다 늘린다. 이전 차례의 남은 일은 버린다.
  int _session = 0;

  /// 대본을 바꾸고 처음부터 읽는다.
  Future<void> start(VoiceScript script) async {
    _subscription ??= _robot.events.listen(_onRobotEvent);
    final session = _next();
    _script = script;
    _hintsLeft = script.hintRepeats;
    _commandWait ??= (await _settings.load()).commandWait;
    for (final line in script.intro) {
      if (session != _session || isClosed) return;
      if (line.cue != null) {
        emit(state.copyWith(cue: line.cue, cueCount: state.cueCount + 1));
      }
      await _say(line.text, session);
    }
    _scheduleHint(session);
  }

  /// [text]를 읽은 뒤 다시 기다렸다가 할 수 있는 말을 안내한다.
  /// 방문객이 카드를 넘기거나 장소 목록을 물었을 때 쓴다.
  Future<void> say(String text) async {
    final session = _next();
    _hintsLeft = _script.hintRepeats;
    await _say(text, session);
    _scheduleHint(session);
  }

  /// 방문객이 화면을 눌렀다. 읽던 말과 듣기를 멈추고 더 안내하지 않는다.
  void interact() {
    _commandTimer?.cancel();
    if (state.phase == VoicePhase.idle) return;
    final wasListening = state.phase == VoicePhase.listening;
    _next();
    unawaited(_robot.cancelSpeech());
    if (wasListening) unawaited(_robot.finishConversation());
    emit(state.copyWith(phase: VoicePhase.idle));
  }

  /// 다른 화면이 위에 덮였다. 더 안내하지 않고, 듣던 것만 멈춘다.
  /// (새 화면이 읽기 시작한 말은 끊지 않는다.)
  void pause() {
    if (state.phase == VoicePhase.idle) return;
    final wasListening = state.phase == VoicePhase.listening;
    _next();
    if (wasListening) unawaited(_robot.finishConversation());
    emit(state.copyWith(phase: VoicePhase.idle));
  }

  /// 지금 차례를 끝내고 새 차례 번호를 돌려준다.
  int _next() {
    _hintTimer?.cancel();
    _endSpeech();
    return ++_session;
  }

  /// [text]를 읽고, 다 읽거나 멈추거나 [speakTimeout]이 지나면 끝난다.
  Future<void> _say(String text, int session) {
    _endSpeech();
    if (isClosed) return Future.value();
    emit(state.copyWith(phase: VoicePhase.speaking));
    final done = _speech = Completer<void>();
    _speechSubscription = _robot.events.listen((e) {
      if (e is TtsStatusChanged &&
          e.text == text &&
          e.status != TtsStatus.started) {
        _endSpeech();
      }
    });
    _speechTimer = Timer(speakTimeout, _endSpeech);
    unawaited(_robot.speak(text));
    return done.future;
  }

  void _endSpeech() {
    _speechTimer?.cancel();
    unawaited(_speechSubscription?.cancel());
    _speechSubscription = null;
    final done = _speech;
    _speech = null;
    if (done != null && !done.isCompleted) done.complete();
  }

  void _scheduleHint(int session) {
    if (session != _session || isClosed) return;
    final hint = _script.hint;
    if (hint == null || _hintsLeft <= 0) {
      emit(state.copyWith(phase: VoicePhase.idle));
      return;
    }
    emit(state.copyWith(phase: VoicePhase.waiting));
    final wait = _script.waitBeforeHint ?? _commandWait!;
    _hintTimer = Timer(wait, () => _ask(hint));
  }

  void _ask(String text) {
    if (isClosed) return;
    _hintsLeft--;
    _micOpened = false;
    _misheard = false;
    emit(state.copyWith(phase: VoicePhase.listening));
    unawaited(_robot.askQuestion(text));
  }

  void _onRobotEvent(RobotEvent event) {
    if (isClosed) return;
    switch (event) {
      case AsrResultReceived(:final text):
        final command = _script.match(text);
        if (command != null) {
          // 알아들은 말을 잠깐 보여 준 뒤 명령을 수행한다. 그사이 화면을
          // 누르면 수행하지 않는다. 화면 흐름이 바뀌어 새 대본을 읽기
          // 시작해도(예: 이동 중 도착) 방문객이 한 말이므로 수행한다.
          _next();
          _commandTimer?.cancel();
          if (state.phase == VoicePhase.listening) {
            unawaited(_robot.finishConversation());
          }
          emit(
            state.copyWith(
              phase: VoicePhase.recognized,
              recognized: command.phrases.first,
            ),
          );
          _commandTimer = Timer(commandDelay, () {
            if (isClosed) return;
            emit(
              state.copyWith(
                phase: state.phase == VoicePhase.recognized
                    ? VoicePhase.idle
                    : null,
                command: command.id,
                commandCount: state.commandCount + 1,
              ),
            );
          });
        } else if (state.phase == VoicePhase.listening) {
          _misheard = true;
        }
      case ConversationStatusChanged(status: ConversationStatus.listening)
          when state.phase == VoicePhase.listening:
        _micOpened = true;
      case ConversationStatusChanged(status: ConversationStatus.idle)
          when state.phase == VoicePhase.listening && _micOpened:
        final hint = _script.hint;
        if (_misheard) {
          // 엉뚱한 말이 들렸으면 바로 한 번 더 안내하고, 횟수를 다 썼으면 알린다.
          if (hint != null && _hintsLeft > 0) {
            _ask('$notUnderstood $hint');
          } else {
            final session = _next();
            unawaited(
              _say(notUnderstood, session).then((_) {
                if (session == _session && !isClosed) {
                  emit(state.copyWith(phase: VoicePhase.idle));
                }
              }),
            );
          }
        } else {
          // 아무 말이 없으면 다시 기다렸다가 한 번 더 안내한다.
          _scheduleHint(_next());
        }
      default:
        break;
    }
  }

  @override
  Future<void> close() async {
    final wasListening = state.phase == VoicePhase.listening;
    _next();
    _commandTimer?.cancel();
    if (wasListening) unawaited(_robot.finishConversation());
    await _subscription?.cancel();
    return super.close();
  }
}
