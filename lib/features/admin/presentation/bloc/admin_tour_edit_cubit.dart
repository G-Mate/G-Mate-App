import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../place/domain/place_repository.dart';
import '../../../tour/domain/tour.dart';
import '../../../tour/domain/tour_repository.dart';
import '../../domain/place_image_picker.dart';
import 'admin_tour_edit_state.dart';

/// 코스 편집: 이름·소개·걸리는 시간과 들를 곳(순서 포함)을 고치고 저장한다.
///
/// [tourKey]가 null이면 새 코스를 만든다.
class AdminTourEditCubit extends Cubit<AdminTourEditState> {
  AdminTourEditCubit({
    required this._tours,
    required this._places,
    required this.tourKey,
    required this._imagePicker,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const AdminTourEditState());

  final TourRepository _tours;
  final PlaceRepository _places;
  final String? tourKey;
  final PlaceImagePicker _imagePicker;
  final DateTime Function() _now;

  Future<void> load() async {
    final places = await _places.getPlaces();
    final key = tourKey;
    final tour = key == null ? _newTour() : await _tours.getTour(key);
    if (isClosed) return;
    emit(
      AdminTourEditState(
        isLoading: false,
        tour: tour,
        isNew: key == null,
        places: places,
      ),
    );
  }

  /// 새 코스. 키는 화면에 보이지 않으니 만든 시각으로 정한다.
  Tour _newTour() => Tour(
    key: 'tour_${_now().millisecondsSinceEpoch}',
    name: '',
    description: '',
    duration: Tour.defaultDuration,
    stops: const [],
  );

  Tour get _tour => state.tour!;

  void changeName(String name) => _update(_tour.copyWith(name: name));

  void changeDescription(String text) =>
      _update(_tour.copyWith(description: text));

  void changeDuration(Duration duration) =>
      _update(_tour.copyWith(duration: duration));

  /// [사진 고르기]: 사진첩에서 고른 사진을 코스 대표 사진으로 둔다.
  Future<void> pickImage() async {
    final path = await _imagePicker.pick();
    if (path == null || isClosed) return;
    _update(_tour.copyWith(imagePath: path));
  }

  /// [사진 지우기]: 사진을 빼고 아이콘 그림으로 되돌린다.
  void removeImage() => _update(_tour.copyWith(clearImage: true));

  /// [placeKey]를 들를 곳 끝에 넣는다. 이미 있으면 넣지 않는다.
  void addStop(String placeKey) {
    if (_tour.stops.any((s) => s.placeKey == placeKey)) return;
    _update(
      _tour.copyWith(
        stops: [
          ..._tour.stops,
          TourStop(placeKey: placeKey),
        ],
      ),
    );
  }

  void removeStop(int index) =>
      _update(_tour.copyWith(stops: [..._tour.stops]..removeAt(index)));

  /// 들를 곳 순서를 바꾼다. [newIndex]는 [oldIndex]를 뺀 뒤의 자리다.
  void moveStop(int oldIndex, int newIndex) {
    final stops = [..._tour.stops];
    final stop = stops.removeAt(oldIndex);
    stops.insert(newIndex.clamp(0, stops.length), stop);
    _update(_tour.copyWith(stops: stops));
  }

  Future<void> save() async {
    if (!state.canSave) return;
    await _tours.saveTour(
      _tour.copyWith(
        name: _tour.name.trim(),
        description: _tour.description.trim(),
      ),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _update(Tour tour) => emit(state.copyWith(tour: tour));
}
