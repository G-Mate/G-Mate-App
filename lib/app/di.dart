import 'package:get_it/get_it.dart';

import '../core/robot/fake_robot_controller.dart';
import '../core/robot/robot_controller.dart';
import '../core/robot/temi_robot_controller.dart';
import '../features/admin/data/gallery_place_image_picker.dart';
import '../features/admin/data/in_memory_admin_pin_repository.dart';
import '../features/admin/domain/admin_pin_repository.dart';
import '../features/admin/domain/place_image_picker.dart';
import '../features/place/data/in_memory_place_repository.dart';
import '../features/place/data/seed_places.dart';
import '../features/place/domain/place_repository.dart';
import '../features/speech/data/in_memory_speech_settings_repository.dart';
import '../features/speech/domain/speech_settings_repository.dart';

final getIt = GetIt.instance;

/// `--dart-define=USE_FAKE_ROBOT=false`로 빌드하면 실기 브리지를 쓴다.
/// 로봇 지도가 준비되기 전까지는 Fake가 기본값이다.
const useFakeRobot = bool.fromEnvironment('USE_FAKE_ROBOT', defaultValue: true);

void configureDependencies() {
  getIt
    ..registerLazySingleton<RobotController>(
      // Fake는 처음 장소 중 마지막 하나만 빼고 로봇에 저장된 것으로 둔다.
      // 장소 관리 화면에서 '로봇에 없음' 상태를 볼 수 있게 하려는 것.
      () => useFakeRobot
          ? FakeRobotController(
              initialLocations: [
                'home_base',
                for (final p in seedPlaces.take(seedPlaces.length - 1)) p.key,
              ],
            )
          : TemiRobotController(),
      dispose: (robot) => robot.dispose(),
    )
    // 로컬 DB(drift)를 붙이기 전까지 메모리 저장소를 쓴다.
    ..registerLazySingleton<PlaceRepository>(InMemoryPlaceRepository.new)
    ..registerLazySingleton<SpeechSettingsRepository>(
      InMemorySpeechSettingsRepository.new,
    )
    ..registerLazySingleton<AdminPinRepository>(InMemoryAdminPinRepository.new)
    ..registerLazySingleton<PlaceImagePicker>(GalleryPlaceImagePicker.new);
}
