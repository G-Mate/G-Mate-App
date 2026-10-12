import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/place.dart';
import '../../domain/place_repository.dart';
import 'place_select_state.dart';

/// 장소 선택 화면: 장소 목록을 불러오고 분류·검색어로 거른다.
class PlaceSelectCubit extends Cubit<PlaceSelectState> {
  PlaceSelectCubit(this._places) : super(const PlaceSelectState());

  final PlaceRepository _places;

  Future<void> load() async {
    final places = await _places.getPlaces();
    emit(state.copyWith(isLoading: false, places: places));
  }

  void selectCategory(PlaceCategory? category) =>
      emit(state.copyWith(category: () => category));

  void search(String query) => emit(state.copyWith(query: query));
}
