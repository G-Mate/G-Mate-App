import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/school_info.dart';
import '../domain/school_info_repository.dart';
import 'seed_school_info.dart';

/// 로컬 DB(drift)에 두는 학교 개요 저장소. 블록은 JSON 글자로 둔다.
class DriftSchoolInfoRepository implements SchoolInfoRepository {
  DriftSchoolInfoRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SchoolInfo> getSchoolInfo() async {
    final query = _db.select(_db.schoolInfos)
      ..where((t) => t.id.equals(AppDatabase.singleRowId));
    final row = await query.getSingleOrNull();
    // 기본 내용을 넣기 전에 만든 DB라면 처음 학교 개요를 보여 준다.
    if (row == null) return seedSchoolInfo;
    return SchoolInfo(
      teamName: row.teamName,
      developer: row.developer,
      planner: row.planner,
      blocks: [
        for (final b in jsonDecode(row.blocks) as List<Object?>)
          _blockFromJson(b! as Map<String, Object?>),
      ],
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
          blocks: Value(jsonEncode([for (final b in info.blocks) _toJson(b)])),
        ),
      );

  static SchoolBlock _blockFromJson(Map<String, Object?> map) => SchoolBlock(
    type: SchoolBlockType.values.byName(map['type']! as String),
    title: map['title'] as String? ?? '',
    body: map['body'] as String? ?? '',
    imagePath: map['imagePath'] as String?,
    url: map['url'] as String? ?? '',
    cards: [
      for (final c in map['cards'] as List<Object?>? ?? const [])
        SchoolCard(
          emoji: (c! as Map<String, Object?>)['emoji'] as String? ?? '',
          title: (c as Map<String, Object?>)['title'] as String? ?? '',
          body: c['body'] as String? ?? '',
        ),
    ],
  );

  static Map<String, Object?> _toJson(SchoolBlock b) => {
    'type': b.type.name,
    'title': b.title,
    'body': b.body,
    'imagePath': b.imagePath,
    'url': b.url,
    'cards': [
      for (final c in b.cards)
        {'emoji': c.emoji, 'title': c.title, 'body': c.body},
    ],
  };
}
