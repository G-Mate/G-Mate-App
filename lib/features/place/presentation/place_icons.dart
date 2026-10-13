import '../../../core/widgets/gm_icon.dart';
import '../domain/place.dart';

/// 장소 카드와 목록에 쓰는 G-Mate 아이콘.
///
/// 아는 장소 키는 전용 아이콘, 나머지는 분류 아이콘을 쓴다.
GmIcons placeIcon(Place place) =>
    _byKey[place.key] ??
    switch (place.category) {
      PlaceCategory.classroom => GmIcons.classroom,
      PlaceCategory.office => GmIcons.office,
      PlaceCategory.facility => GmIcons.place,
    };

const _byKey = {
  'science_lab': GmIcons.science,
  'computer_lab': GmIcons.computer,
  'teachers_office': GmIcons.teacher,
  'admin_office': GmIcons.office,
  'library': GmIcons.library,
  'auditorium': GmIcons.auditorium,
};
