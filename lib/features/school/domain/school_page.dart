import 'package:equatable/equatable.dart';

/// 학교 개요 페이지를 이루는 블록 종류.
enum SchoolBlockType {
  /// 큰 배너: 남색 면 위의 큰 문구.
  hero,

  /// 소제목과 짧은 설명.
  heading,

  /// 본문 글.
  text,

  /// 이모지·제목·설명이 있는 카드 여러 장.
  cards,

  /// 다른 웹 페이지 링크. 키오스크라 QR 코드로 보여 준다.
  link,
}

/// 카드 묶음 블록의 카드 한 장.
class SchoolCard extends Equatable {
  const SchoolCard({this.emoji = '', required this.title, this.body = ''});

  final String emoji;
  final String title;
  final String body;

  @override
  List<Object?> get props => [emoji, title, body];
}

/// 학교 개요 페이지의 블록 하나. 종류마다 쓰는 값만 채운다.
///
/// - [SchoolBlockType.hero]: [title](작은 문구), [body](큰 문구)
/// - [SchoolBlockType.heading]: [title], [body](설명)
/// - [SchoolBlockType.text]: [body]
/// - [SchoolBlockType.cards]: [cards]
/// - [SchoolBlockType.link]: [title], [body](설명), [url]
class SchoolBlock extends Equatable {
  const SchoolBlock({
    required this.type,
    this.title = '',
    this.body = '',
    this.url = '',
    this.cards = const [],
  });

  final SchoolBlockType type;
  final String title;
  final String body;
  final String url;
  final List<SchoolCard> cards;

  @override
  List<Object?> get props => [type, title, body, url, cards];
}
