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

  test('고친 내용을 저장하고, 빈 단락과 빈 층 설명은 뺀다', () async {
    final cubit = await build();
    cubit
      ..changeName(' 새 학교 ')
      ..changeIntro('소개 글')
      ..changeSectionBody(0, '2016년에 문을 열었어요.')
      ..addSection()
      ..addSection()
      ..changeSectionTitle(2, '동아리')
      ..changeSectionBody(2, '첫 줄\n둘째 줄')
      ..changeFloorLabel(1, ' ')
      ..changeFloorLabel(4, '체육관');
    await cubit.pickImage();
    await cubit.save();

    final saved = await repo.getSchoolInfo();
    expect(saved.name, '새 학교');
    expect(saved.intro, '소개 글');
    expect(saved.sections, [
      SchoolSection(
        title: seedSchoolInfo.sections.first.title,
        body: '2016년에 문을 열었어요.',
      ),
      const SchoolSection(title: '동아리', body: '첫 줄\n둘째 줄'),
    ]);
    expect(saved.floorLabels, {2: '교무·도서', 3: '교실·실습실', 4: '체육관'});
    expect(saved.imagePath, '/photos/school.jpg');
    expect(cubit.state.isSaved, isTrue);
  });

  test('단락을 지우면 그 단락과 번호만 빠진다', () async {
    final cubit = await build();
    cubit
      ..addSection()
      ..changeSectionTitle(1, '둘째');
    final ids = cubit.state.sectionIds;

    cubit.removeSection(0);
    expect(cubit.state.info!.sections.single.title, '둘째');
    expect(cubit.state.sectionIds, ids.sublist(1));
  });
}
