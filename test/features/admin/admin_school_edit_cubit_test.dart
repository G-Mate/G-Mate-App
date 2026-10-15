import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_school_edit_cubit.dart';
import 'package:g_mate/features/school/data/in_memory_school_info_repository.dart';
import 'package:g_mate/features/school/data/seed_school_info.dart';
import 'package:g_mate/features/school/domain/school_info.dart';

import '../../helpers/test_app.dart';

void main() {
  late InMemorySchoolInfoRepository repo;
  late FakePlaceImagePicker picker;

  setUp(() {
    repo = InMemorySchoolInfoRepository();
    picker = FakePlaceImagePicker(path: '/photos/school.jpg');
  });

  Future<AdminSchoolEditCubit> build() async {
    final cubit = AdminSchoolEditCubit(info: repo, imagePicker: picker);
    await cubit.load();
    addTearDown(cubit.close);
    return cubit;
  }

  test('고친 내용을 저장하고, 빈 숫자와 빈 층 설명은 뺀다', () async {
    final cubit = await build();
    cubit
      ..changeName(' 새 학교 ')
      ..changeIntro('첫 줄\n둘째 줄')
      ..changeStatValue(0, '2016')
      ..addStat()
      ..changeFloorLabel(1, ' ')
      ..changeFloorLabel(4, '체육관');
    await cubit.pickImage();
    await cubit.save();

    final saved = await repo.getSchoolInfo();
    expect(saved.name, '새 학교');
    expect(saved.intro, '첫 줄\n둘째 줄');
    expect(saved.stats, [
      const SchoolStat(value: '2016', label: '개교'),
      seedSchoolInfo.stats[1],
    ]);
    expect(saved.floorLabels, {2: '교무·도서', 3: '교실·실습실', 4: '체육관'});
    expect(saved.imagePath, '/photos/school.jpg');
    expect(cubit.state.isSaved, isTrue);
  });

  test('숫자는 정한 개수까지만 넣고, 지우면 그 줄만 빠진다', () async {
    final cubit = await build();
    while (cubit.state.canAddStat) {
      cubit.addStat();
    }
    expect(cubit.state.info!.stats, hasLength(SchoolInfo.maxStats));
    cubit.addStat();
    expect(cubit.state.info!.stats, hasLength(SchoolInfo.maxStats));

    final ids = cubit.state.statIds;
    cubit.removeStat(0);
    expect(cubit.state.info!.stats.first, seedSchoolInfo.stats[1]);
    expect(cubit.state.statIds, ids.sublist(1));
  });
}
