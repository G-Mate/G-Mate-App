import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../../core/robot/robot_event.dart';
import '../../../place/domain/place.dart';
import '../../../place/domain/place_repository.dart';
import 'admin_places_state.dart';

/// 장소 관리: 앱의 장소 목록과 로봇에 저장된 위치를 함께 보여 준다.
///
/// temi 지도에 저장된 위치 중 앱에 없는 것은 위치 이름을 그대로 이름으로 한
/// 새 장소로 가져온다. 멘트와 설명은 장소 편집에서 채운다.
class AdminPlacesCubit extends Cubit<AdminPlacesState> {
  AdminPlacesCubit({required this._robot, required this._places})
    : super(const AdminPlacesState());

  final RobotController _robot;
  final PlaceRepository _places;
  StreamSubscription<RobotEvent>? _subscription;

  Future<void> start() async {
    _subscription = _robot.events.listen((event) {
      if (event is LocationsUpdated && !isClosed) load();
    });
    await load();
  }

  /// 목록을 다시 불러온다. 장소 편집에서 돌아왔을 때도 부른다.
  Future<void> load() async {
    final locations = await _robotLocations();
    await _importRobotLocations(locations);
    final places = await _places.getPlaces();
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        places: places,
        robotLocations: locations.toSet(),
      ),
    );
  }

  /// temi에 저장된 위치. 로봇이 준비되지 않았으면(에뮬레이터 실기 모드 등) 빈 목록.
  Future<List<String>> _robotLocations() async {
    try {
      return await _robot.getLocations();
    } on Exception {
      return const [];
    }
  }

  /// temi에만 있고 앱에 없는 위치를 새 장소로 넣는다. 충전 위치는 빼고,
  /// 이미 있는 장소는 고치지 않는다.
  Future<void> _importRobotLocations(List<String> locations) async {
    final known = {for (final p in await _places.getPlaces()) p.key};
    for (final location in locations) {
      if (location == temiHomeBase || known.contains(location)) continue;
      await _places.savePlace(Place.create(key: location, name: location));
    }
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
    // 앱 장소를 먼저 넣어, 로봇의 위치 변경 알림으로 가져오기가 돌 때
    // 위치 이름으로 덮어쓰지 않게 한다.
    await _places.savePlace(Place.create(key: key, name: name));
    await _robot.saveLocation(key);
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
