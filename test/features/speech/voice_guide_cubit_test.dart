import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/features/speech/data/in_memory_speech_settings_repository.dart';
import 'package:g_mate/features/speech/domain/speech_settings.dart';
import 'package:g_mate/features/speech/domain/voice_script.dart';
import 'package:g_mate/features/speech/presentation/bloc/voice_guide_cubit.dart';
import 'package:g_mate/features/speech/presentation/bloc/voice_guide_state.dart';

void main() {
  const step = Duration(milliseconds: 100);
  const listen = Duration(seconds: 2);
  const wait = Duration(seconds: 3);
  const script = VoiceScript(
    intro: [
      VoiceLine('어디로 갈까요?'),
      VoiceLine('카드', cue: 'flash'),
    ],
    hint: '장소 목록이라고 말씀해 주세요.',
    commands: [
      VoiceCommand('list', ['장소 목록']),
    ],
  );

  late FakeRobotController robot;
  late List<String> spoken;
  late List<String> asked;
  late VoiceGuideCubit cubit;

  void setUpAll(FakeAsync async) {
    robot = FakeRobotController(stepDelay: step, listenDuration: listen);
    spoken = [];
    asked = [];
    robot.events.listen((e) {
      if (e is TtsStatusChanged && e.status == TtsStatus.started) {
        spoken.add(e.text);
      }
    });
    cubit = VoiceGuideCubit(
      robot: _AskRecorder(robot, asked),
      settings: InMemorySpeechSettingsRepository()
        ..save(const SpeechSettings(commandWait: wait)),
    );
  }

  test('글을 차례로 읽고, 기다린 뒤 할 수 있는 말을 안내하고 듣는다', () {
    fakeAsync((async) {
      setUpAll(async);
      cubit.start(script);
      async.elapse(step * 3);
      expect(spoken, ['어디로 갈까요?', '카드']);
      expect(cubit.state.cue, 'flash');
      expect(cubit.state.cueCount, 1);
      expect(cubit.state.phase, VoicePhase.waiting);

      async.elapse(wait);
      expect(asked, ['장소 목록이라고 말씀해 주세요.']);
      expect(cubit.state.phase, VoicePhase.listening);

      async.elapse(step);
      robot.hearSpeech('장소 목록 알려 줘');
      async.flushMicrotasks();
      expect(cubit.state.command, 'list');
      expect(cubit.state.commandCount, 1);
      expect(cubit.state.phase, VoicePhase.idle);
      cubit.close();
      robot.dispose();
    });
  });

  test('대답이 없으면 한 번 더 안내하고, 그래도 없으면 그만둔다', () {
    fakeAsync((async) {
      setUpAll(async);
      cubit.start(script);
      async.elapse(step * 3 + wait + step + listen);
      expect(asked, hasLength(1));
      async.elapse(wait + step + listen);
      expect(asked, hasLength(2));
      async.elapse(wait * 3);
      expect(asked, hasLength(2));
      expect(cubit.state.phase, VoicePhase.idle);
      cubit.close();
      robot.dispose();
    });
  });

  test('알아듣지 못한 말이면 바로 다시 안내한다', () {
    fakeAsync((async) {
      setUpAll(async);
      cubit.start(script);
      async.elapse(step * 3 + wait + step);
      robot.hearSpeech('배고파');
      async.flushMicrotasks();
      expect(asked, [
        '장소 목록이라고 말씀해 주세요.',
        '${VoiceGuideCubit.notUnderstood} 장소 목록이라고 말씀해 주세요.',
      ]);
      expect(cubit.state.command, isNull);
      cubit.close();
      robot.dispose();
    });
  });

  test('화면을 누르면 읽던 말을 멈추고 더 안내하지 않는다', () {
    fakeAsync((async) {
      setUpAll(async);
      cubit.start(script);
      async.elapse(step ~/ 2);
      cubit.interact();
      async.elapse(wait * 3);
      expect(spoken, ['어디로 갈까요?']);
      expect(asked, isEmpty);
      expect(cubit.state.phase, VoicePhase.idle);

      // 다시 읽으라고 하면 읽고, 기다린 뒤 안내한다.
      cubit.say('과학실, 컴퓨터실이 있어요.');
      async.elapse(step + wait);
      expect(spoken, contains('과학실, 컴퓨터실이 있어요.'));
      expect(asked, hasLength(1));
      cubit.close();
      robot.dispose();
    });
  });

  test('묻지 않았어도 temi를 불러 한 명령은 알아듣는다', () {
    fakeAsync((async) {
      setUpAll(async);
      cubit.start(
        const VoiceScript(
          commands: [
            VoiceCommand('stop', ['안내 중지']),
          ],
        ),
      );
      async.flushMicrotasks();
      robot.hearSpeech('안내 중지');
      async.flushMicrotasks();
      expect(cubit.state.command, 'stop');
      cubit.close();
      robot.dispose();
    });
  });
}

/// 물어본 말([FakeRobotController.askQuestion])을 기록하는 로봇.
class _AskRecorder extends FakeRobotController {
  _AskRecorder(this._robot, this._asked);

  final FakeRobotController _robot;
  final List<String> _asked;

  @override
  Stream<RobotEvent> get events => _robot.events;

  @override
  Future<void> speak(String text) => _robot.speak(text);

  @override
  Future<void> cancelSpeech() => _robot.cancelSpeech();

  @override
  Future<void> askQuestion(String text) {
    _asked.add(text);
    return _robot.askQuestion(text);
  }

  @override
  Future<void> finishConversation() => _robot.finishConversation();
}
