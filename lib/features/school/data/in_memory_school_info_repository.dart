import '../domain/school_info.dart';
import '../domain/school_info_repository.dart';
import 'seed_school_info.dart';

/// 메모리에만 두는 학교 소개 저장소. 테스트에서 쓴다.
class InMemorySchoolInfoRepository implements SchoolInfoRepository {
  InMemorySchoolInfoRepository({this._info = seedSchoolInfo});

  final SchoolInfo _info;

  @override
  Future<SchoolInfo> getSchoolInfo() async => _info;
}
