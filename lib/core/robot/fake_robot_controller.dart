import 'dart:async';

import 'robot_controller.dart';
import 'robot_event.dart';

/// 로봇 없이 화면과 로직을 개발하기 위한 가짜 컨트롤러.
///
/// 이동은 START → CALCULATING → GOING → COMPLETE를 [stepDelay] 간격으로 흉내 내고,
/// 저장되지 않은 장소로 가면 ABORT를 보낸다.
class FakeRobotController implements RobotController {
  FakeRobotController({
    Iterable<String> initialLocations = const [],
    this.stepDelay = const Duration(milliseconds: 500),
  }) : _locations = {...initialLocations};

  final Set<String> _locations;
  final Duration stepDelay;
  final _events = StreamController<RobotEvent>.broadcast();
  Timer? _moveTimer;

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
  Future<void> speak(String text) async {
    _events.add(TtsStatusChanged(text: text, status: TtsStatus.started));
    Timer(stepDelay, () {
      if (_events.isClosed) return;
      _events.add(TtsStatusChanged(text: text, status: TtsStatus.completed));
    });
  }

  @override
  Future<void> dispose() async {
    _moveTimer?.cancel();
    await _events.close();
  }

  void _emitGoTo(String key, GoToStatus status) {
    _events.add(GoToStatusChanged(location: key, status: status));
  }
}
