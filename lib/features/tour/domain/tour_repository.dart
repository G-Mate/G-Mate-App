import 'tour.dart';

/// 투어 코스 저장소.
abstract interface class TourRepository {
  Future<List<Tour>> getTours();

  /// [key] 코스. 없으면 null.
  Future<Tour?> getTour(String key);

  /// 같은 키가 있으면 바꾸고, 없으면 목록 끝에 추가한다.
  Future<void> saveTour(Tour tour);

  /// [key] 코스를 지운다. 없으면 아무 일도 하지 않는다.
  Future<void> deleteTour(String key);
}
