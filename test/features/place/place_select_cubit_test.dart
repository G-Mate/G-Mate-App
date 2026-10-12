import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';
import 'package:g_mate/features/place/domain/place.dart';
import 'package:g_mate/features/place/presentation/bloc/place_select_cubit.dart';
import 'package:g_mate/features/place/presentation/bloc/place_select_state.dart';

List<String> _names(PlaceSelectState s) => [
  for (final p in s.visiblePlaces) p.name,
];

void main() {
  blocTest<PlaceSelectCubit, PlaceSelectState>(
    '분류를 고르면 그 분류 장소만 보인다',
    build: () => PlaceSelectCubit(InMemoryPlaceRepository()),
    act: (cubit) async {
      await cubit.load();
      cubit.selectCategory(PlaceCategory.office);
    },
    verify: (cubit) => expect(_names(cubit.state), ['교무실', '행정실']),
  );

  blocTest<PlaceSelectCubit, PlaceSelectState>(
    '검색어는 이름과 검색 키워드에서 띄어쓰기 없이 찾는다',
    build: () => PlaceSelectCubit(InMemoryPlaceRepository()),
    act: (cubit) async {
      await cubit.load();
      cubit.search('도서 실');
    },
    verify: (cubit) => expect(_names(cubit.state), ['도서관']),
  );

  blocTest<PlaceSelectCubit, PlaceSelectState>(
    '전체로 돌아오면 거른 분류를 푼다',
    build: () => PlaceSelectCubit(InMemoryPlaceRepository()),
    act: (cubit) async {
      await cubit.load();
      cubit
        ..selectCategory(PlaceCategory.facility)
        ..selectCategory(null);
    },
    verify: (cubit) => expect(cubit.state.visiblePlaces, hasLength(6)),
  );
}
