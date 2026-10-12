import 'package:flutter/material.dart';

import '../domain/place.dart';

/// 장소 카드와 목록에 쓰는 아이콘. 사진이 없을 때 흐린 배경으로도 쓴다.
///
/// 아는 장소 키는 전용 아이콘, 나머지는 분류 아이콘을 쓴다.
IconData placeIcon(Place place) =>
    _byKey[place.key] ??
    switch (place.category) {
      PlaceCategory.classroom => Icons.class_outlined,
      PlaceCategory.office => Icons.business_center_outlined,
      PlaceCategory.facility => Icons.place_outlined,
    };

const _byKey = {
  'science_lab': Icons.science_outlined,
  'computer_lab': Icons.computer_outlined,
  'teachers_office': Icons.badge_outlined,
  'admin_office': Icons.business_center_outlined,
  'library': Icons.menu_book_outlined,
  'auditorium': Icons.event_seat_outlined,
};
