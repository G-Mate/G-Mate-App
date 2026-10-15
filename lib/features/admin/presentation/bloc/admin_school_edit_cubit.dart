import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../school/domain/school_info.dart';
import '../../../school/domain/school_info_repository.dart';
import 'admin_school_edit_state.dart';

/// 학교 개요 편집: 팀 이름, 개발자·기획자 이름, 학교 홈페이지 주소를 고치고
/// 저장한다.
class AdminSchoolEditCubit extends Cubit<AdminSchoolEditState> {
  AdminSchoolEditCubit(this._info) : super(const AdminSchoolEditState());

  final SchoolInfoRepository _info;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    if (isClosed) return;
    emit(AdminSchoolEditState(isLoading: false, info: info));
  }

  SchoolInfo get _current => state.info!;

  void changeTeamName(String v) => _update(_current.copyWith(teamName: v));

  void changeDeveloper(String v) => _update(_current.copyWith(developer: v));

  void changePlanner(String v) => _update(_current.copyWith(planner: v));

  void changeHomepageUrl(String v) =>
      _update(_current.copyWith(homepageUrl: v));

  /// 앞뒤 빈칸을 빼고 저장한다. 주소가 맞지 않으면 저장하지 않는다.
  Future<void> save() async {
    if (!state.isUrlValid) return;
    await _info.saveSchoolInfo(
      _current.copyWith(
        teamName: _current.teamName.trim(),
        developer: _current.developer.trim(),
        planner: _current.planner.trim(),
        homepageUrl: _current.homepageUrl.trim(),
      ),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _update(SchoolInfo info) => emit(state.copyWith(info: info));
}
