import 'package:equatable/equatable.dart';

import '../../../school/domain/school_info.dart';

class AdminSchoolEditState extends Equatable {
  const AdminSchoolEditState({
    this.isLoading = true,
    this.info,
    this.blockIds = const [],
    this.cardRevision = 0,
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 학교 개요. 저장하기 전까지 저장소에는 반영되지 않는다.
  final SchoolInfo? info;

  /// 블록마다 붙인 고유 번호. 블록을 옮기거나 지워도 입력 칸이 섞이지 않게 한다.
  final List<int> blockIds;

  /// 카드를 넣거나 지울 때마다 늘린다. 카드 입력 칸을 새로 그리게 한다.
  final int cardRevision;
  final bool isSaved;

  AdminSchoolEditState copyWith({
    SchoolInfo? info,
    List<int>? blockIds,
    int? cardRevision,
    bool? isSaved,
  }) => AdminSchoolEditState(
    isLoading: isLoading,
    info: info ?? this.info,
    blockIds: blockIds ?? this.blockIds,
    cardRevision: cardRevision ?? this.cardRevision,
    isSaved: isSaved ?? this.isSaved,
  );

  @override
  List<Object?> get props => [isLoading, info, blockIds, cardRevision, isSaved];
}
