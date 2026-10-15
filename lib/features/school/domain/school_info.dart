import 'package:equatable/equatable.dart';

/// 학교 개요 페이지를 이루는 블록 종류.
enum SchoolBlockType {
  /// 큰 배너: 사진 위에 큰 문구.
  hero('큰 배너'),

  /// 소제목과 짧은 설명.
  heading('소제목'),

  /// 본문 글.
  text('본문'),

  /// 사진과 설명.
  image('사진'),

  /// 이모지·제목·설명이 있는 카드 여러 장.
  cards('카드 묶음'),

  /// 다른 웹 페이지 링크. 키오스크라 QR 코드로 보여 준다.
  link('링크');

  const SchoolBlockType(this.label);

  /// 관리 모드에 보이는 이름.
  final String label;
}

/// 카드 묶음 블록의 카드 한 장.
class SchoolCard extends Equatable {
  const SchoolCard({this.emoji = '', this.title = '', this.body = ''});

  final String emoji;
  final String title;
  final String body;

  SchoolCard copyWith({String? emoji, String? title, String? body}) =>
      SchoolCard(
        emoji: emoji ?? this.emoji,
        title: title ?? this.title,
        body: body ?? this.body,
      );

  @override
  List<Object?> get props => [emoji, title, body];
}

/// 학교 개요 페이지의 블록 하나. 종류마다 쓰는 값만 채운다.
///
/// - [SchoolBlockType.hero]: [title], [body](부제), [imagePath]
/// - [SchoolBlockType.heading]: [title], [body](설명)
/// - [SchoolBlockType.text]: [body]
/// - [SchoolBlockType.image]: [imagePath], [body](설명)
/// - [SchoolBlockType.cards]: [cards]
/// - [SchoolBlockType.link]: [title], [url]
class SchoolBlock extends Equatable {
  const SchoolBlock({
    required this.type,
    this.title = '',
    this.body = '',
    this.imagePath,
    this.url = '',
    this.cards = const [],
  });

  /// [type] 블록을 빈 내용으로 만든다. 카드 묶음은 빈 카드 한 장으로 시작한다.
  factory SchoolBlock.empty(SchoolBlockType type) => SchoolBlock(
    type: type,
    cards: type == SchoolBlockType.cards ? const [SchoolCard()] : const [],
  );

  final SchoolBlockType type;
  final String title;
  final String body;
  final String? imagePath;
  final String url;
  final List<SchoolCard> cards;

  SchoolBlock copyWith({
    String? title,
    String? body,
    String? imagePath,
    bool clearImage = false,
    String? url,
    List<SchoolCard>? cards,
  }) => SchoolBlock(
    type: type,
    title: title ?? this.title,
    body: body ?? this.body,
    imagePath: clearImage ? null : imagePath ?? this.imagePath,
    url: url ?? this.url,
    cards: cards ?? this.cards,
  );

  @override
  List<Object?> get props => [type, title, body, imagePath, url, cards];
}

/// 학교 개요: 블록을 위에서 아래로 쌓은 페이지와, 맨 아래에 보이는 만든 사람들.
class SchoolInfo extends Equatable {
  const SchoolInfo({
    required this.blocks,
    this.teamName = '',
    this.developer = '',
    this.planner = '',
  });

  final List<SchoolBlock> blocks;
  final String teamName;

  /// 개발자 이름. 여러 명이면 쉼표로 나눠 적는다.
  final String developer;

  /// 기획자 이름. 여러 명이면 쉼표로 나눠 적는다.
  final String planner;

  SchoolInfo copyWith({
    List<SchoolBlock>? blocks,
    String? teamName,
    String? developer,
    String? planner,
  }) => SchoolInfo(
    blocks: blocks ?? this.blocks,
    teamName: teamName ?? this.teamName,
    developer: developer ?? this.developer,
    planner: planner ?? this.planner,
  );

  @override
  List<Object?> get props => [blocks, teamName, developer, planner];
}
