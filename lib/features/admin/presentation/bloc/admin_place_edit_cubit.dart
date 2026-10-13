import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../place/domain/place.dart';
import '../../../place/domain/place_repository.dart';
import '../../domain/place_image_picker.dart';
import 'admin_place_edit_state.dart';

/// 장소 편집: 장소 정보와 멘트를 고치고 저장한다.
class AdminPlaceEditCubit extends Cubit<AdminPlaceEditState> {
  AdminPlaceEditCubit({
    required this._robot,
    required this._places,
    required this.placeKey,
    required this._imagePicker,
  }) : super(const AdminPlaceEditState());

  final RobotController _robot;
  final PlaceRepository _places;
  final String placeKey;
  final PlaceImagePicker _imagePicker;
  int _nextLineId = 0;

  Future<void> load() async {
    final place = await _places.getPlace(placeKey);
    emit(
      state.copyWith(
        isLoading: false,
        place: place,
        lineIds: place == null ? const [] : _newIds(place),
      ),
    );
  }

  Place get _place => state.place!;
  PlaceSpeech get _speech => _place.speech;

  void changeName(String name) => _update(_place.copyWith(name: name));

  void changeCategory(PlaceCategory category) =>
      _update(_place.copyWith(category: category));

  void changeFloor(int floor) => _update(_place.copyWith(floor: floor));

  /// 쉼표로 나눈 검색 키워드.
  void changeKeywords(String raw) => _update(
    _place.copyWith(
      keywords: [
        for (final k in raw.split(','))
          if (k.trim().isNotEmpty) k.trim(),
      ],
    ),
  );

  /// [사진 고르기]: 사진첩에서 고른 사진을 장소 사진으로 둔다.
  Future<void> pickImage() async {
    final path = await _imagePicker.pick();
    if (path == null || isClosed) return;
    _update(_place.copyWith(imagePath: path));
  }

  /// [사진 지우기]: 사진을 빼고 아이콘 그림으로 되돌린다.
  void removeImage() => _update(_place.copyWith(clearImage: true));

  /// 본 설명 줄 사이에 저절로 넘어가기까지 기다리는 시간.
  void changeLineInterval(Duration interval) =>
      _update(_place.copyWith(lineInterval: interval));

  void changeStart(String text) =>
      _update(_place.copyWith(speech: _speech.copyWith(start: text)));

  void changeArrival(String text) =>
      _update(_place.copyWith(speech: _speech.copyWith(arrival: text)));

  void changeLine(int index, String text) {
    final lines = [..._speech.descriptionLines]..[index] = text;
    _update(_place.copyWith(speech: _speech.copyWith(descriptionLines: lines)));
  }

  void addLine() => emit(
    state.copyWith(
      place: _place.copyWith(
        speech: _speech.copyWith(
          descriptionLines: [..._speech.descriptionLines, ''],
        ),
      ),
      lineIds: [...state.lineIds, _nextLineId++],
    ),
  );

  void removeLine(int index) => emit(
    state.copyWith(
      place: _place.copyWith(
        speech: _speech.copyWith(
          descriptionLines: [..._speech.descriptionLines]..removeAt(index),
        ),
      ),
      lineIds: [...state.lineIds]..removeAt(index),
    ),
  );

  /// [원래 설명으로]: 멘트를 처음 들어 있던 원본으로 되돌린다.
  void restoreOriginalSpeech() {
    final place = _place.copyWith(speech: _place.originalSpeech);
    emit(
      state.copyWith(
        place: place,
        lineIds: _newIds(place),
        speechRevision: state.speechRevision + 1,
      ),
    );
  }

  Future<void> preview(String text) => _robot.speak(text);

  /// 빈 줄은 빼고 저장한다.
  Future<void> save() async {
    final lines = [
      for (final l in _speech.descriptionLines)
        if (l.trim().isNotEmpty) l.trim(),
    ];
    await _places.savePlace(
      _place.copyWith(speech: _speech.copyWith(descriptionLines: lines)),
    );
    emit(state.copyWith(isSaved: true));
  }

  void _update(Place place) => emit(state.copyWith(place: place));

  List<int> _newIds(Place place) => [
    for (final _ in place.speech.descriptionLines) _nextLineId++,
  ];
}
