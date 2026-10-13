import '../core/database/app_database.dart';
import '../features/place/data/drift_place_repository.dart';
import '../features/place/data/seed_places.dart';
import '../features/school/data/drift_school_info_repository.dart';
import '../features/school/data/seed_school_info.dart';
import '../features/tour/data/drift_tour_repository.dart';
import '../features/tour/data/seed_tours.dart';

/// 처음 DB를 만들 때 넣는 기본 장소·투어 코스·학교 소개.
///
/// 이미 만든 DB에는 다시 넣지 않으므로, 관리 모드에서 고친 내용이 남는다.
Future<void> seedDatabase(AppDatabase db) async {
  final places = DriftPlaceRepository(db);
  for (final place in seedPlaces) {
    await places.savePlace(place);
  }
  final tours = DriftTourRepository(db);
  for (final tour in seedTours) {
    await tours.saveTour(tour);
  }
  await DriftSchoolInfoRepository(db).saveSchoolInfo(seedSchoolInfo);
}
