import 'package:equatable/equatable.dart';

import '../../../school/domain/school_info.dart';

class AdminSchoolEditState extends Equatable {
  const AdminSchoolEditState({
    this.isLoading = true,
    this.info,
    this.sectionIds = const [],
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 학교 소개. 저장하기 전까지 저장소에는 반영되지 않는다.
  final SchoolInfo? info;

  /// 단락마다 붙인 고유 번호. 단락을 지워도 입력 칸이 섞이지 않게 한다.
  final List<int> sectionIds;
  final bool isSaved;

  AdminSchoolEditState copyWith({
    bool? isLoading,
    SchoolInfo? info,
    List<int>? sectionIds,
    bool? isSaved,
  }) => AdminSchoolEditState(
    isLoading: isLoading ?? this.isLoading,
    info: info ?? this.info,
    sectionIds: sectionIds ?? this.sectionIds,
    isSaved: isSaved ?? this.isSaved,
  );

  @override
  List<Object?> get props => [isLoading, info, sectionIds, isSaved];
}
