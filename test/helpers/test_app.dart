import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/di.dart';
import 'package:g_mate/app/router.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_controller.dart';
import 'package:g_mate/core/theme/app_theme.dart';
import 'package:g_mate/features/admin/data/in_memory_admin_pin_repository.dart';
import 'package:g_mate/features/admin/domain/admin_pin_repository.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';
import 'package:g_mate/features/place/domain/place_repository.dart';
import 'package:g_mate/features/speech/data/in_memory_speech_settings_repository.dart';
import 'package:g_mate/features/speech/domain/speech_settings_repository.dart';

/// temi 머리 태블릿 가로 화면 (논리 크기 1280x800).
void useTabletView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1920, 1200);
  tester.view.devicePixelRatio = 1.5;
  addTearDown(tester.view.reset);
}

/// 테스트용 의존성을 새로 등록한다. 로봇은 [science_lab] 등 [locations]만 저장된 Fake.
Future<FakeRobotController> registerTestDependencies({
  List<String> locations = const ['science_lab', 'computer_lab'],
  Duration stepDelay = const Duration(milliseconds: 100),
}) async {
  await getIt.reset();
  final robot = FakeRobotController(
    initialLocations: locations,
    stepDelay: stepDelay,
  );
  getIt
    ..registerSingleton<RobotController>(robot)
    ..registerSingleton<PlaceRepository>(InMemoryPlaceRepository())
    ..registerSingleton<SpeechSettingsRepository>(
      InMemorySpeechSettingsRepository(),
    )
    ..registerSingleton<AdminPinRepository>(InMemoryAdminPinRepository());
  return robot;
}

/// [initialLocation]에서 시작하는 앱.
Widget testApp(String initialLocation) => MaterialApp.router(
  theme: AppTheme.light(),
  debugShowCheckedModeBanner: false,
  routerConfig: createRouter(initialLocation: initialLocation),
);
