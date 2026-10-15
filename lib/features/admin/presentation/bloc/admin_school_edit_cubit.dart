import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../school/domain/school_info.dart';
import '../../../school/domain/school_info_repository.dart';
import '../../domain/place_image_picker.dart';
import 'admin_school_edit_state.dart';

/// 학교 개요 편집: 학교 사진, 제목(학교 이름), 소개 문서를 고치고 저장한다.
class AdminSchoolEditCubit extends Cubit<AdminSchoolEditState> {
  AdminSchoolEditCubit({required this._info, required this._imagePicker})
    : super(const AdminSchoolEditState());

  final SchoolInfoRepository _info;
  final PlaceImagePicker _imagePicker;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    if (isClosed) return;
    emit(AdminSchoolEditState(isLoading: false, info: info));
  }

  SchoolInfo get _current => state.info!;

  void changeName(String name) => _update(_current.copyWith(name: name));

  void changeDocument(String document) =>
      _update(_current.copyWith(document: document));

  /// [사진 고르기]: 사진첩에서 고른 사진을 학교 사진으로 둔다.
  Future<void> pickImage() async {
    final path = await _imagePicker.pick();
    if (path == null || isClosed) return;
    _update(_current.copyWith(imagePath: path));
  }

  /// [사진 지우기]: 사진을 빼고 학교 아이콘 그림으로 되돌린다.
  void removeImage() => _update(_current.copyWith(clearImage: true));

  /// 제목과 문서의 앞뒤 빈칸을 빼고 저장한다.
  Future<void> save() async {
    await _info.saveSchoolInfo(
      _current.copyWith(
        name: _current.name.trim(),
        document: _current.document.trim(),
      ),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _update(SchoolInfo info) => emit(state.copyWith(info: info));
}
