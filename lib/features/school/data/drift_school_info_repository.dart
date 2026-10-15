import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/school_info.dart';
import '../domain/school_info_repository.dart';
import 'seed_school_info.dart';

/// 로컬 DB(drift)에 두는 학교 개요 설정 저장소.
class DriftSchoolInfoRepository implements SchoolInfoRepository {
  DriftSchoolInfoRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SchoolInfo> getSchoolInfo() async {
    final query = _db.select(_db.schoolInfos)
      ..where((t) => t.id.equals(AppDatabase.singleRowId));
    final row = await query.getSingleOrNull();
    // 기본 내용을 넣기 전에 만든 DB라면 처음 설정을 보여 준다.
    if (row == null) return seedSchoolInfo;
    // 옛 DB에서 옮겨 와 팀 이름이나 주소가 비어 있으면 처음 값을 쓴다.
    return SchoolInfo(
      teamName: row.teamName.isEmpty ? seedSchoolInfo.teamName : row.teamName,
      developer: row.developer,
      planner: row.planner,
      homepageUrl: row.homepageUrl.isEmpty
          ? seedSchoolInfo.homepageUrl
          : row.homepageUrl,
    );
  }

  @override
  Future<void> saveSchoolInfo(SchoolInfo info) => _db
      .into(_db.schoolInfos)
      .insertOnConflictUpdate(
        SchoolInfosCompanion.insert(
          id: const Value(AppDatabase.singleRowId),
          teamName: Value(info.teamName),
          developer: Value(info.developer),
          planner: Value(info.planner),
          homepageUrl: Value(info.homepageUrl),
        ),
      );
}
