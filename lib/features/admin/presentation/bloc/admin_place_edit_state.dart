import 'package:equatable/equatable.dart';

import '../../../place/domain/place.dart';

class AdminPlaceEditState extends Equatable {
  const AdminPlaceEditState({
    this.isLoading = true,
    this.place,
    this.lineIds = const [],
    this.speechRevision = 0,
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 장소. 저장하기 전까지 저장소에는 반영되지 않는다.
  final Place? place;

  /// 본 설명 줄마다 붙인 고유 번호. 줄을 지워도 입력 칸이 섞이지 않게 한다.
  final List<int> lineIds;

  /// 멘트를 화면 밖에서 바꿨을 때(원래 설명으로) 입력 칸을 새로 그리기 위한 번호.
  final int speechRevision;
  final bool isSaved;

  AdminPlaceEditState copyWith({
    bool? isLoading,
    Place? place,
    List<int>? lineIds,
    int? speechRevision,
    bool? isSaved,
  }) => AdminPlaceEditState(
    isLoading: isLoading ?? this.isLoading,
    place: place ?? this.place,
    lineIds: lineIds ?? this.lineIds,
    speechRevision: speechRevision ?? this.speechRevision,
    isSaved: isSaved ?? this.isSaved,
  );

  @override
  List<Object?> get props => [
    isLoading,
    place,
    lineIds,
    speechRevision,
    isSaved,
  ];
}
