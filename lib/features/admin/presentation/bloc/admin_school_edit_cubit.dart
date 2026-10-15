import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../school/domain/school_info.dart';
import '../../../school/domain/school_info_repository.dart';
import '../../domain/place_image_picker.dart';
import 'admin_school_edit_state.dart';

/// 학교 개요 편집: 블록을 넣고·지우고·옮기고 내용을 고치며, 맨 아래 만든
/// 사람들 이름을 고친 뒤 저장한다.
class AdminSchoolEditCubit extends Cubit<AdminSchoolEditState> {
  AdminSchoolEditCubit({required this._info, required this._imagePicker})
    : super(const AdminSchoolEditState());

  final SchoolInfoRepository _info;
  final PlaceImagePicker _imagePicker;
  int _nextBlockId = 0;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    if (isClosed) return;
    emit(
      AdminSchoolEditState(
        isLoading: false,
        info: info,
        blockIds: [for (final _ in info.blocks) _nextBlockId++],
      ),
    );
  }

  SchoolInfo get _current => state.info!;
  List<SchoolBlock> get _blocks => _current.blocks;

  void changeTeamName(String v) => _update(_current.copyWith(teamName: v));

  void changeDeveloper(String v) => _update(_current.copyWith(developer: v));

  void changePlanner(String v) => _update(_current.copyWith(planner: v));

  /// [type] 블록을 맨 끝에 넣는다.
  void addBlock(SchoolBlockType type) => emit(
    state.copyWith(
      info: _current.copyWith(blocks: [..._blocks, SchoolBlock.empty(type)]),
      blockIds: [...state.blockIds, _nextBlockId++],
    ),
  );

  void removeBlock(int index) => emit(
    state.copyWith(
      info: _current.copyWith(blocks: [..._blocks]..removeAt(index)),
      blockIds: [...state.blockIds]..removeAt(index),
    ),
  );

  /// 블록 순서를 바꾼다. [to]는 [from]을 뺀 뒤의 자리다.
  void moveBlock(int from, int to) {
    final blocks = [..._blocks];
    final ids = [...state.blockIds];
    final block = blocks.removeAt(from);
    final id = ids.removeAt(from);
    final at = to.clamp(0, blocks.length);
    blocks.insert(at, block);
    ids.insert(at, id);
    emit(
      state.copyWith(
        info: _current.copyWith(blocks: blocks),
        blockIds: ids,
      ),
    );
  }

  /// [index] 블록을 [block]으로 바꾼다 (제목·본문·주소 입력).
  void changeBlock(int index, SchoolBlock block) =>
      _update(_current.copyWith(blocks: [..._blocks]..[index] = block));

  /// [사진 고르기]: 사진첩에서 고른 사진을 [index] 블록 사진으로 둔다.
  Future<void> pickImage(int index) async {
    final path = await _imagePicker.pick();
    if (path == null || isClosed) return;
    changeBlock(index, _blocks[index].copyWith(imagePath: path));
  }

  void removeImage(int index) =>
      changeBlock(index, _blocks[index].copyWith(clearImage: true));

  void addCard(int index) =>
      _changeCards(index, [..._blocks[index].cards, const SchoolCard()]);

  void removeCard(int index, int card) =>
      _changeCards(index, [..._blocks[index].cards]..removeAt(card));

  void changeCard(int index, int card, SchoolCard value) => changeBlock(
    index,
    _blocks[index].copyWith(cards: [..._blocks[index].cards]..[card] = value),
  );

  /// 앞뒤 빈칸을 빼고 저장한다.
  Future<void> save() async {
    final info = _current;
    await _info.saveSchoolInfo(
      info.copyWith(
        teamName: info.teamName.trim(),
        developer: info.developer.trim(),
        planner: info.planner.trim(),
        blocks: [
          for (final b in info.blocks)
            b.copyWith(
              title: b.title.trim(),
              body: b.body.trim(),
              url: b.url.trim(),
              cards: [
                for (final c in b.cards)
                  SchoolCard(
                    emoji: c.emoji.trim(),
                    title: c.title.trim(),
                    body: c.body.trim(),
                  ),
              ],
            ),
        ],
      ),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _changeCards(int index, List<SchoolCard> cards) => emit(
    state.copyWith(
      info: _current.copyWith(
        blocks: [..._blocks]..[index] = _blocks[index].copyWith(cards: cards),
      ),
      cardRevision: state.cardRevision + 1,
    ),
  );

  void _update(SchoolInfo info) => emit(state.copyWith(info: info));
}
