import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../place/domain/place_repository.dart';
import 'arrival_state.dart';

/// 도착·설명: 도착 멘트를 읽고, 본 설명을 한 줄씩 읽으며 화면을 넘긴다.
///
/// 한 줄을 다 읽었다는 TTS 완료 이벤트를 받으면 장소의 [Place.lineInterval]만큼
/// 기다렸다가 다음 줄로 넘어간다. [next]를 누르면 기다리지 않고 바로 넘어간다.
class ArrivalCubit extends Cubit<ArrivalState> {
  ArrivalCubit({
    required this._robot,
    required this._places,
    required this.placeKey,
  }) : super(const ArrivalState());

  final RobotController _robot;
  final PlaceRepository _places;
  final String placeKey;
  StreamSubscription<RobotEvent>? _subscription;

  /// 다음 줄로 저절로 넘기는 타이머.
  Timer? _advanceTimer;

  /// 읽을 문장 차례. 앞에 도착 멘트가 붙어 있을 수 있다.
  List<String> _queue = const [];
  int _cursor = 0;

  /// 큐의 [_cursor]번째가 몇 번째 줄인지 맞추기 위한 차이 (도착 멘트가 있으면 1).
  int _offset = 0;

  Future<void> start() async {
    _subscription = _robot.events.listen(_onRobotEvent);
    final place = await _places.getPlace(placeKey);
    emit(state.copyWith(isLoading: false, place: place));
    if (place == null) return;
    final description = place.speech.descriptionLines;
    _read([place.speech.arrival, ...description], offset: 1);
  }

  /// [다시 듣기]: 본 설명을 첫 줄부터 다시 읽는다.
  void replay() => _read(state.lines, offset: 0);

  /// [다음]: 기다리지 않고 다음 줄을 읽는다. 마지막 줄이면 아무 일도 없다.
  void next() {
    if (!state.hasNext) return;
    _cursor = state.lineIndex + 1 + _offset;
    _speakCurrent();
  }

  void _read(List<String> queue, {required int offset}) {
    _queue = queue;
    _cursor = 0;
    // 본 설명이 비어 있으면 도착 멘트가 곧 첫 줄이다.
    _offset = state.place!.speech.descriptionLines.isEmpty ? 0 : offset;
    _speakCurrent();
  }

  void _speakCurrent() {
    _advanceTimer?.cancel();
    final lineIndex = (_cursor - _offset).clamp(0, state.lines.length - 1);
    emit(state.copyWith(lineIndex: lineIndex, isSpeaking: true));
    unawaited(_robot.speak(_queue[_cursor]));
  }

  void _onRobotEvent(RobotEvent event) {
    if (event is! TtsStatusChanged || !state.isSpeaking) return;
    if (event.status == TtsStatus.started) return;
    if (_cursor >= _queue.length || event.text != _queue[_cursor]) return;

    final isLast = _cursor + 1 >= _queue.length;
    if (isLast) {
      emit(state.copyWith(isSpeaking: false));
      return;
    }
    // 도착 멘트 다음에는 바로 첫 줄로, 본 설명 줄 사이에는 정한 시간만큼 쉰다.
    if (_cursor < _offset) {
      _cursor++;
      _speakCurrent();
    } else {
      _advanceTimer = Timer(state.place!.lineInterval, () {
        _cursor++;
        _speakCurrent();
      });
    }
  }

  @override
  Future<void> close() async {
    _advanceTimer?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
