import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../school/domain/school_info.dart';
import '../../../school/domain/school_info_repository.dart';
import '../../domain/place_image_picker.dart';
import 'admin_school_edit_state.dart';

/// 학교 개요 편집: 학교 이름·소개 글·숫자·사진·층별 설명을 고치고 저장한다.
class AdminSchoolEditCubit extends Cubit<AdminSchoolEditState> {
  AdminSchoolEditCubit({required this._info, required this._imagePicker})
    : super(const AdminSchoolEditState());

  final SchoolInfoRepository _info;
  final PlaceImagePicker _imagePicker;
  int _nextStatId = 0;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    if (isClosed) return;
    emit(
      AdminSchoolEditState(
        isLoading: false,
        info: info,
        statIds: [for (final _ in info.stats) _nextStatId++],
      ),
    );
  }

  SchoolInfo get _current => state.info!;

  void changeName(String name) => _update(_current.copyWith(name: name));

  void changeIntro(String intro) => _update(_current.copyWith(intro: intro));

  void changeStatValue(int index, String value) => _changeStat(
    index,
    SchoolStat(value: value, label: _current.stats[index].label),
  );

  void changeStatLabel(int index, String label) => _changeStat(
    index,
    SchoolStat(value: _current.stats[index].value, label: label),
  );

  void addStat() {
    if (!state.canAddStat) return;
    emit(
      state.copyWith(
        info: _current.copyWith(
          stats: [
            ..._current.stats,
            const SchoolStat(value: '', label: ''),
          ],
        ),
        statIds: [...state.statIds, _nextStatId++],
      ),
    );
  }

  void removeStat(int index) => emit(
    state.copyWith(
      info: _current.copyWith(stats: [..._current.stats]..removeAt(index)),
      statIds: [...state.statIds]..removeAt(index),
    ),
  );

  /// [floor]층 설명. 비우면 층 번호만 보인다.
  void changeFloorLabel(int floor, String label) => _update(
    _current.copyWith(floorLabels: {..._current.floorLabels, floor: label}),
  );

  /// [사진 고르기]: 사진첩에서 고른 사진을 학교 사진으로 둔다.
  Future<void> pickImage() async {
    final path = await _imagePicker.pick();
    if (path == null || isClosed) return;
    _update(_current.copyWith(imagePath: path));
  }

  /// [사진 지우기]: 사진을 빼고 학교 아이콘 그림으로 되돌린다.
  void removeImage() => _update(_current.copyWith(clearImage: true));

  /// 앞뒤 빈칸을 빼고, 값이 빈 숫자와 빈 층 설명은 빼고 저장한다.
  Future<void> save() async {
    final info = _current;
    await _info.saveSchoolInfo(
      info.copyWith(
        name: info.name.trim(),
        intro: info.intro.trim(),
        stats: [
          for (final s in info.stats)
            if (s.value.trim().isNotEmpty)
              SchoolStat(value: s.value.trim(), label: s.label.trim()),
        ],
        floorLabels: {
          for (final e in info.floorLabels.entries)
            if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
        },
      ),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _changeStat(int index, SchoolStat stat) =>
      _update(_current.copyWith(stats: [..._current.stats]..[index] = stat));

  void _update(SchoolInfo info) => emit(state.copyWith(info: info));
}
