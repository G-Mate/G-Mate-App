import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_place_edit_cubit.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';
import 'package:g_mate/features/place/domain/place.dart';

void main() {
  late FakeRobotController robot;
  late InMemoryPlaceRepository places;

  setUp(() {
    robot = FakeRobotController();
    places = InMemoryPlaceRepository();
  });
  tearDown(() => robot.dispose());

  Future<AdminPlaceEditCubit> load() async {
    final cubit = AdminPlaceEditCubit(
      robot: robot,
      places: places,
      placeKey: 'science_lab',
    );
    await cubit.load();
    return cubit;
  }

  test('고친 내용은 저장을 눌러야 저장소에 들어가고, 빈 줄은 빠진다', () async {
    final cubit = await load();
    cubit
      ..changeName('과학 실험실')
      ..changeKeywords(' 실험 , ,과학 ')
      ..addLine();
    expect((await places.getPlace('science_lab'))!.name, '과학실');

    await cubit.save();
    final saved = (await places.getPlace('science_lab'))!;
    expect(saved.name, '과학 실험실');
    expect(saved.keywords, ['실험', '과학']);
    expect(saved.speech.descriptionLines, hasLength(4));
    expect(cubit.state.isSaved, isTrue);
    await cubit.close();
  });

  test('원래 설명으로는 멘트만 원본으로 되돌린다', () async {
    final cubit = await load();
    final original = cubit.state.place!.speech;
    cubit
      ..changeName('새 이름')
      ..changeStart('바뀐 출발 멘트')
      ..removeLine(0);
    final revision = cubit.state.speechRevision;

    cubit.restoreOriginalSpeech();
    expect(cubit.state.place!.speech, original);
    expect(cubit.state.place!.name, '새 이름');
    expect(cubit.state.lineIds, hasLength(original.descriptionLines.length));
    expect(cubit.state.speechRevision, revision + 1);
    await cubit.close();
  });

  test('줄을 지우면 그 줄의 번호도 같이 빠진다', () async {
    final cubit = await load();
    final ids = cubit.state.lineIds;
    cubit.removeLine(1);
    expect(cubit.state.lineIds, [ids[0], ...ids.sublist(2)]);
    expect(
      cubit.state.place!.speech.descriptionLines.first,
      '과학실은 3층 동쪽 끝에 있어요.',
    );
    await cubit.close();
  });

  test('자동 넘김 시간을 바꾸면 저장할 때 같이 저장된다', () async {
    final cubit = await load();
    expect(cubit.state.place!.lineInterval, Place.defaultLineInterval);

    cubit.changeLineInterval(const Duration(seconds: 8));
    await cubit.save();
    expect(
      (await places.getPlace('science_lab'))!.lineInterval,
      const Duration(seconds: 8),
    );
    await cubit.close();
  });
}
