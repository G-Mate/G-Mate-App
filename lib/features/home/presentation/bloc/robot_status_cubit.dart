import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';

/// 홈 화면에 로봇 준비 상태를 보여주기 위한 Cubit.
class RobotStatusCubit extends Cubit<RobotStatusState> {
  RobotStatusCubit(this._robot) : super(const RobotStatusState());

  final RobotController _robot;
  StreamSubscription<RobotEvent>? _subscription;

  Future<void> start() async {
    _subscription = _robot.events.listen((event) {
      if (event is RobotReadyChanged) {
        emit(RobotStatusState(isChecking: false, isReady: event.isReady));
      }
    });
    final ready = await _robot.isReady();
    emit(RobotStatusState(isChecking: false, isReady: ready));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

class RobotStatusState extends Equatable {
  const RobotStatusState({this.isChecking = true, this.isReady = false});

  final bool isChecking;
  final bool isReady;

  @override
  List<Object?> get props => [isChecking, isReady];
}
