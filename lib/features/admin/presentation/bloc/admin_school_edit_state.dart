import 'package:equatable/equatable.dart';

import '../../../school/domain/school_info.dart';

class AdminSchoolEditState extends Equatable {
  const AdminSchoolEditState({
    this.isLoading = true,
    this.info,
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 학교 소개. 저장하기 전까지 저장소에는 반영되지 않는다.
  final SchoolInfo? info;
  final bool isSaved;

  AdminSchoolEditState copyWith({SchoolInfo? info, bool? isSaved}) =>
      AdminSchoolEditState(
        isLoading: isLoading,
        info: info ?? this.info,
        isSaved: isSaved ?? this.isSaved,
      );

  @override
  List<Object?> get props => [isLoading, info, isSaved];
}
