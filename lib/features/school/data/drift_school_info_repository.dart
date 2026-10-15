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
    return row == null
        ? seedSchoolInfo
        : SchoolInfo(
            name: row.name,
            document: row.document,
            imagePath: row.imagePath,
          );
  }

  @override
  Future<void> saveSchoolInfo(SchoolInfo info) => _db
      .into(_db.schoolInfos)
      .insertOnConflictUpdate(
        SchoolInfosCompanion.insert(
          id: const Value(AppDatabase.singleRowId),
          name: info.name,
          document: Value(info.document),
          imagePath: Value(info.imagePath),
        ),
      );
}
