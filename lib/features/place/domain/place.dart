import 'package:equatable/equatable.dart';

/// 장소 분류. 방문객 화면의 분류 칩과 같은 순서다.
enum PlaceCategory {
  classroom('교실'),
  office('행정실'),
  facility('편의시설');

  const PlaceCategory(this.label);

  /// 화면에 보이는 이름.
  final String label;
}

/// 로봇이 읽는 안내 멘트 묶음.
class PlaceSpeech extends Equatable {
  const PlaceSpeech({
    required this.start,
    required this.arrival,
    required this.descriptionLines,
  });

  /// 이동을 시작할 때 읽는 출발 멘트.
  final String start;

  /// 도착하자마자 읽는 도착 멘트.
  final String arrival;

  /// 도착 후 읽는 본 설명. 한 줄이 도착 화면의 한 페이지다.
  final List<String> descriptionLines;

  PlaceSpeech copyWith({
    String? start,
    String? arrival,
    List<String>? descriptionLines,
  }) => PlaceSpeech(
    start: start ?? this.start,
    arrival: arrival ?? this.arrival,
    descriptionLines: descriptionLines ?? this.descriptionLines,
  );

  @override
  List<Object?> get props => [start, arrival, descriptionLines];
}

/// 안내할 수 있는 학교 안 장소.
class Place extends Equatable {
  const Place({
    required this.key,
    required this.name,
    required this.floor,
    required this.category,
    required this.speech,
    required this.originalSpeech,
    this.keywords = const [],
    this.lineInterval = defaultLineInterval,
    this.imagePath,
  });

  /// 도착 화면에서 한 줄을 다 읽은 뒤 다음 줄로 저절로 넘어가기까지 기다리는
  /// 기본 시간.
  static const defaultLineInterval = Duration(seconds: 5);

  /// 관리 모드에서 고를 수 있는 기다리는 시간 범위.
  static const minLineInterval = Duration(seconds: 1);
  static const maxLineInterval = Duration(seconds: 20);

  /// temi에 저장되는 장소 키 (영문 소문자, 예: `science_lab`). 바꿀 수 없다.
  final String key;

  /// 화면에 보이는 한국어 이름.
  final String name;
  final int floor;
  final PlaceCategory category;

  /// 검색에서 이 장소를 찾을 때 쓰는 말.
  final List<String> keywords;

  /// 지금 쓰는 멘트.
  final PlaceSpeech speech;

  /// 처음 들어 있던 멘트. [원래 설명으로]가 이 값으로 되돌린다.
  final PlaceSpeech originalSpeech;

  /// 본 설명 한 줄을 다 읽은 뒤 다음 줄로 저절로 넘어가기까지 기다리는 시간.
  /// 방문객은 [다음]을 눌러 기다리지 않고 넘길 수 있다.
  final Duration lineInterval;

  /// 장소 사진 파일 경로. 없으면 화면은 장소 아이콘 그림을 쓴다.
  final String? imagePath;

  /// 관리 모드에서 현재 위치를 새 장소로 저장할 때 만드는 기본 장소.
  /// 멘트는 기본 문장으로 채우고, 본 설명은 장소 편집에서 적는다.
  factory Place.create({required String key, required String name}) {
    final speech = PlaceSpeech(
      start: '$name까지 안내할게요. 저를 따라와 주세요.',
      arrival: '$name에 도착했어요.',
      descriptionLines: const [],
    );
    return Place(
      key: key,
      name: name,
      floor: 1,
      category: PlaceCategory.classroom,
      speech: speech,
      originalSpeech: speech,
    );
  }

  /// temi 장소 키 형식: 영문 소문자로 시작하고 영문 소문자·숫자·밑줄만.
  static final keyPattern = RegExp(r'^[a-z][a-z0-9_]*$');

  /// 이름 아래 작은 글자 (예: '3층 · 교실').
  String get meta => '$floor층 · ${category.label}';

  /// 장소 확인 화면에 한 덩어리로 보여 줄 짧은 설명.
  String get summary => speech.descriptionLines.join(' ');

  /// [query]가 이름이나 검색 키워드에 들어 있는지. 띄어쓰기는 무시한다.
  bool matches(String query) {
    final q = _normalize(query);
    if (q.isEmpty) return true;
    return _normalize(name).contains(q) ||
        keywords.any((k) => _normalize(k).contains(q));
  }

  static String _normalize(String s) => s.replaceAll(' ', '').toLowerCase();

  Place copyWith({
    String? name,
    int? floor,
    PlaceCategory? category,
    List<String>? keywords,
    PlaceSpeech? speech,
    Duration? lineInterval,
    String? imagePath,
    bool clearImage = false,
  }) => Place(
    key: key,
    name: name ?? this.name,
    floor: floor ?? this.floor,
    category: category ?? this.category,
    keywords: keywords ?? this.keywords,
    speech: speech ?? this.speech,
    originalSpeech: originalSpeech,
    lineInterval: lineInterval ?? this.lineInterval,
    imagePath: clearImage ? null : imagePath ?? this.imagePath,
  );

  @override
  List<Object?> get props => [
    key,
    name,
    floor,
    category,
    keywords,
    speech,
    originalSpeech,
    lineInterval,
    imagePath,
  ];
}
