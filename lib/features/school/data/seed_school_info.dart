import '../domain/school_info.dart';

/// 처음 들어 있는 학교 소개. 실제 소개 글이 정해지면 관리 모드에서 바꾼다.
const seedSchoolInfo = SchoolInfo(
  name: '광주소프트웨어마이스터고등학교',
  intro:
      '소프트웨어 개발자를 길러 내는 학교예요. '
      '학생들은 프로젝트로 서비스를 만들며 배워요.',
  sections: [
    SchoolSection(title: '한눈에 보기', body: '2015년에 문을 열었어요.\n1학년부터 3학년까지 있어요.'),
  ],
  floorLabels: {1: '행정·행사', 2: '교무·도서', 3: '교실·실습실'},
);
