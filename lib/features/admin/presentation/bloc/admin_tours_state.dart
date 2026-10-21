import 'package:equatable/equatable.dart';

import '../../../place/domain/place.dart';
import '../../../tour/domain/tour.dart';

class AdminToursState extends Equatable {
  const AdminToursState({
    this.isLoading = true,
    this.tours = const [],
    this.places = const {},
  });

  final bool isLoading;
  final List<Tour> tours;

  /// 들를 곳 이름을 보여 주려고 키로 찾는 장소.
  final Map<String, Place> places;

  @override
  List<Object?> get props => [isLoading, tours, places];
}
