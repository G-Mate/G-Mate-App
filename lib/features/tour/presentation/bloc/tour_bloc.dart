import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../../core/utils/korean.dart';
import '../../domain/get_tour_visits.dart';
import '../../domain/tour.dart';
import '../../domain/tour_repository.dart';

part 'tour_event.dart';
part 'tour_state.dart';

/// 투어 한 번: 들를 곳마다 이동 → 설명을 되풀이하고, 마지막 곳 뒤에 끝난다.
///
/// 설명은 한 줄씩 읽고, 한 줄을 다 읽으면 바로 다음 줄을 읽는다. 다 읽으면
/// 방문객이 [다음 장소]를 누를 때까지 기다린다.
class TourBloc extends Bloc<TourEvent, TourState> {
  TourBloc({
    required this._robot,
    required this._tours,
    required this._getVisits,
    required this.tourKey,
  }) : super(const TourState()) {
    on<TourStarted>(_onStarted);
    on<TourArrivalConfirmed>(_onArrivalConfirmed);
    on<TourNextRequested>(_onNextRequested);
    on<TourReplayRequested>(_onReplayRequested);
    on<TourRetryRequested>(_onRetryRequested);
    on<TourStopRequested>(_onStopRequested);
    on<_TourRobotEventReceived>(_onRobotEvent);
    _subscription = _robot.events.listen(
      (event) => add(_TourRobotEventReceived(event)),
    );
  }

  /// 이동 상태별로 어림한 진행 정도 (길 찾기와 같다).
  static const progressCalculating = 0.05;
  static const progressGoing = 0.4;

  /// 투어를 마칠 때 읽는 멘트.
  static const finishSpeech = '투어가 끝났어요. 함께 둘러봐 주셔서 고마워요.';

  final RobotController _robot;
  final TourRepository _tours;
  final GetTourVisits _getVisits;
  final String tourKey;
  late final StreamSubscription<RobotEvent> _subscription;

  /// 다음 곳으로 출발할 때 읽는 멘트.
  static String moveSpeech(String placeName) =>
      '${Korean.withRo(placeName)} 갈게요. 저를 따라와 주세요.';

  Future<void> _onStarted(TourStarted event, Emitter<TourState> emit) async {
    final tour = await _tours.getTour(tourKey);
    final visits = tour == null ? const <TourVisit>[] : await _getVisits(tour);
    if (tour == null || visits.isEmpty) {
      emit(state.copyWith(phase: TourPhase.notFound));
      return;
    }
    emit(state.copyWith(tour: tour, visits: visits));
    await _moveTo(0, emit);
  }

  Future<void> _moveTo(int index, Emitter<TourState> emit) async {
    final place = state.visits[index].place;
    emit(
      state.copyWith(
        phase: TourPhase.moving,
        stopIndex: index,
        lineIndex: 0,
        isSpeaking: false,
        progress: 0,
      ),
    );
    await _robot.speak(moveSpeech(place.name));
    await _robot.goTo(place.key);
  }

  /// [from]번째 줄부터 설명을 읽는다.
  void _explain(Emitter<TourState> emit, {int from = 0}) {
    emit(
      state.copyWith(
        phase: TourPhase.explaining,
        lineIndex: from,
        isSpeaking: true,
        progress: 1,
      ),
    );
    unawaited(_robot.speak(state.visit!.lines[from]));
  }

  Future<void> _onArrivalConfirmed(
    TourArrivalConfirmed event,
    Emitter<TourState> emit,
  ) async {
    if (state.phase != TourPhase.moving && state.phase != TourPhase.failed) {
      return;
    }
    await _robot.stopMovement();
    _explain(emit);
  }

  Future<void> _onNextRequested(
    TourNextRequested event,
    Emitter<TourState> emit,
  ) async {
    if (state.visits.isEmpty) return;
    if (state.isLastStop) {
      await _robot.stopMovement();
      await _robot.speak(finishSpeech);
      emit(state.copyWith(phase: TourPhase.finished, isSpeaking: false));
      return;
    }
    await _robot.stopMovement();
    await _moveTo(state.stopIndex + 1, emit);
  }

  void _onReplayRequested(TourReplayRequested event, Emitter<TourState> emit) {
    if (state.phase != TourPhase.explaining) return;
    _explain(emit);
  }

  Future<void> _onRetryRequested(
    TourRetryRequested event,
    Emitter<TourState> emit,
  ) async {
    if (state.phase != TourPhase.failed) return;
    emit(state.copyWith(phase: TourPhase.moving, progress: 0));
    await _robot.goTo(state.visit!.place.key);
  }

  Future<void> _onStopRequested(
    TourStopRequested event,
    Emitter<TourState> emit,
  ) async {
    await _robot.stopMovement();
    emit(state.copyWith(phase: TourPhase.stopped, isSpeaking: false));
  }

  void _onRobotEvent(_TourRobotEventReceived event, Emitter<TourState> emit) {
    final visit = state.visit;
    if (visit == null) return;
    switch (event.event) {
      case GoToStatusChanged(:final location, :final status)
          when location == visit.place.key && state.phase == TourPhase.moving:
        switch (status) {
          case GoToStatus.start || GoToStatus.calculating:
            emit(state.copyWith(progress: progressCalculating));
          case GoToStatus.going:
            emit(state.copyWith(progress: progressGoing));
          case GoToStatus.reposing:
            break;
          case GoToStatus.complete:
            _explain(emit);
          case GoToStatus.abort:
            emit(state.copyWith(phase: TourPhase.failed));
        }
      // 지금 줄을 다 읽으면 다음 줄을, 마지막 줄이면 읽기를 마친다.
      case TtsStatusChanged(:final text, :final status)
          when state.phase == TourPhase.explaining &&
              state.isSpeaking &&
              status != TtsStatus.started &&
              text == visit.lines[state.lineIndex]:
        final next = state.lineIndex + 1;
        if (next < visit.lines.length) {
          _explain(emit, from: next);
        } else {
          emit(state.copyWith(isSpeaking: false));
        }
      default:
        break;
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
