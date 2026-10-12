import 'package:equatable/equatable.dart';

import '../../../place/domain/place.dart';

class AdminPlacesState extends Equatable {
  const AdminPlacesState({
    this.isLoading = true,
    this.places = const [],
    this.robotLocations = const {},
  });

  final bool isLoading;
  final List<Place> places;

  /// 로봇(temi)에 저장된 장소 키.
  final Set<String> robotLocations;

  bool isOnRobot(Place place) => robotLocations.contains(place.key);

  AdminPlacesState copyWith({
    bool? isLoading,
    List<Place>? places,
    Set<String>? robotLocations,
  }) => AdminPlacesState(
    isLoading: isLoading ?? this.isLoading,
    places: places ?? this.places,
    robotLocations: robotLocations ?? this.robotLocations,
  );

  @override
  List<Object?> get props => [isLoading, places, robotLocations];
}
