import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/routes.dart';
import 'package:g_mate/features/home/presentation/home_page.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('홈에서 장소를 골라 안내를 받고 다시 홈으로 돌아온다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.home));
    await tester.pump();

    await tester.tap(find.text('길 찾기'));
    await tester.pumpAndSettle();
    expect(find.text('어디로 갈까요?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '실험');
    await tester.pumpAndSettle();
    expect(find.text('과학실'), findsOneWidget);
    expect(find.text('컴퓨터실'), findsNothing);

    await tester.tap(find.text('과학실'));
    // 장소 확인의 평면도 미리보기는 계속 돌아가므로 정해진 시간만큼만 그린다.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('이곳으로 안내할까요?'), findsOneWidget);

    // 미리보기가 전체 보기로 물러난 뒤 이동 중 화면으로 넘어간다.
    await tester.tap(find.text('안내 시작'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.textContaining('안내하고 있어요'), findsOneWidget);

    // Fake 로봇이 이동을 마치면 도착·설명으로 넘어간다.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('도착했어요'), findsOneWidget);
    expect(find.textContaining(RegExp(r'^[1-4] / 4$')), findsOneWidget);

    await tester.tap(find.text('안내 중지'));
    await tester.pumpAndSettle();
    expect(find.text('안내를 멈출까요?'), findsOneWidget);
    await tester.tap(find.text('안내 중지').last);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    // 읽던 설명 타이머를 끝낸다.
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('로봇에 없는 장소는 이동하지 못했다고 알려 준다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies(locations: const []);
    await tester.pumpWidget(testApp(AppRoutes.guiding('library')));
    await tester.pump();
    await tester.pump();

    expect(find.text('도서관으로\n가지 못했어요'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
    // 출발 멘트 타이머를 끝낸다.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('안내 중지는 한 번 더 묻고, 확인하면 홈으로 돌아간다', (tester) async {
    useTabletView(tester);
    final robot = await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.guiding('science_lab')));
    await tester.pump();
    await tester.pump();
    // 묻는 동안 도착하지 않도록 Fake 로봇의 이동을 멈춰 둔다.
    await robot.stopMovement();

    await tester.tap(find.text('안내 중지'));
    await tester.pumpAndSettle();
    expect(find.text('안내를 멈출까요?'), findsOneWidget);

    // [계속하기]면 안내를 이어 간다.
    await tester.tap(find.text('계속하기'));
    await tester.pumpAndSettle();
    expect(find.text('안내를 멈출까요?'), findsNothing);
    expect(find.textContaining('안내하고 있어요'), findsOneWidget);

    await tester.tap(find.text('안내 중지'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('안내 중지').last);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
