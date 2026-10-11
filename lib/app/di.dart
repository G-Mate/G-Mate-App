import 'package:get_it/get_it.dart';

import '../core/robot/fake_robot_controller.dart';
import '../core/robot/robot_controller.dart';
import '../core/robot/temi_robot_controller.dart';

final getIt = GetIt.instance;

/// `--dart-define=USE_FAKE_ROBOT=false`로 빌드하면 실기 브리지를 쓴다.
/// 로봇 지도가 준비되기 전까지는 Fake가 기본값이다.
const useFakeRobot = bool.fromEnvironment('USE_FAKE_ROBOT', defaultValue: true);

void configureDependencies() {
  getIt.registerLazySingleton<RobotController>(
    () => useFakeRobot
        ? FakeRobotController(initialLocations: const ['home_base'])
        : TemiRobotController(),
    dispose: (robot) => robot.dispose(),
  );
}
