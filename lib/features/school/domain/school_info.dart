import 'package:equatable/equatable.dart';

/// 학교 개요에 크게 보여 줄 숫자 하나 (예: 2015 / 개교).
class SchoolStat extends Equatable {
  const SchoolStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  List<Object?> get props => [value, label];
}

/// 학교 개요 화면에 보여 줄 학교 소개.
class SchoolInfo extends Equatable {
  const SchoolInfo({
    required this.name,
    required this.intro,
    required this.stats,
    this.floorLabels = const {},
    this.imagePath,
  });

  final String name;

  /// 학교를 소개하는 짧은 글.
  final String intro;
  final List<SchoolStat> stats;

  /// 층별 안내에서 층 번호 옆에 쓸 짧은 설명 (예: 3 → '교실·실습실').
  final Map<int, String> floorLabels;

  /// 학교 사진 파일 경로. 없으면 화면은 학교 아이콘 그림을 쓴다.
  final String? imagePath;

  @override
  List<Object?> get props => [name, intro, stats, floorLabels, imagePath];
}
