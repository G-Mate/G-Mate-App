import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/routes.dart';

import '../helpers/test_app.dart';

void main() {
  final screens = {
    '홈': AppRoutes.home,
    '장소 선택': AppRoutes.placeSelect,
    '장소 확인': AppRoutes.placeConfirm('science_lab'),
    '이동 중': AppRoutes.guiding('science_lab'),
    '도착·설명': AppRoutes.arrival('science_lab'),
    '관리 모드 PIN': AppRoutes.adminPin,
    '관리 모드 메인': AppRoutes.adminHome,
    '장소 관리': AppRoutes.adminPlaces,
    '장소 편집': AppRoutes.adminPlaceEdit('science_lab'),
    '음성 설정': AppRoutes.adminTts,
    'PIN 변경': AppRoutes.adminPinChange,
    '투어 관리': AppRoutes.adminTours,
    '코스 편집': AppRoutes.adminTourEdit('full_tour'),
    '새 코스': AppRoutes.adminTourNew,
    '학교 개요': AppRoutes.schoolOverview,
    '투어 코스 선택': AppRoutes.tourSelect,
    '투어 코스 확인': AppRoutes.tourConfirm('full_tour'),
    '투어 진행': AppRoutes.tourRun('full_tour'),
    '투어 끝': AppRoutes.tourDone('full_tour'),
  };

  for (final MapEntry(key: name, value: path) in screens.entries) {
    testWidgets('$name 화면이 가로 태블릿 크기에서 넘침 없이 그려진다', (tester) async {
      useTabletView(tester);
      final robot = await registerTestDependencies();

      await tester.pumpWidget(testApp(path));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);

      // 남은 로봇 타이머를 끝낸다.
      await robot.stopMovement();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }

  testWidgets('없는 장소 키로 들어오면 안내 화면을 보여 준다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();

    await tester.pumpWidget(testApp(AppRoutes.placeConfirm('nowhere')));
    await tester.pump();

    expect(find.text('장소를 찾을 수 없어요'), findsOneWidget);
    // 뒤에 깔린 장소 선택의 음성 안내(읽던 말)를 끝낸다.
    await tester.pump(const Duration(seconds: 1));
  });
}
