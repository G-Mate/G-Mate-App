import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/school_info.dart';
import '../../domain/school_info_repository.dart';

/// 학교 개요: 학교 사진과 소개 문서를 불러온다.
class SchoolOverviewCubit extends Cubit<SchoolOverviewState> {
  SchoolOverviewCubit(this._info) : super(const SchoolOverviewState());

  final SchoolInfoRepository _info;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    if (isClosed) return;
    emit(SchoolOverviewState(isLoading: false, info: info));
  }
}

class SchoolOverviewState extends Equatable {
  const SchoolOverviewState({this.isLoading = true, this.info});

  final bool isLoading;
  final SchoolInfo? info;

  @override
  List<Object?> get props => [isLoading, info];
}
