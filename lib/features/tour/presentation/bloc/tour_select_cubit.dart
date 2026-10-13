import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/tour.dart';
import '../../domain/tour_repository.dart';

/// 투어 코스 선택: 코스 목록을 불러온다.
class TourSelectCubit extends Cubit<TourSelectState> {
  TourSelectCubit(this._tours) : super(const TourSelectState());

  final TourRepository _tours;

  Future<void> load() async {
    emit(TourSelectState(isLoading: false, tours: await _tours.getTours()));
  }
}

class TourSelectState extends Equatable {
  const TourSelectState({this.isLoading = true, this.tours = const []});

  final bool isLoading;
  final List<Tour> tours;

  @override
  List<Object?> get props => [isLoading, tours];
}
