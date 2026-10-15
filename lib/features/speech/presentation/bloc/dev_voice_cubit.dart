import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/fake_robot_controller.dart';

/// 개발용: 에뮬레이터에서는 말할 수 없으므로 글로 넣은 말을 Fake 로봇이
/// 알아들은 것처럼 보낸다. 상태는 마지막으로 넣은 말이다.
class DevVoiceCubit extends Cubit<String?> {
  DevVoiceCubit(this._robot) : super(null);

  final FakeRobotController _robot;

  void hear(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    _robot.hearSpeech(t);
    emit(t);
  }
}
