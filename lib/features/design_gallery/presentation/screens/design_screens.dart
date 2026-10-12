import 'package:flutter/widgets.dart';

import 'admin_pin_screen.dart';
import 'admin_places_screen.dart';
import 'arrival_screen.dart';
import 'guiding_screen.dart';
import 'place_confirm_screen.dart';
import 'place_select_screen.dart';

/// 디자인 미리보기에서 열 수 있는 화면 시안 목록.
///
/// `/design-gallery/<path>`로 열린다. 실제 기능 화면이 만들어지면 그 화면이
/// 이 시안의 레이아웃을 가져가고, 시안은 지운다.
class DesignScreen {
  const DesignScreen(this.path, this.title, this.page);

  final String path;
  final String title;
  final Widget page;
}

const designScreens = [
  DesignScreen('place-select', '장소 선택', PlaceSelectScreen()),
  DesignScreen('place-confirm', '장소 확인', PlaceConfirmScreen()),
  DesignScreen('guiding', '이동 중', GuidingScreen()),
  DesignScreen('arrival', '도착·설명', ArrivalScreen()),
  DesignScreen('admin-pin', '관리 모드 PIN', AdminPinScreen()),
  DesignScreen('admin-places', '장소 관리', AdminPlacesScreen()),
];
