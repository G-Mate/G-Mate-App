import '../domain/tour.dart';
import '../domain/tour_repository.dart';
import 'seed_tours.dart';

/// 메모리에만 두는 투어 코스 저장소. 테스트에서 쓴다.
class InMemoryTourRepository implements TourRepository {
  InMemoryTourRepository({List<Tour> tours = seedTours}) : _tours = [...tours];

  final List<Tour> _tours;

  @override
  Future<List<Tour>> getTours() async => List.unmodifiable(_tours);

  @override
  Future<Tour?> getTour(String key) async {
    for (final t in _tours) {
      if (t.key == key) return t;
    }
    return null;
  }

  @override
  Future<void> saveTour(Tour tour) async {
    final i = _tours.indexWhere((t) => t.key == tour.key);
    if (i < 0) {
      _tours.add(tour);
    } else {
      _tours[i] = tour;
    }
  }

  @override
  Future<void> deleteTour(String key) async =>
      _tours.removeWhere((t) => t.key == key);
}
