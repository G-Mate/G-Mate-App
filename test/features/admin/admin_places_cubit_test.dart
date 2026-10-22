import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/robot_controller.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_places_cubit.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';

void main() {
  late FakeRobotController robot;
  late InMemoryPlaceRepository places;
  late AdminPlacesCubit cubit;

  setUp(() async {
    robot = FakeRobotController(initialLocations: const ['science_lab']);
    places = InMemoryPlaceRepository();
    cubit = AdminPlacesCubit(robot: robot, places: places);
    await cubit.start();
  });
  tearDown(() async {
    await cubit.close();
    await robot.dispose();
  });

  test('로봇에 저장된 장소를 구분한다', () {
    final science = cubit.state.places.firstWhere(
      (p) => p.key == 'science_lab',
    );
    final library = cubit.state.places.firstWhere((p) => p.key == 'library');
    expect(cubit.state.isOnRobot(science), isTrue);
    expect(cubit.state.isOnRobot(library), isFalse);
  });

  test('현재 위치 저장은 로봇과 장소 목록에 함께 넣는다', () async {
    await cubit.saveCurrentLocation(key: 'gym', name: '체육관');
    expect(await robot.getLocations(), contains('gym'));
    expect((await places.getPlace('gym'))!.name, '체육관');
    expect(cubit.state.robotLocations, contains('gym'));
  });

  test('새 장소 키는 형식과 중복을 확인한다', () {
    expect(cubit.validateNewKey('gym_2'), isNull);
    expect(cubit.validateNewKey('Gym'), isNotNull);
    expect(cubit.validateNewKey('2gym'), isNotNull);
    expect(cubit.validateNewKey('science_lab'), '이미 있는 키예요');
  });

  test('temi에만 있는 위치를 위치 이름으로 새 장소로 가져온다', () async {
    await robot.saveLocation('체육관');
    await robot.saveLocation(temiHomeBase);
    await cubit.load();

    final gym = await places.getPlace('체육관');
    expect(gym!.name, '체육관');
    expect(cubit.state.isOnRobot(gym), isTrue);
    expect(await places.getPlace(temiHomeBase), isNull);
  });

  test('이미 있는 장소는 가져오기로 덮어쓰지 않는다', () async {
    await cubit.saveCurrentLocation(key: 'gym', name: '체육관');
    await cubit.load();
    expect((await places.getPlace('gym'))!.name, '체육관');
  });

  test('로봇이 준비되지 않아도 앱 장소 목록을 보여 준다', () async {
    final notReady = _NotReadyRobot();
    final other = AdminPlacesCubit(robot: notReady, places: places);
    await other.start();
    expect(other.state.isLoading, isFalse);
    expect(other.state.places, isNotEmpty);
    expect(other.state.robotLocations, isEmpty);
    await other.close();
    await notReady.dispose();
  });
}

/// temi가 아닌 기기에서 실기 모드로 켠 것처럼 위치 목록 요청을 거절한다.
class _NotReadyRobot extends FakeRobotController {
  @override
  Future<List<String>> getLocations() =>
      Future.error(PlatformException(code: 'NOT_READY'));
}
