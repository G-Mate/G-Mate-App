import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/place.dart';
import '../../domain/place_repository.dart';

/// 장소 하나를 불러온다. 장소 확인 화면처럼 키로 들어오는 화면에서 쓴다.
class PlaceDetailCubit extends Cubit<PlaceDetailState> {
  PlaceDetailCubit(this._places, this.placeKey)
    : super(const PlaceDetailState());

  final PlaceRepository _places;
  final String placeKey;

  Future<void> load() async {
    final place = await _places.getPlace(placeKey);
    emit(PlaceDetailState(isLoading: false, place: place));
  }
}

class PlaceDetailState extends Equatable {
  const PlaceDetailState({this.isLoading = true, this.place});

  final bool isLoading;

  /// 불러온 장소. 다 불러왔는데 null이면 없는 장소다.
  final Place? place;

  @override
  List<Object?> get props => [isLoading, place];
}
