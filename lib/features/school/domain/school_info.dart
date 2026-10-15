import 'package:equatable/equatable.dart';

/// 학교 개요 화면 설정: 위에 보여 줄 만든 사람들과, 아래에 띄울 학교 홈페이지.
class SchoolInfo extends Equatable {
  const SchoolInfo({
    required this.teamName,
    required this.developer,
    required this.planner,
    required this.homepageUrl,
  });

  final String teamName;

  /// 개발자 이름. 여러 명이면 쉼표로 나눠 적는다.
  final String developer;

  /// 기획자 이름. 여러 명이면 쉼표로 나눠 적는다.
  final String planner;

  /// 학교 홈페이지 주소 (https).
  final String homepageUrl;

  SchoolInfo copyWith({
    String? teamName,
    String? developer,
    String? planner,
    String? homepageUrl,
  }) => SchoolInfo(
    teamName: teamName ?? this.teamName,
    developer: developer ?? this.developer,
    planner: planner ?? this.planner,
    homepageUrl: homepageUrl ?? this.homepageUrl,
  );

  @override
  List<Object?> get props => [teamName, developer, planner, homepageUrl];
}
