import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../place/domain/place_repository.dart';
import '../../../tour/domain/tour_repository.dart';
import 'admin_tours_state.dart';

/// 투어 관리: 코스 목록을 보여 주고 지운다.
class AdminToursCubit extends Cubit<AdminToursState> {
  AdminToursCubit({required this._tours, required this._places})
    : super(const AdminToursState());

  final TourRepository _tours;
  final PlaceRepository _places;

  /// 목록을 다시 불러온다. 코스 편집에서 돌아왔을 때도 부른다.
  Future<void> load() async {
    final tours = await _tours.getTours();
    final places = await _places.getPlaces();
    if (isClosed) return;
    emit(
      AdminToursState(
        isLoading: false,
        tours: tours,
        places: {for (final p in places) p.key: p},
      ),
    );
  }

  Future<void> delete(String key) async {
    await _tours.deleteTour(key);
    await load();
  }
}
