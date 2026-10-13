import 'package:equatable/equatable.dart';

import '../../place/domain/place.dart';

/// 투어 코스에서 들르는 곳 하나.
class TourStop extends Equatable {
  const TourStop({required this.placeKey, this.lines = const []});

  /// 들를 장소의 키 ([Place.key]).
  final String placeKey;

  /// 이 코스에서 읽을 설명. 비어 있으면 장소의 본 설명을 읽는다.
  final List<String> lines;

  @override
  List<Object?> get props => [placeKey, lines];
}

/// 정해진 순서로 여러 곳을 들르는 학교 투어 코스.
class Tour extends Equatable {
  const Tour({
    required this.key,
    required this.name,
    required this.description,
    required this.duration,
    required this.stops,
    this.imagePath,
  });

  final String key;

  /// 화면에 보이는 코스 이름 (예: '첫 방문 코스').
  final String name;

  /// 코스를 한 줄로 소개하는 글.
  final String description;

  /// 코스를 다 도는 데 걸리는 어림 시간.
  final Duration duration;
  final List<TourStop> stops;

  /// 코스 대표 사진 파일 경로. 없으면 화면은 아이콘 그림을 쓴다.
  final String? imagePath;

  /// 화면에 보이는 걸리는 시간 (예: '약 15분').
  String get durationLabel => '약 ${duration.inMinutes}분';

  @override
  List<Object?> get props => [
    key,
    name,
    description,
    duration,
    stops,
    imagePath,
  ];
}

/// 장소 정보를 붙인 들를 곳. 화면과 투어 진행은 이 값을 쓴다.
class TourVisit extends Equatable {
  const TourVisit({required this.place, required this.lines});

  final Place place;

  /// 도착해서 읽을 설명. 한 줄이 한 페이지다.
  final List<String> lines;

  @override
  List<Object?> get props => [place, lines];
}
