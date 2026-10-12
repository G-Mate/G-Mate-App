import 'package:flutter_test/flutter_test.dart';
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
}
