import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/router.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/features/home/presentation/home_page.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('말로 장소를 고르고 안내를 시작한 뒤, 말로 안내를 멈춘다', (tester) async {
    useTabletView(tester);
    // 안내 중지를 말할 틈이 있도록 이동을 조금 느리게 흉내 낸다.
    final robot = await registerTestDependencies(
      stepDelay: const Duration(milliseconds: 300),
    );
    final spoken = <String>[];
    robot.events.listen((e) {
      if (e is TtsStatusChanged && e.status == TtsStatus.started) {
        spoken.add(e.text);
      }
    });

    await tester.pumpWidget(testApp(AppRoutes.placeSelect));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(spoken, contains('길 찾기. 어디로 갈까요?'));

    // 3초 동안 누르지 않으면 할 수 있는 말을 안내한다.
    await tester.pump(const Duration(seconds: 3));
    expect(spoken.last, contains('장소 목록이라고 말씀해 주세요'));

    await tester.pump(const Duration(milliseconds: 400));
    await hearCommand(tester, robot, '장소 목록');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(spoken.last, startsWith('갈 수 있는 곳은 과학실, 컴퓨터실'));

    debugPrint('SPOKEN $spoken');
    await hearCommand(tester, robot, '과학실로 가 줘');
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('이곳으로 안내할까요?'), findsOneWidget);
    expect(spoken, contains('과학실. 이곳으로 안내할까요?'));

    await hearCommand(tester, robot, '안내 시작');
    // 평면도 미리보기가 물러난 뒤 이동 중 화면으로 넘어간다.
    for (
      var i = 0;
      i < 20 && find.textContaining('안내하고 있어요').evaluate().isEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.textContaining('안내하고 있어요'), findsOneWidget);
    await tester.pump();
    expect(spoken.last, contains('안내 중지라고 말씀해 주세요'));

    await hearCommand(tester, robot, '안내 중지');
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    // 홈 인사와 남은 타이머를 끝낸다.
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('장소 확인에서 취소라고 하면 장소 선택으로 돌아간다', (tester) async {
    useTabletView(tester);
    final robot = await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.placeSelect));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('과학실'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('이곳으로 안내할까요?'), findsOneWidget);

    await hearCommand(tester, robot, '취소');
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('이곳으로 안내할까요?'), findsNothing);
    expect(find.text('어디로 갈까요?'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
