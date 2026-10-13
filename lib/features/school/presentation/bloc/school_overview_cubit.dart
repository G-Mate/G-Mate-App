import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../place/domain/place.dart';
import '../../../place/domain/place_repository.dart';
import '../../domain/school_info.dart';
import '../../domain/school_info_repository.dart';

/// 학교 개요: 학교 소개와, 장소를 층별로 묶은 층별 안내를 불러온다.
class SchoolOverviewCubit extends Cubit<SchoolOverviewState> {
  SchoolOverviewCubit({required this._info, required this._places})
    : super(const SchoolOverviewState());

  final SchoolInfoRepository _info;
  final PlaceRepository _places;

  Future<void> load() async {
    final info = await _info.getSchoolInfo();
    final places = await _places.getPlaces();
    final byFloor = <int, List<Place>>{};
    for (final p in places) {
      byFloor.putIfAbsent(p.floor, () => []).add(p);
    }
    // 건물 안내판처럼 위층부터 보여 준다.
    final floors = [
      for (final floor in byFloor.keys.toList()..sort((a, b) => b - a))
        FloorDirectory(
          floor: floor,
          label: info.floorLabels[floor],
          places: byFloor[floor]!,
        ),
    ];
    emit(SchoolOverviewState(isLoading: false, info: info, floors: floors));
  }
}

/// 층 하나와 그 층의 장소들.
class FloorDirectory extends Equatable {
  const FloorDirectory({required this.floor, required this.places, this.label});

  final int floor;
  final String? label;
  final List<Place> places;

  @override
  List<Object?> get props => [floor, label, places];
}

class SchoolOverviewState extends Equatable {
  const SchoolOverviewState({
    this.isLoading = true,
    this.info,
    this.floors = const [],
  });

  final bool isLoading;
  final SchoolInfo? info;

  /// 위층부터 차례로 놓은 층별 안내.
  final List<FloorDirectory> floors;

  /// 길 찾기로 갈 수 있는 장소 수.
  int get placeCount => floors.fold(0, (sum, f) => sum + f.places.length);

  @override
  List<Object?> get props => [isLoading, info, floors];
}
