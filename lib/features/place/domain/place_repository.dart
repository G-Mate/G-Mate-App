import 'place.dart';

/// 장소 정보 저장소. 로봇에 저장된 위치(temi 장소)와는 따로 관리한다.
abstract interface class PlaceRepository {
  Future<List<Place>> getPlaces();

  /// [key] 장소. 없으면 null.
  Future<Place?> getPlace(String key);

  /// 같은 키가 있으면 바꾸고, 없으면 새로 추가한다.
  Future<void> savePlace(Place place);
}
