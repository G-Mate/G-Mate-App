import 'package:equatable/equatable.dart';

/// 학교 개요: 사진 한 장과 문서 한 편.
///
/// 문서는 줄 단위로 쓴다. `# `로 시작하는 줄은 소제목, `- `로 시작하는 줄은
/// 목록, 빈 줄은 문단 사이를 띄운다. 나머지 줄은 본문이다.
class SchoolInfo extends Equatable {
  const SchoolInfo({
    required this.name,
    required this.document,
    this.imagePath,
  });

  /// 문서 제목으로 쓰는 학교 이름.
  final String name;
  final String document;

  /// 학교 사진 파일 경로. 없으면 화면은 학교 아이콘 그림을 쓴다.
  final String? imagePath;

  SchoolInfo copyWith({
    String? name,
    String? document,
    String? imagePath,
    bool clearImage = false,
  }) => SchoolInfo(
    name: name ?? this.name,
    document: document ?? this.document,
    imagePath: clearImage ? null : imagePath ?? this.imagePath,
  );

  @override
  List<Object?> get props => [name, document, imagePath];
}
