import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../school/domain/school_info.dart';
import '../../../school/domain/school_info_repository.dart';
import '../../domain/place_image_picker.dart';
import 'admin_school_edit_state.dart';

/// 학교 개요 편집: 학교 이름·소개 글·사진, 단락(소제목·본문), 층별 설명을
/// 고치고 저장한다.
class AdminSchoolEditCubit extends Cubit<AdminSchoolEditState> {
  AdminSchoolEditCubit({required this._info, required this._imagePicker})
    : super(const AdminSchoolEditState());

  final SchoolInfoRepository _info;
  final PlaceImagePicker _imagePicker;
  int _nextSectionId = 0;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    if (isClosed) return;
    emit(
      AdminSchoolEditState(
        isLoading: false,
        info: info,
        sectionIds: [for (final _ in info.sections) _nextSectionId++],
      ),
    );
  }

  SchoolInfo get _current => state.info!;

  void changeName(String name) => _update(_current.copyWith(name: name));

  void changeIntro(String intro) => _update(_current.copyWith(intro: intro));

  void changeSectionTitle(int index, String title) => _changeSection(
    index,
    SchoolSection(title: title, body: _current.sections[index].body),
  );

  void changeSectionBody(int index, String body) => _changeSection(
    index,
    SchoolSection(title: _current.sections[index].title, body: body),
  );

  void addSection() => emit(
    state.copyWith(
      info: _current.copyWith(
        sections: [
          ..._current.sections,
          const SchoolSection(title: '', body: ''),
        ],
      ),
      sectionIds: [...state.sectionIds, _nextSectionId++],
    ),
  );

  void removeSection(int index) => emit(
    state.copyWith(
      info: _current.copyWith(
        sections: [..._current.sections]..removeAt(index),
      ),
      sectionIds: [...state.sectionIds]..removeAt(index),
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

  /// [사진 지우기]: 사진 없이 글만 보여 준다.
  void removeImage() => _update(_current.copyWith(clearImage: true));

  /// 앞뒤 빈칸을 빼고, 소제목과 본문이 모두 빈 단락과 빈 층 설명은 빼고 저장한다.
  Future<void> save() async {
    final info = _current;
    await _info.saveSchoolInfo(
      info.copyWith(
        name: info.name.trim(),
        intro: info.intro.trim(),
        sections: [
          for (final s in info.sections)
            if (s.title.trim().isNotEmpty || s.body.trim().isNotEmpty)
              SchoolSection(title: s.title.trim(), body: s.body.trim()),
        ],
        floorLabels: {
          for (final e in info.floorLabels.entries)
            if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
        },
      ),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _changeSection(int index, SchoolSection section) => _update(
    _current.copyWith(sections: [..._current.sections]..[index] = section),
  );

  void _update(SchoolInfo info) => emit(state.copyWith(info: info));
}
