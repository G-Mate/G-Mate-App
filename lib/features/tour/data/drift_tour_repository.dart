import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/tour.dart';
import '../domain/tour_repository.dart';

/// 로컬 DB(drift)에 두는 투어 코스 저장소. 목록 순서는 저장한 순서(rowid)다.
class DriftTourRepository implements TourRepository {
  DriftTourRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Tour>> getTours() async {
    final query = _db.select(_db.tours)
      ..orderBy([(t) => OrderingTerm.asc(t.rowId)]);
    final rows = await query.get();
    return List.unmodifiable(rows.map(_toTour));
  }

  @override
  Future<Tour?> getTour(String key) async {
    final query = _db.select(_db.tours)..where((t) => t.key.equals(key));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toTour(row);
  }

  /// 같은 키가 있으면 바꾸고, 없으면 새로 추가한다.
  Future<void> saveTour(Tour tour) =>
      _db.into(_db.tours).insertOnConflictUpdate(_toRow(tour));

  static Tour _toTour(TourRow row) => Tour(
    key: row.key,
    name: row.name,
    description: row.description,
    duration: Duration(minutes: row.durationMinutes),
    stops: [
      for (final stop in jsonDecode(row.stops) as List<Object?>)
        _stopFromJson(stop! as Map<String, Object?>),
    ],
    imagePath: row.imagePath,
  );

  static TourStop _stopFromJson(Map<String, Object?> map) => TourStop(
    placeKey: map['placeKey']! as String,
    lines: (map['lines']! as List<Object?>).cast<String>(),
  );

  static ToursCompanion _toRow(Tour tour) => ToursCompanion.insert(
    key: tour.key,
    name: tour.name,
    description: tour.description,
    durationMinutes: tour.duration.inMinutes,
    stops: jsonEncode([
      for (final stop in tour.stops)
        {'placeKey': stop.placeKey, 'lines': stop.lines},
    ]),
    imagePath: Value(tour.imagePath),
  );
}
