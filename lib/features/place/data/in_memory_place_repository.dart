import '../domain/place.dart';
import '../domain/place_repository.dart';
import 'seed_places.dart';

/// 메모리에만 두는 장소 저장소. 테스트에서 쓴다 (앱은 `DriftPlaceRepository`).
///
/// 처음 내용은 [seedPlaces]다.
class InMemoryPlaceRepository implements PlaceRepository {
  InMemoryPlaceRepository({List<Place> initialPlaces = seedPlaces})
    : _places = {for (final p in initialPlaces) p.key: p};

  final Map<String, Place> _places;

  @override
  Future<List<Place>> getPlaces() async => _places.values.toList();

  @override
  Future<Place?> getPlace(String key) async => _places[key];

  @override
  Future<void> savePlace(Place place) async => _places[place.key] = place;
}
