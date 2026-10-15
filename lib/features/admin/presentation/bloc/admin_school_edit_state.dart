import 'package:equatable/equatable.dart';

import '../../../school/domain/school_info.dart';

class AdminSchoolEditState extends Equatable {
  const AdminSchoolEditState({
    this.isLoading = true,
    this.info,
    this.statIds = const [],
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 학교 소개. 저장하기 전까지 저장소에는 반영되지 않는다.
  final SchoolInfo? info;

  /// 숫자 줄마다 붙인 고유 번호. 줄을 지워도 입력 칸이 섞이지 않게 한다.
  final List<int> statIds;
  final bool isSaved;

  bool get canAddStat => (info?.stats.length ?? 0) < SchoolInfo.maxStats;

  AdminSchoolEditState copyWith({
    bool? isLoading,
    SchoolInfo? info,
    List<int>? statIds,
    bool? isSaved,
  }) => AdminSchoolEditState(
    isLoading: isLoading ?? this.isLoading,
    info: info ?? this.info,
    statIds: statIds ?? this.statIds,
    isSaved: isSaved ?? this.isSaved,
  );

  @override
  List<Object?> get props => [isLoading, info, statIds, isSaved];
}
