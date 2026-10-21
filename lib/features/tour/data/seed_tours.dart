import '../domain/tour.dart';

/// 처음 들어 있는 투어 코스. 실제 코스가 정해지면 관리 모드에서 바꾼다.
///
/// 들를 곳에서는 장소의 본 설명을 읽는다.
const seedTours = [
  Tour(
    key: 'first_visit',
    name: '첫 방문 코스',
    description: '처음 오신 분이 꼭 알아야 할 곳을 둘러봐요',
    duration: Duration(minutes: 15),
    stops: [
      TourStop(placeKey: 'admin_office'),
      TourStop(placeKey: 'teachers_office'),
      TourStop(placeKey: 'library'),
      TourStop(placeKey: 'auditorium'),
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
