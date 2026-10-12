import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../place/domain/place.dart';
import '../../../place/domain/place_repository.dart';
import 'admin_places_state.dart';

/// 장소 관리: 앱의 장소 목록과 로봇에 저장된 위치를 함께 보여 준다.
class AdminPlacesCubit extends Cubit<AdminPlacesState> {
  AdminPlacesCubit({required this._robot, required this._places})
    : super(const AdminPlacesState());

  final RobotController _robot;
  final PlaceRepository _places;
  StreamSubscription<RobotEvent>? _subscription;

  Future<void> start() async {
    _subscription = _robot.events.listen((event) {
      if (event is LocationsUpdated && !isClosed) {
        emit(state.copyWith(robotLocations: event.locations.toSet()));
      }
    });
    await load();
  }

  /// 목록을 다시 불러온다. 장소 편집에서 돌아왔을 때도 부른다.
  Future<void> load() async {
    final places = await _places.getPlaces();
    final locations = await _robot.getLocations();
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        places: places,
        robotLocations: locations.toSet(),
      ),
    );
  }

  /// 키가 형식에 맞고 아직 쓰지 않은 것인지. 문제가 있으면 안내 문구를 준다.
  String? validateNewKey(String key) {
    if (!Place.keyPattern.hasMatch(key)) {
      return '영문 소문자로 시작하고 영문 소문자, 숫자, _만 쓸 수 있어요';
    }
    if (state.places.any((p) => p.key == key)) return '이미 있는 키예요';
    return null;
  }

  /// 로봇이 지금 서 있는 자리를 [key]로 로봇에 저장하고 새 장소를 만든다.
  Future<void> saveCurrentLocation({
    required String key,
    required String name,
  }) async {
    await _robot.saveLocation(key);
    await _places.savePlace(Place.create(key: key, name: name));
    await load();
  }

  /// [미리 듣기]: 도착 멘트와 본 설명을 이어서 읽는다.
  Future<void> preview(Place place) => _robot.speak(
    [place.speech.arrival, ...place.speech.descriptionLines].join(' '),
  );

  /// [이동 테스트]: 로봇을 그 장소로 보낸다.
  Future<void> testMove(Place place) => _robot.goTo(place.key);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
