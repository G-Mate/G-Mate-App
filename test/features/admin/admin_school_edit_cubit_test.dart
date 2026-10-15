import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_school_edit_cubit.dart';
import 'package:g_mate/features/school/data/in_memory_school_info_repository.dart';
import 'package:g_mate/features/school/data/seed_school_info.dart';

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

  test('제목·문서·사진을 고쳐 저장하고, 앞뒤 빈칸은 뺀다', () async {
    final cubit = await build();
    cubit
      ..changeName(' 새 학교 ')
      ..changeDocument('\n소개 글\n\n# 동아리\n- 로봇\n\n');
    await cubit.pickImage();
    await cubit.save();

    final saved = await repo.getSchoolInfo();
    expect(saved.name, '새 학교');
    expect(saved.document, '소개 글\n\n# 동아리\n- 로봇');
    expect(saved.imagePath, '/photos/school.jpg');
    expect(cubit.state.isSaved, isTrue);
  });

  test('사진을 지우면 아이콘 그림으로 돌아간다', () async {
    final cubit = await build();
    await cubit.pickImage();
    cubit.removeImage();
    expect(cubit.state.info!.imagePath, isNull);
    expect(cubit.state.info!.document, seedSchoolInfo.document);
  });
}
