import 'school_info.dart';

/// 학교 소개 저장소.
abstract interface class SchoolInfoRepository {
  Future<SchoolInfo> getSchoolInfo();

  Future<void> saveSchoolInfo(SchoolInfo info);
}
