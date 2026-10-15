import 'package:equatable/equatable.dart';

/// 학교 개요 문서의 단락 하나: 소제목과 본문.
class SchoolSection extends Equatable {
  const SchoolSection({required this.title, required this.body});

  final String title;

  /// 본문. 줄을 바꾼 자리에서 화면도 줄을 바꾼다.
  final String body;

  @override
  List<Object?> get props => [title, body];
}

/// 학교 개요 화면에 문서처럼 보여 줄 학교 소개.
///
/// 맨 위에 학교 이름과 사진, 소개 글을 두고, 그 아래에 단락([sections])을
/// 차례로 둔다. 층별 안내는 장소 목록으로 만들고 층 설명만 여기 둔다.
class SchoolInfo extends Equatable {
  const SchoolInfo({
    required this.name,
    required this.intro,
    this.sections = const [],
    this.floorLabels = const {},
    this.imagePath,
  });

  final String name;

  /// 문서 맨 위의 짧은 소개 글.
  final String intro;
  final List<SchoolSection> sections;

  /// 층별 안내에서 층 번호 옆에 쓸 짧은 설명 (예: 3 → '교실·실습실').
  final Map<int, String> floorLabels;

  /// 학교 사진 파일 경로. 없으면 사진 없이 글만 보여 준다.
  final String? imagePath;

  SchoolInfo copyWith({
    String? name,
    String? intro,
    List<SchoolSection>? sections,
    Map<int, String>? floorLabels,
    String? imagePath,
    bool clearImage = false,
  }) => SchoolInfo(
    name: name ?? this.name,
    intro: intro ?? this.intro,
    sections: sections ?? this.sections,
    floorLabels: floorLabels ?? this.floorLabels,
    imagePath: clearImage ? null : imagePath ?? this.imagePath,
  );

  @override
  List<Object?> get props => [name, intro, sections, floorLabels, imagePath];
}
