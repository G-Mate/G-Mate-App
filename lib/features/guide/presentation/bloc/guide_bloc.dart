import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../place/domain/place.dart';
import '../../../place/domain/place_repository.dart';

part 'guide_event.dart';
part 'guide_state.dart';

/// 길 안내 한 번: 출발 멘트 → 이동 → 도착(또는 실패·중지).
class GuideBloc extends Bloc<GuideEvent, GuideState> {
  GuideBloc({
    required this._robot,
    required this._places,
    required this.placeKey,
  }) : super(const GuideState()) {
    on<GuideStarted>(_onStarted);
    on<GuideStopRequested>(_onStopRequested);
    on<GuideRetryRequested>(_onRetryRequested);
    on<_GuideRobotEventReceived>(_onRobotEvent);
    _subscription = _robot.events.listen(
      (event) => add(_GuideRobotEventReceived(event)),
    );
  }

  /// 이동 상태별로 어림한 진행 정도.
  static const progressCalculating = 0.05;
  static const progressGoing = 0.4;

  final RobotController _robot;
  final PlaceRepository _places;
  final String placeKey;
  late final StreamSubscription<RobotEvent> _subscription;

  Future<void> _onStarted(GuideStarted event, Emitter<GuideState> emit) async {
    final place = await _places.getPlace(placeKey);
    if (place == null) {
      emit(state.copyWith(phase: GuidePhase.notFound));
      return;
    }
    emit(state.copyWith(phase: GuidePhase.moving, place: place, progress: 0));
    await _robot.speak(place.speech.start);
    await _robot.goTo(place.key);
  }

  Future<void> _onStopRequested(
    GuideStopRequested event,
    Emitter<GuideState> emit,
  ) async {
    await _robot.stopMovement();
    emit(state.copyWith(phase: GuidePhase.stopped));
  }

  Future<void> _onRetryRequested(
    GuideRetryRequested event,
    Emitter<GuideState> emit,
  ) async {
    emit(state.copyWith(phase: GuidePhase.moving, progress: 0));
    await _robot.goTo(placeKey);
  }

  void _onRobotEvent(_GuideRobotEventReceived event, Emitter<GuideState> emit) {
    final e = event.event;
    if (e is! GoToStatusChanged || e.location != placeKey) return;
    if (state.phase != GuidePhase.moving) return;
    switch (e.status) {
      case GoToStatus.start || GoToStatus.calculating:
        emit(state.copyWith(progress: progressCalculating));
      case GoToStatus.going:
        emit(state.copyWith(progress: progressGoing));
      case GoToStatus.reposing:
        break;
      case GoToStatus.complete:
        emit(state.copyWith(phase: GuidePhase.arrived, progress: 1));
      case GoToStatus.abort:
        emit(state.copyWith(phase: GuidePhase.failed));
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
