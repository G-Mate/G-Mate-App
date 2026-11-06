import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/floor_plan/first_floor_layout.dart';
import 'package:g_mate/features/place/data/seed_places.dart';

void main() {
  test('예시 장소는 모두 1층 평면도에 방이 있다', () {
    for (final place in seedPlaces) {
      expect(FirstFloorLayout.room(place.key), isNotNull, reason: place.key);
    }
  });

  test('충전 위치에서 본관 서쪽 방은 가운데 복도를 지나 서쪽 복도로 간다', () {
    final route = FirstFloorLayout.route(to: 'admin_office')!;
    expect(route.first, FirstFloorLayout.homeBase);
    expect(route, contains(const Offset(506, 346)));
    expect(route.last, FirstFloorLayout.room('admin_office')!.door);
  });

  test('같은 복도의 방끼리는 복도를 따라 바로 간다', () {
    final route = FirstFloorLayout.route(
      from: 'teachers_office',
      to: 'ai_service_lab',
    )!;
    expect(route, [
      const Offset(731, 375),
      const Offset(731, 402),
      const Offset(1087, 402),
      const Offset(1087, 375),
    ]);
  });

  test('평면도에 없는 장소는 경로가 없다', () {
    expect(FirstFloorLayout.route(to: 'rooftop'), isNull);
    expect(FirstFloorLayout.room(null), isNull);
  });
}
