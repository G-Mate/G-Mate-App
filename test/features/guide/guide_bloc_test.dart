import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/features/guide/presentation/bloc/guide_bloc.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';

void main() {
  late FakeRobotController robot;

  setUp(() {
    robot = FakeRobotController(
      initialLocations: const ['science_lab'],
      stepDelay: const Duration(milliseconds: 10),
    );
  });
  tearDown(() => robot.dispose());

  GuideBloc build(String key) =>
      GuideBloc(robot: robot, places: InMemoryPlaceRepository(), placeKey: key);

  test('출발 멘트를 읽고 이동해 도착하면 arrived가 된다', () async {
    final spoken = <String>[];
    robot.events.listen((e) {
      if (e is TtsStatusChanged && e.status == TtsStatus.started) {
        spoken.add(e.text);
      }
    });
    final bloc = build('science_lab')..add(const GuideStarted());

    final arrived = await bloc.stream.firstWhere(
      (s) => s.phase == GuidePhase.arrived,
    );
    expect(arrived.progress, 1);
    expect(spoken, ['과학실로 안내할게요. 저를 따라와 주세요.']);
    await bloc.close();
  });

  test('로봇에 없는 장소면 failed가 되고, 다시 시도할 수 있다', () async {
    final bloc = build('library')..add(const GuideStarted());
    await bloc.stream.firstWhere((s) => s.phase == GuidePhase.failed);

    await robot.saveLocation('library');
    bloc.add(const GuideRetryRequested());
    await bloc.stream.firstWhere((s) => s.phase == GuidePhase.arrived);
    await bloc.close();
  });

  test('안내 중지를 누르면 이동을 멈추고 stopped가 된다', () async {
    final bloc = build('science_lab')..add(const GuideStarted());
    await bloc.stream.firstWhere((s) => s.phase == GuidePhase.moving);

    bloc.add(const GuideStopRequested());
    await bloc.stream.firstWhere((s) => s.phase == GuidePhase.stopped);
    // 멈춘 뒤에는 도착 이벤트가 오지 않는다.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(bloc.state.phase, GuidePhase.stopped);
    await bloc.close();
  });

  test('없는 장소 키면 notFound가 된다', () async {
    final bloc = build('nowhere')..add(const GuideStarted());
    await bloc.stream.firstWhere((s) => s.phase == GuidePhase.notFound);
    await bloc.close();
  });
}
