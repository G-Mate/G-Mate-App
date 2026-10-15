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
    picker = FakePlaceImagePicker(path: '/photos/hero.jpg');
  });

  Future<AdminSchoolEditCubit> build() async {
    final cubit = AdminSchoolEditCubit(info: repo, imagePicker: picker);
    await cubit.load();
    addTearDown(cubit.close);
    return cubit;
  }

  test('블록을 넣고 고치고 옮기고 지운 뒤 저장한다', () async {
    final cubit = await build();
    final count = seedSchoolInfo.blocks.length;

    cubit.addBlock(SchoolBlockType.text);
    cubit.changeBlock(
      count,
      cubit.state.info!.blocks[count].copyWith(body: ' 새 본문 '),
    );
    cubit.moveBlock(count, 0);
    expect(cubit.state.info!.blocks.first.body, ' 새 본문 ');
    expect(cubit.state.blockIds.first, count);

    cubit.removeBlock(1);
    await cubit.pickImage(0);
    cubit.changeTeamName(' 지메이트 ');
    await cubit.save();

    final saved = await repo.getSchoolInfo();
    expect(saved.blocks, hasLength(count));
    expect(saved.blocks.first.type, SchoolBlockType.text);
    expect(saved.blocks.first.body, '새 본문');
    expect(saved.blocks.first.imagePath, '/photos/hero.jpg');
    expect(saved.teamName, '지메이트');
    expect(cubit.state.isSaved, isTrue);
  });

  test('카드 묶음은 카드를 넣고 고치고 지울 수 있다', () async {
    final cubit = await build();
    cubit.addBlock(SchoolBlockType.cards);
    final i = cubit.state.info!.blocks.length - 1;
    expect(cubit.state.info!.blocks[i].cards, hasLength(1));

    final revision = cubit.state.cardRevision;
    cubit
      ..addCard(i)
      ..changeCard(i, 1, const SchoolCard(emoji: '🤖', title: 'AI'))
      ..removeCard(i, 0);
    expect(cubit.state.info!.blocks[i].cards, [
      const SchoolCard(emoji: '🤖', title: 'AI'),
    ]);
    expect(cubit.state.cardRevision, revision + 2);
  });
}
