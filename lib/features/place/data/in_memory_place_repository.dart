import '../domain/place.dart';
import '../domain/place_repository.dart';
import 'seed_places.dart';

/// 메모리에만 두는 장소 저장소. 로컬 DB(drift)를 붙이기 전까지 쓴다.
///
/// 앱을 다시 켜면 [seedPlaces]로 돌아간다.
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
