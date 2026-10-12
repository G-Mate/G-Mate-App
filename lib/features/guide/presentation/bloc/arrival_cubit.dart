import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../place/domain/place_repository.dart';
import 'arrival_state.dart';

/// 도착·설명: 도착 멘트를 읽고, 본 설명을 한 줄씩 읽으며 화면을 넘긴다.
///
/// 한 줄을 다 읽었다는 TTS 완료 이벤트를 받으면 다음 줄로 넘어간다.
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

  void _read(List<String> queue, {required int offset}) {
    _queue = queue;
    _cursor = 0;
    // 본 설명이 비어 있으면 도착 멘트가 곧 첫 줄이다.
    _offset = state.place!.speech.descriptionLines.isEmpty ? 0 : offset;
    _speakCurrent();
  }

  void _speakCurrent() {
    final lineIndex = (_cursor - _offset).clamp(0, state.lines.length - 1);
    emit(state.copyWith(lineIndex: lineIndex, isSpeaking: true));
    unawaited(_robot.speak(_queue[_cursor]));
  }

  void _onRobotEvent(RobotEvent event) {
    if (event is! TtsStatusChanged || !state.isSpeaking) return;
    if (event.status == TtsStatus.started) return;
    if (_cursor >= _queue.length || event.text != _queue[_cursor]) return;
    _cursor++;
    if (_cursor < _queue.length) {
      _speakCurrent();
    } else {
      emit(state.copyWith(isSpeaking: false));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
