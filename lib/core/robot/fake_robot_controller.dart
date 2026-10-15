import 'dart:async';

import 'robot_controller.dart';
import 'robot_event.dart';

/// 로봇 없이 화면과 로직을 개발하기 위한 가짜 컨트롤러.
///
/// 이동은 START → CALCULATING → GOING → COMPLETE를 [stepDelay] 간격으로 흉내 내고,
/// 저장되지 않은 장소로 가면 ABORT를 보낸다. 말하기는 [stepDelay] 뒤에 끝난다.
/// 음성 인식은 [hearSpeech]로 방문객의 말을 흉내 낸다.
class FakeRobotController implements RobotController {
  FakeRobotController({
    Iterable<String> initialLocations = const [],
    this.stepDelay = const Duration(milliseconds: 500),
    this.listenDuration = const Duration(seconds: 5),
  }) : _locations = {...initialLocations};

  final Set<String> _locations;
  final Duration stepDelay;

  /// [askQuestion] 뒤에 아무 말이 없으면 듣기를 그만두기까지의 시간.
  final Duration listenDuration;

  final _events = StreamController<RobotEvent>.broadcast();
  Timer? _moveTimer;

  /// 아직 끝나지 않은 말과 그 말을 끝내는 타이머.
  final _speaking = <(String, Timer)>[];
  Timer? _listenTimer;

  /// [askQuestion]으로 읽는 중인 말. 다 읽으면 듣기 시작한다.
  (String, Timer)? _asking;

  @override
  Stream<RobotEvent> get events => _events.stream;

  @override
  Future<bool> isReady() async => true;

  @override
  Future<List<String>> getLocations() async => _locations.toList()..sort();

  @override
  Future<void> saveLocation(String key) async {
    _locations.add(key);
    _events.add(LocationsUpdated(await getLocations()));
  }

  @override
  Future<void> deleteLocation(String key) async {
    _locations.remove(key);
    _events.add(LocationsUpdated(await getLocations()));
  }

  @override
  Future<void> goTo(String key) async {
    _moveTimer?.cancel();
    _emitGoTo(key, GoToStatus.start);
    if (!_locations.contains(key)) {
      _emitGoTo(key, GoToStatus.abort);
      return;
    }
    const steps = [
      GoToStatus.calculating,
      GoToStatus.going,
      GoToStatus.complete,
    ];
    var index = 0;
    _moveTimer = Timer.periodic(stepDelay, (timer) {
      _emitGoTo(key, steps[index++]);
      if (index == steps.length) timer.cancel();
    });
  }

  @override
  Future<void> stopMovement() async {
    _moveTimer?.cancel();
  }

  @override
  Future<void> speak(String text) async => _speak(text);

  (String, Timer) _speak(String text, {void Function()? then}) {
    _events.add(TtsStatusChanged(text: text, status: TtsStatus.started));
    late final (String, Timer) entry;
    entry = (
      text,
      Timer(stepDelay, () {
        _speaking.remove(entry);
        if (_events.isClosed) return;
        _events.add(TtsStatusChanged(text: text, status: TtsStatus.completed));
        then?.call();
      }),
    );
    _speaking.add(entry);
    return entry;
  }

  @override
  Future<void> cancelSpeech() async {
    _asking = null;
    for (final (text, timer) in [..._speaking]) {
      timer.cancel();
      _events.add(TtsStatusChanged(text: text, status: TtsStatus.cancelled));
    }
    _speaking.clear();
  }

  @override
  Future<void> askQuestion(String text) async {
    _asking = _speak(
      text,
      then: () {
        _emitConversation(ConversationStatus.listening);
        _listenTimer?.cancel();
        _listenTimer = Timer(listenDuration, () {
          _emitConversation(ConversationStatus.idle);
        });
      },
    );
  }

  @override
  Future<void> finishConversation() async {
    _cancelAsk();
    if (_listenTimer?.isActive ?? false) {
      _listenTimer!.cancel();
      _emitConversation(ConversationStatus.idle);
    }
  }

  /// 방문객이 [text]라고 말한 것처럼 알아들은 결과를 보낸다.
  void hearSpeech(String text) {
    _cancelAsk();
    _listenTimer?.cancel();
    _events.add(AsrResultReceived(text));
    _emitConversation(ConversationStatus.idle);
  }

  /// 묻는 말을 아직 읽고 있으면 멈춰서 듣기로 넘어가지 않게 한다.
  void _cancelAsk() {
    final asking = _asking;
    _asking = null;
    if (asking != null && _speaking.remove(asking)) {
      asking.$2.cancel();
      _events.add(
        TtsStatusChanged(text: asking.$1, status: TtsStatus.cancelled),
      );
    }
  }

  @override
  Future<void> dispose() async {
    _moveTimer?.cancel();
    _listenTimer?.cancel();
    for (final (_, timer) in _speaking) {
      timer.cancel();
    }
    await _events.close();
  }

  void _emitGoTo(String key, GoToStatus status) {
    _events.add(GoToStatusChanged(location: key, status: status));
  }

  void _emitConversation(ConversationStatus status) {
    if (_events.isClosed) return;
    _events.add(ConversationStatusChanged(status));
  }
}
