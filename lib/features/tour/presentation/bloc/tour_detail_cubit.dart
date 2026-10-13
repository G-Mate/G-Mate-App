import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/get_tour_visits.dart';
import '../../domain/tour.dart';
import '../../domain/tour_repository.dart';

/// 코스 하나와 들를 곳을 불러온다. 코스 확인·투어 끝 화면에서 쓴다.
class TourDetailCubit extends Cubit<TourDetailState> {
  TourDetailCubit({
    required this._tours,
    required this._getVisits,
    required this.tourKey,
  }) : super(const TourDetailState());

  final TourRepository _tours;
  final GetTourVisits _getVisits;
  final String tourKey;

  Future<void> load() async {
    final tour = await _tours.getTour(tourKey);
    final visits = tour == null ? const <TourVisit>[] : await _getVisits(tour);
    emit(TourDetailState(isLoading: false, tour: tour, visits: visits));
  }
}

class TourDetailState extends Equatable {
  const TourDetailState({
    this.isLoading = true,
    this.tour,
    this.visits = const [],
  });

  final bool isLoading;

  /// 다 불러왔는데 null이면 없는 코스다.
  final Tour? tour;
  final List<TourVisit> visits;

  @override
  List<Object?> get props => [isLoading, tour, visits];
}
