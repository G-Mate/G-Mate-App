import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';
import 'package:g_mate/features/tour/data/in_memory_tour_repository.dart';
import 'package:g_mate/features/tour/domain/get_tour_visits.dart';
import 'package:g_mate/features/tour/domain/tour.dart';
import 'package:g_mate/features/tour/presentation/bloc/tour_bloc.dart';

const _tour = Tour(
  key: 'test',
  name: '테스트 코스',
  description: '두 곳을 둘러봐요',
  duration: Duration(minutes: 5),
  stops: [
    TourStop(placeKey: 'science_lab', lines: ['첫 줄', '둘째 줄']),
    TourStop(placeKey: 'nowhere'),
    TourStop(placeKey: 'computer_lab'),
  ],
);

void main() {
  late FakeRobotController robot;
  late List<String> spoken;

  setUp(() {
    robot = FakeRobotController(
      initialLocations: const ['science_lab', 'computer_lab'],
      stepDelay: const Duration(milliseconds: 10),
    );
    spoken = [];
    robot.events.listen((e) {
      if (e is TtsStatusChanged && e.status == TtsStatus.started) {
        spoken.add(e.text);
      }
    });
  });
  tearDown(() => robot.dispose());

  TourBloc build({String key = 'test'}) => TourBloc(
    robot: robot,
    tours: InMemoryTourRepository(tours: const [_tour]),
    getVisits: GetTourVisits(InMemoryPlaceRepository()),
    tourKey: key,
  );

  test('장소 저장소에 없는 곳은 건너뛰고, 설명이 없으면 장소 설명을 쓴다', () async {
    final visits = await GetTourVisits(InMemoryPlaceRepository())(_tour);

    expect(visits.map((v) => v.place.key), ['science_lab', 'computer_lab']);
    expect(visits.first.lines, ['첫 줄', '둘째 줄']);
    expect(visits.last.lines.first, '컴퓨터실은 3층 가운데에 있어요.');
  });

  test('이동해 도착하면 설명을 한 줄씩 끝까지 읽고 다음 장소를 기다린다', () async {
    final bloc = build()..add(const TourStarted());

    await bloc.stream.firstWhere((s) => s.phase == TourPhase.explaining);
    final done = await bloc.stream.firstWhere(
      (s) => s.phase == TourPhase.explaining && !s.isSpeaking,
    );

    expect(done.stopIndex, 0);
    expect(done.lineIndex, 1);
    expect(spoken, ['과학실로 갈게요. 저를 따라와 주세요.', '첫 줄', '둘째 줄']);
    await bloc.close();
  });

  test('마지막 장소에서 다음을 누르면 마침 멘트를 읽고 finished가 된다', () async {
    final bloc = build()..add(const TourStarted());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.explaining);

    bloc.add(const TourNextRequested());
    final second = await bloc.stream.firstWhere(
      (s) => s.phase == TourPhase.explaining,
    );
    expect(second.stopIndex, 1);
    expect(second.isLastStop, isTrue);

    bloc.add(const TourNextRequested());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.finished);
    await Future<void>.delayed(Duration.zero);
    expect(spoken.last, TourBloc.finishSpeech);
    await bloc.close();
  });

  test('로봇에 없는 장소면 failed가 되고, 건너뛰면 다음 곳으로 간다', () async {
    await robot.deleteLocation('science_lab');
    final bloc = build()..add(const TourStarted());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.failed);

    bloc.add(const TourNextRequested());
    final next = await bloc.stream.firstWhere(
      (s) => s.phase == TourPhase.moving,
    );
    expect(next.stopIndex, 1);
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.explaining);
    await bloc.close();
  });

  test('도착했어요를 누르면 이동을 멈추고 바로 설명한다', () async {
    final bloc = build()..add(const TourStarted());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.moving);

    bloc.add(const TourArrivalConfirmed());
    final explaining = await bloc.stream.firstWhere(
      (s) => s.phase == TourPhase.explaining,
    );
    expect(explaining.lineIndex, 0);
    await bloc.close();
  });

  test('투어 중지를 누르면 stopped가 되고 더는 진행하지 않는다', () async {
    final bloc = build()..add(const TourStarted());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.moving);

    bloc.add(const TourStopRequested());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.stopped);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(bloc.state.phase, TourPhase.stopped);
    await bloc.close();
  });

  test('없는 코스면 notFound가 된다', () async {
    final bloc = build(key: 'nope')..add(const TourStarted());
    await bloc.stream.firstWhere((s) => s.phase == TourPhase.notFound);
    await bloc.close();
  });
}
