import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../place/domain/place_repository.dart';
import 'arrival_state.dart';

/// 도착·설명: 도착 멘트만 먼저 읽고, 방문객이 [설명 듣기]를 누르면 본 설명을
/// 한 줄씩 읽으며 화면을 넘긴다. (학교 투어는 `TourBloc`이 바로 읽는다.)
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

  /// 읽을 문장 차례 (도착 멘트 한 줄, 또는 본 설명).
  List<String> _queue = const [];
  int _cursor = 0;

  Future<void> start() async {
    _subscription = _robot.events.listen(_onRobotEvent);
    final place = await _places.getPlace(placeKey);
    emit(state.copyWith(isLoading: false, place: place));
    if (place == null) return;
    _read([place.speech.arrival]);
  }

  /// [설명 듣기]: 본 설명을 첫 줄부터 읽는다. 본 설명이 없으면 아무 일도 없다.
  void listen() {
    if (!state.hasDescription) return;
    emit(state.copyWith(isListening: true));
    _read(state.lines);
  }

  /// [다시 듣기]: 본 설명을 첫 줄부터 다시 읽는다.
  void replay() => listen();

  /// [다음]: 기다리지 않고 다음 줄을 읽는다. 마지막 줄이면 아무 일도 없다.
  void next() {
    if (!state.isListening || !state.hasNext) return;
    _cursor = state.lineIndex + 1;
    _speakCurrent();
  }

  void _read(List<String> queue) {
    _queue = queue;
    _cursor = 0;
    _speakCurrent();
  }

  void _speakCurrent() {
    _advanceTimer?.cancel();
    emit(
      state.copyWith(lineIndex: _cursor, isSpeaking: true, isLineDone: false),
    );
    unawaited(_robot.speak(_queue[_cursor]));
  }

  void _onRobotEvent(RobotEvent event) {
    if (event is! TtsStatusChanged || !state.isSpeaking) return;
    if (event.status == TtsStatus.started) return;
    if (_cursor >= _queue.length || event.text != _queue[_cursor]) return;

    if (_cursor + 1 >= _queue.length) {
      emit(state.copyWith(isSpeaking: false));
      return;
    }
    // 본 설명 줄 사이에는 정한 시간만큼 쉰다.
    emit(state.copyWith(isLineDone: true));
    _advanceTimer = Timer(state.place!.lineInterval, () {
      _cursor++;
      _speakCurrent();
    });
  }

  @override
  Future<void> close() async {
    _advanceTimer?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
