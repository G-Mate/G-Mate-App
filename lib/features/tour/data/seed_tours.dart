import '../domain/tour.dart';

/// 처음 들어 있는 투어 코스. temi는 1층만 다녀서 1층(본관·실습동) 장소로 짰다.
/// 실제 코스가 정해지면 관리 모드에서 바꾼다.
///
/// 들를 곳에서는 장소의 본 설명을 읽는다.
const seedTours = [
  Tour(
    key: 'first_visit',
    name: '첫 방문 코스',
    description: '처음 오신 분이 꼭 알아야 할 곳을 둘러봐요',
    duration: Duration(minutes: 10),
    stops: [
      TourStop(placeKey: 'admin_office'),
      TourStop(placeKey: 'teachers_office'),
      TourStop(placeKey: 'health_room'),
    ],
  ),
  Tour(
    key: 'practice_wing',
    name: '실습동 코스',
    description: '학생들이 실습하고 쉬는 곳을 둘러봐요',
    duration: Duration(minutes: 10),
    stops: [
      TourStop(placeKey: 'community_zone'),
      TourStop(placeKey: 'ai_service_lab'),
      TourStop(placeKey: 'fitness_room'),
    ],
  ),
  Tour(
    key: 'full_tour',
    name: '1층 한 바퀴',
    description: '본관부터 실습동까지 1층을 모두 둘러봐요',
    duration: Duration(minutes: 20),
    stops: [
      TourStop(placeKey: 'health_room'),
      TourStop(placeKey: 'principal_office'),
      TourStop(placeKey: 'admin_office'),
      TourStop(placeKey: 'broadcast_room'),
      TourStop(placeKey: 'community_zone'),
      TourStop(placeKey: 'teachers_office'),
      TourStop(placeKey: 'ai_service_lab'),
      TourStop(placeKey: 'fitness_room'),
    ],
  ),
];
