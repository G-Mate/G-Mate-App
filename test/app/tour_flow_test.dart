import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/routes.dart';
import 'package:g_mate/core/design_system.dart';
import 'package:g_mate/features/guide/presentation/widgets/explanation_view.dart';
import 'package:g_mate/features/home/presentation/home_page.dart';
import 'package:g_mate/features/school/presentation/school_web_page.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('코스를 골라 모든 곳을 둘러보고 홈으로 돌아온다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies(
      locations: const ['computer_lab', 'science_lab', 'library'],
    );
    await tester.pumpWidget(testApp(AppRoutes.tourSelect));
    await tester.pumpAndSettle();
    expect(find.text('어떤 코스로 둘러볼까요?'), findsOneWidget);

    // 가운데 코스 카드를 누르면 코스 확인으로 간다.
    await tester.tap(find.text('수업 공간 코스'));
    await tester.pumpAndSettle();
    expect(find.text('이 순서로 안내해요'), findsOneWidget);
    expect(find.text('3곳'), findsOneWidget);

    await tester.tap(find.text('투어 시작'));
    await tester.pump();
    await tester.pump();
    expect(find.text('컴퓨터실로\n가고 있어요'), findsOneWidget);

    for (final name in ['컴퓨터실', '과학실', '도서관']) {
      // Fake 로봇이 이동을 마치면 설명으로 넘어간다.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text(name), findsWidgets);
      expect(find.byType(ExplanationView), findsOneWidget);
      // 설명은 [다음]으로 한 줄씩 넘기고, 마지막 줄에서 다음 곳으로 간다.
      final last = name == '도서관' ? '투어 마치기' : '다음 장소';
      while (find.text(last).evaluate().isEmpty) {
        await tester.tap(find.textContaining(RegExp(r'^다음( ·|$)')));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(last));
      await tester.pump();
    }

    await tester.pumpAndSettle();
    expect(find.text('둘러봐 주셔서\n고마워요'), findsOneWidget);

    await tester.tap(find.text('처음으로'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('코스 이름과 투어 시작을 말하면 코스 확인을 거쳐 투어가 시작된다', (tester) async {
    useTabletView(tester);
    final robot = await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.tourSelect));
    await tester.pumpAndSettle();

    await hearCommand(tester, robot, '수업 공간 코스 보여 줘');
    await tester.pumpAndSettle();
    expect(find.text('이 순서로 안내해요'), findsOneWidget);

    await hearCommand(tester, robot, '투어 시작');
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('컴퓨터실로\n가고 있어요'), findsOneWidget);

    // 이동 중에 '투어 중지'라고 하면 홈으로 돌아간다.
    await hearCommand(tester, robot, '투어 중지');
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('투어 중지는 한 번 더 묻고, 확인하면 홈으로 돌아간다', (tester) async {
    useTabletView(tester);
    final robot = await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.tourRun('classrooms')));
    await tester.pump();
    await tester.pump();

    // 묻는 동안 도착하지 않도록 Fake 로봇의 이동을 멈춰 둔다.
    await robot.stopMovement();
    await tester.tap(find.text('투어 중지'));
    await tester.pumpAndSettle();
    expect(find.text('투어를 멈출까요?'), findsOneWidget);
    await tester.tap(find.text('투어 중지').last);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    await robot.stopMovement();
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('학교 개요는 학교 소개 페이지를 넘겨 읽는다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.schoolOverview));
    await tester.pumpAndSettle();
    expect(find.text('학교 개요'), findsOneWidget);
    expect(find.textContaining('어떤 '), findsOneWidget);

    // 맨 아래까지 넘기면 QR 링크와 만든 팀이 보인다.
    await tester.scrollUntilVisible(
      find.textContaining('G-Mate'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('학교 홈페이지'), findsOneWidget);
    expect(find.text('입학 안내 (Hello, GSM)'), findsOneWidget);
    expect(find.textContaining('G-Mate'), findsOneWidget);
  });

  testWidgets('학교 개요 링크를 누르면 웹 화면이 열리고, 뒤로 가면 개요로 온다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.schoolOverview));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('학교 홈페이지'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text('학교 홈페이지'));
    await tester.pumpAndSettle();
    expect(find.byType(SchoolWebPage), findsOneWidget);
    expect(find.text('gsm.jge.hs.kr'), findsOneWidget);

    await tester.tap(find.byType(GmBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(SchoolWebPage), findsNothing);
    expect(find.text('학교 개요'), findsOneWidget);
  });
}
