import '../domain/school_info.dart';

/// 처음 들어 있는 학교 소개. 실제 소개 글과 숫자가 정해지면 바꾼다.
const seedSchoolInfo = SchoolInfo(
  name: '광주소프트웨어마이스터고등학교',
  // 남색 패널 폭에 맞춰 문장마다 줄을 나눈다.
  intro:
      '소프트웨어 개발자를 길러 내는 학교예요.\n'
      '학생들은 프로젝트로 서비스를 만들며 배워요.',
  stats: [
    SchoolStat(value: '2015', label: '개교'),
    SchoolStat(value: '3', label: '학년'),
  ],
  floorLabels: {1: '행정·행사', 2: '교무·도서', 3: '교실·실습실'},
);
