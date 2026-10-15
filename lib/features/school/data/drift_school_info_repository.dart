import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/school_info.dart';
import '../domain/school_info_repository.dart';
import 'seed_school_info.dart';

/// 로컬 DB(drift)에 두는 학교 소개 저장소.
class DriftSchoolInfoRepository implements SchoolInfoRepository {
  DriftSchoolInfoRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SchoolInfo> getSchoolInfo() async {
    final query = _db.select(_db.schoolInfos)
      ..where((t) => t.id.equals(AppDatabase.singleRowId));
    final row = await query.getSingleOrNull();
    // 기본 내용을 넣기 전에 만든 DB라면 처음 학교 소개를 보여 준다.
    return row == null ? seedSchoolInfo : _toInfo(row);
  }

  @override
  Future<void> saveSchoolInfo(SchoolInfo info) =>
      _db.into(_db.schoolInfos).insertOnConflictUpdate(_toRow(info));

  static SchoolInfo _toInfo(SchoolInfoRow row) => SchoolInfo(
    name: row.name,
    intro: row.intro,
    sections: [
      for (final section in jsonDecode(row.sections) as List<Object?>)
        _sectionFromJson(section! as Map<String, Object?>),
    ],
    floorLabels: {
      for (final e
          in (jsonDecode(row.floorLabels) as Map<String, Object?>).entries)
        int.parse(e.key): e.value! as String,
    },
    imagePath: row.imagePath,
  );

  static SchoolSection _sectionFromJson(Map<String, Object?> map) =>
      SchoolSection(
        title: map['title']! as String,
        body: map['body']! as String,
      );

  static SchoolInfosCompanion _toRow(SchoolInfo info) =>
      SchoolInfosCompanion.insert(
        id: const Value(AppDatabase.singleRowId),
        name: info.name,
        intro: info.intro,
        sections: Value(
          jsonEncode([
            for (final s in info.sections) {'title': s.title, 'body': s.body},
          ]),
        ),
        floorLabels: jsonEncode({
          for (final e in info.floorLabels.entries) '${e.key}': e.value,
        }),
        imagePath: Value(info.imagePath),
      );
}
