import '../domain/tour.dart';

/// 처음 들어 있는 투어 코스. 실제 코스와 설명이 정해지면 바꾼다.
///
/// 들를 곳의 설명을 비워 두면 장소의 본 설명을 읽는다.
const seedTours = [
  Tour(
    key: 'first_visit',
    name: '첫 방문 코스',
    description: '처음 오신 분이 꼭 알아야 할 곳을 둘러봐요',
    duration: Duration(minutes: 15),
    stops: [
      TourStop(
        placeKey: 'admin_office',
        lines: ['첫 번째로 들른 곳은 행정실이에요.', '방문 신청과 증명서 발급을 이곳에서 도와드려요.'],
      ),
      TourStop(placeKey: 'teachers_office'),
      TourStop(placeKey: 'library'),
      TourStop(
        placeKey: 'auditorium',
        lines: ['마지막으로 강당이에요.', '입학식과 졸업식, 학교 행사가 이곳에서 열려요.'],
      ),
    ],
  ),
  Tour(
    key: 'classrooms',
    name: '수업 공간 코스',
    description: '학생들이 공부하고 실습하는 교실을 둘러봐요',
    duration: Duration(minutes: 10),
    stops: [
      TourStop(placeKey: 'computer_lab'),
      TourStop(placeKey: 'science_lab'),
      TourStop(placeKey: 'library'),
    ],
  ),
  Tour(
    key: 'full_tour',
    name: '학교 한 바퀴',
    description: '1층부터 3층까지 학교 전체를 둘러봐요',
    duration: Duration(minutes: 25),
    stops: [
      TourStop(placeKey: 'admin_office'),
      TourStop(placeKey: 'auditorium'),
      TourStop(placeKey: 'teachers_office'),
      TourStop(placeKey: 'library'),
      TourStop(placeKey: 'computer_lab'),
      TourStop(placeKey: 'science_lab'),
    ],
  ),
];
