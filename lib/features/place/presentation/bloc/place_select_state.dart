import 'package:equatable/equatable.dart';

import '../../domain/place.dart';

class PlaceSelectState extends Equatable {
  const PlaceSelectState({
    this.isLoading = true,
    this.places = const [],
    this.category,
    this.query = '',
  });

  final bool isLoading;
  final List<Place> places;

  /// 고른 분류. null이면 전체.
  final PlaceCategory? category;
  final String query;

  /// 분류와 검색어로 거른 장소.
  List<Place> get visiblePlaces => [
    for (final p in places)
      if ((category == null || p.category == category) && p.matches(query)) p,
  ];

  PlaceSelectState copyWith({
    bool? isLoading,
    List<Place>? places,
    PlaceCategory? Function()? category,
    String? query,
  }) => PlaceSelectState(
    isLoading: isLoading ?? this.isLoading,
    places: places ?? this.places,
    category: category != null ? category() : this.category,
    query: query ?? this.query,
  );

  @override
  List<Object?> get props => [isLoading, places, category, query];
}
