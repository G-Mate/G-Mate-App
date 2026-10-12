import 'package:flutter/material.dart';

/// 화면 시안에서만 쓰는 예시 장소.
class SamplePlace {
  const SamplePlace(this.name, this.floor, this.category, this.icon, this.key);

  final String name;
  final int floor;
  final String category;
  final IconData icon;

  /// temi에 저장되는 장소 키.
  final String key;

  String get meta => '$floor층 · $category';
}

const samplePlaces = [
  SamplePlace('과학실', 3, '교실', Icons.science_outlined, 'science_lab'),
  SamplePlace('컴퓨터실', 3, '교실', Icons.computer_outlined, 'computer_lab'),
  SamplePlace('교무실', 2, '행정실', Icons.badge_outlined, 'teachers_office'),
  SamplePlace('행정실', 1, '행정실', Icons.business_center_outlined, 'admin_office'),
  SamplePlace('도서관', 2, '편의시설', Icons.menu_book_outlined, 'library'),
  SamplePlace('강당', 1, '편의시설', Icons.event_seat_outlined, 'auditorium'),
];

/// 본 설명. 한 줄이 도착 화면의 한 페이지가 된다.
const sampleDescriptionLines = [
  '과학실은 3층 동쪽 끝에 있어요.',
  '실험 도구와 안전 장비가 갖춰진 교실입니다.',
  '물리, 화학, 생명과학 수업이 이곳에서 열려요.',
  '실험할 때는 꼭 보안경을 써 주세요.',
];

/// 장소 확인 화면처럼 한 덩어리로 보여 줄 때 쓰는 설명.
final sampleDescription = sampleDescriptionLines.sublist(1, 3).join(' ');
