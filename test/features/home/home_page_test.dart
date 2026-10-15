import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/core/theme/app_theme.dart';
import 'package:g_mate/features/home/presentation/bloc/robot_status_cubit.dart';
import 'package:g_mate/features/home/presentation/home_page.dart';
import 'package:g_mate/features/speech/data/in_memory_speech_settings_repository.dart';
import 'package:g_mate/features/speech/presentation/bloc/voice_guide_cubit.dart';
import 'package:g_mate/features/speech/presentation/voice_scripts.dart';

void main() {
  testWidgets('홈 화면에 주요 버튼과 로봇 준비 상태를 보여 주고, 인사와 가운데 카드를 읽는다', (tester) async {
    final robot = FakeRobotController(
      stepDelay: const Duration(milliseconds: 100),
    );
    addTearDown(robot.dispose);
    final spoken = <String>[];
    robot.events.listen((e) {
      if (e is TtsStatusChanged && e.status == TtsStatus.started) {
        spoken.add(e.text);
      }
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => RobotStatusCubit(robot)..start()),
            BlocProvider(
              create: (_) => VoiceGuideCubit(
                robot: robot,
                settings: InMemorySpeechSettingsRepository(),
              )..start(VoiceScripts.home(HomePage.firstCardSpeech)),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('길 찾기'), findsOneWidget);
    expect(find.text('학교 투어'), findsOneWidget);
    expect(find.text('학교 개요'), findsOneWidget);
    expect(find.text('준비 중'), findsNothing);
    expect(find.text('로봇 준비 완료'), findsOneWidget);

    // 인사 → 가운데 카드(길 찾기) 순서로 읽는다.
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 150));
    expect(spoken, ['무엇을 도와드릴까요? 원하는 메뉴를 골라 주세요.', '길 찾기. 가고 싶은 곳까지 데려다 드려요']);

    // 화면을 누르면 더 안내하지 않는다.
    await tester.tap(find.text('로봇 준비 완료'));
    await tester.pump(const Duration(seconds: 5));
    expect(spoken, hasLength(2));
  });
}
