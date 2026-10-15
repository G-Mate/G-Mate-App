import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_school_edit_cubit.dart';
import 'package:g_mate/features/school/data/in_memory_school_info_repository.dart';
import 'package:g_mate/features/school/data/seed_school_info.dart';

void main() {
  late InMemorySchoolInfoRepository repo;

  setUp(() => repo = InMemorySchoolInfoRepository());

  Future<AdminSchoolEditCubit> build() async {
    final cubit = AdminSchoolEditCubit(repo);
    await cubit.load();
    addTearDown(cubit.close);
    return cubit;
  }

  test('이름과 주소를 고쳐 저장하고, 앞뒤 빈칸은 뺀다', () async {
    final cubit = await build();
    cubit
      ..changeTeamName(' 지메이트 ')
      ..changeDeveloper('홍길동, 김철수 ')
      ..changePlanner(' 이영희')
      ..changeHomepageUrl(' https://example.com/ ');
    await cubit.save();

    final saved = await repo.getSchoolInfo();
    expect(saved.teamName, '지메이트');
    expect(saved.developer, '홍길동, 김철수');
    expect(saved.planner, '이영희');
    expect(saved.homepageUrl, 'https://example.com/');
    expect(cubit.state.isSaved, isTrue);
  });

  test('웹 주소가 아니면 저장하지 않는다', () async {
    final cubit = await build();
    cubit.changeHomepageUrl('gsm.jge.hs.kr');
    expect(cubit.state.isUrlValid, isFalse);

    await cubit.save();
    expect(cubit.state.isSaved, isFalse);
    expect(await repo.getSchoolInfo(), seedSchoolInfo);
  });
}
