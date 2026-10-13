import 'tour.dart';

/// 투어 코스 저장소.
abstract interface class TourRepository {
  Future<List<Tour>> getTours();

  /// [key] 코스. 없으면 null.
  Future<Tour?> getTour(String key);
}
