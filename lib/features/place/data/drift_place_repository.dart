import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/place.dart';
import '../domain/place_repository.dart';

/// 로컬 DB(drift)에 두는 장소 저장소. 앱을 다시 켜도 고친 내용이 남는다.
///
/// 목록 순서는 처음 저장한 순서(rowid)다.
class DriftPlaceRepository implements PlaceRepository {
  DriftPlaceRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Place>> getPlaces() async {
    final query = _db.select(_db.places)
      ..orderBy([(t) => OrderingTerm.asc(t.rowId)]);
    final rows = await query.get();
    return rows.map(_toPlace).toList();
  }

  @override
  Future<Place?> getPlace(String key) async {
    final query = _db.select(_db.places)..where((t) => t.key.equals(key));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toPlace(row);
  }

  @override
  Future<void> savePlace(Place place) =>
      _db.into(_db.places).insertOnConflictUpdate(_toRow(place));

  static Place _toPlace(PlaceRow row) => Place(
    key: row.key,
    name: row.name,
    floor: row.floor,
    category:
        PlaceCategory.values.asNameMap()[row.category] ??
        PlaceCategory.classroom,
    keywords: (jsonDecode(row.keywords) as List<Object?>).cast<String>(),
    speech: _speechFromJson(row.speech),
    originalSpeech: _speechFromJson(row.originalSpeech),
    lineInterval: Duration(milliseconds: row.lineIntervalMs),
    imagePath: row.imagePath,
  );

  static PlacesCompanion _toRow(Place place) => PlacesCompanion.insert(
    key: place.key,
    name: place.name,
    floor: place.floor,
    category: place.category.name,
    keywords: jsonEncode(place.keywords),
    speech: _speechToJson(place.speech),
    originalSpeech: _speechToJson(place.originalSpeech),
    lineIntervalMs: place.lineInterval.inMilliseconds,
    imagePath: Value(place.imagePath),
  );

  static String _speechToJson(PlaceSpeech speech) => jsonEncode({
    'start': speech.start,
    'arrival': speech.arrival,
    'descriptionLines': speech.descriptionLines,
  });

  static PlaceSpeech _speechFromJson(String json) {
    final map = jsonDecode(json) as Map<String, Object?>;
    return PlaceSpeech(
      start: map['start']! as String,
      arrival: map['arrival']! as String,
      descriptionLines: (map['descriptionLines']! as List<Object?>)
          .cast<String>(),
    );
  }
}
