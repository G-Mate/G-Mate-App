import '../../place/domain/place_repository.dart';
import 'tour.dart';

/// 코스의 들를 곳에 장소 정보를 붙인다.
///
/// 장소 저장소에 없는 곳(관리 모드에서 지운 곳 등)은 건너뛴다. 장소의 본
/// 설명을 읽고, 본 설명이 없으면 도착 멘트를 읽는다. 길 찾기와 같은 설명이다.
class GetTourVisits {
  const GetTourVisits(this._places);

  final PlaceRepository _places;

  Future<List<TourVisit>> call(Tour tour) async {
    final visits = <TourVisit>[];
    for (final stop in tour.stops) {
      final place = await _places.getPlace(stop.placeKey);
      if (place == null) continue;
      final lines = place.speech.descriptionLines.isNotEmpty
          ? place.speech.descriptionLines
          : [place.speech.arrival];
      visits.add(TourVisit(place: place, lines: lines));
    }
    return visits;
  }
}
