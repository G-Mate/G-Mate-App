import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/theme/app_theme.dart';
import 'package:g_mate/features/home/presentation/bloc/robot_status_cubit.dart';
import 'package:g_mate/features/home/presentation/home_page.dart';

void main() {
  testWidgets('홈 화면에 주요 버튼과 로봇 준비 상태를 보여준다', (tester) async {
    final robot = FakeRobotController();
    addTearDown(robot.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: BlocProvider(
          create: (_) => RobotStatusCubit(robot)..start(),
          child: const HomePage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('길 찾기'), findsOneWidget);
    expect(find.text('학교 투어'), findsOneWidget);
    expect(find.text('로봇 준비 완료'), findsOneWidget);
  });
}
