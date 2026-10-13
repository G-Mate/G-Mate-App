import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/features/guide/presentation/bloc/arrival_cubit.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';
import 'package:g_mate/features/place/domain/place.dart';

void main() {
  late FakeRobotController robot;
  late List<String> spoken;

  setUp(() {
    robot = FakeRobotController(stepDelay: const Duration(milliseconds: 5));
    spoken = [];
    robot.events.listen((e) {
      if (e is TtsStatusChanged && e.status == TtsStatus.started) {
        spoken.add(e.text);
      }
    });
  });
  tearDown(() => robot.dispose());

  /// 줄 사이 기다리는 시간을 [interval]로 줄인 교무실 저장소.
  Future<InMemoryPlaceRepository> placesWith(Duration interval) async {
    final places = InMemoryPlaceRepository();
    final office = (await places.getPlace('teachers_office'))!;
    await places.savePlace(office.copyWith(lineInterval: interval));
    return places;
  }

  test('도착 멘트 다음 본 설명을 한 줄씩 읽으며 줄을 넘긴다', () async {
    final cubit = ArrivalCubit(
      robot: robot,
      places: await placesWith(const Duration(milliseconds: 10)),
      placeKey: 'teachers_office',
    );
    final indexes = <int>[];
    cubit.stream.listen((s) => indexes.add(s.lineIndex));

    await cubit.start();
    await cubit.stream.firstWhere((s) => !s.isSpeaking);

    expect(spoken, [
      '교무실에 도착했어요.',
      '교무실은 선생님들이 계신 곳이에요.',
      '선생님을 찾으시면 문 앞에서 노크해 주세요.',
    ]);
    expect(cubit.state.lineIndex, 1);
    expect(indexes, containsAllInOrder([0, 1]));
    await cubit.close();
  });

  test('다시 듣기는 본 설명 첫 줄부터 읽는다', () async {
    final cubit = ArrivalCubit(
      robot: robot,
      places: await placesWith(const Duration(milliseconds: 10)),
      placeKey: 'teachers_office',
    );
    await cubit.start();
    await cubit.stream.firstWhere((s) => !s.isSpeaking);
    spoken.clear();

    cubit.replay();
    expect(cubit.state.lineIndex, 0);
    await cubit.stream.firstWhere((s) => !s.isSpeaking);
    expect(spoken, hasLength(2));
    await cubit.close();
  });

  test('본 설명이 없으면 도착 멘트를 한 줄로 보여 준다', () async {
    final cubit = ArrivalCubit(
      robot: robot,
      places: InMemoryPlaceRepository(
        initialPlaces: [Place.create(key: 'gym', name: '체육관')],
      ),
      placeKey: 'gym',
    );
    await cubit.start();
    expect(cubit.state.lines, ['체육관에 도착했어요.']);
    await cubit.stream.firstWhere((s) => !s.isSpeaking);
    expect(spoken, ['체육관에 도착했어요.']);
    await cubit.close();
  });

  test('한 줄을 다 읽어도 정한 시간이 지나기 전에는 다음 줄로 넘어가지 않는다', () async {
    final cubit = ArrivalCubit(
      robot: robot,
      places: await placesWith(const Duration(milliseconds: 300)),
      placeKey: 'teachers_office',
    );
    await cubit.start();
    // 도착 멘트와 첫 줄을 다 읽을 만큼만 기다린다.
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(cubit.state.lineIndex, 0);
    expect(spoken, hasLength(2));

    await cubit.stream.firstWhere((s) => s.lineIndex == 1);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(spoken, hasLength(3));
    await cubit.close();
  });

  test('다음을 누르면 기다리지 않고 다음 줄을 읽고, 마지막 줄에서는 넘어가지 않는다', () async {
    final cubit = ArrivalCubit(
      robot: robot,
      places: await placesWith(const Duration(seconds: 30)),
      placeKey: 'teachers_office',
    );
    await cubit.start();
    expect(cubit.state.hasNext, isTrue);

    cubit.next();
    expect(cubit.state.lineIndex, 1);
    expect(cubit.state.hasNext, isFalse);

    cubit.next();
    expect(cubit.state.lineIndex, 1);
    await cubit.stream.firstWhere((s) => !s.isSpeaking);
    expect(spoken.last, '선생님을 찾으시면 문 앞에서 노크해 주세요.');
    await cubit.close();
  });
}
