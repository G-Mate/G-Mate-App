import 'package:equatable/equatable.dart';

import '../../../place/domain/place.dart';
import '../../../tour/domain/tour.dart';

class AdminTourEditState extends Equatable {
  const AdminTourEditState({
    this.isLoading = true,
    this.tour,
    this.isNew = false,
    this.places = const [],
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 코스. 저장하기 전까지 저장소에는 반영되지 않는다.
  final Tour? tour;

  /// 새로 만드는 코스인지.
  final bool isNew;

  /// 들를 곳으로 고를 수 있는 장소 전체.
  final List<Place> places;
  final bool isSaved;

  /// 이름이 있고 들를 곳이 하나 이상이어야 저장할 수 있다.
  bool get canSave {
    final tour = this.tour;
    return tour != null && tour.name.trim().isNotEmpty && tour.stops.isNotEmpty;
  }

  /// [key] 장소. 장소 관리에서 지운 곳이면 null.
  Place? placeOf(String key) {
    for (final p in places) {
      if (p.key == key) return p;
    }
    return null;
  }

  AdminTourEditState copyWith({
    bool? isLoading,
    Tour? tour,
    bool? isNew,
    List<Place>? places,
    bool? isSaved,
  }) => AdminTourEditState(
    isLoading: isLoading ?? this.isLoading,
    tour: tour ?? this.tour,
    isNew: isNew ?? this.isNew,
    places: places ?? this.places,
    isSaved: isSaved ?? this.isSaved,
  );

  @override
  List<Object?> get props => [isLoading, tour, isNew, places, isSaved];
}
