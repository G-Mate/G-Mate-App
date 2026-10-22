import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/features/speech/data/in_memory_speech_settings_repository.dart';
import 'package:g_mate/features/speech/presentation/bloc/voice_guide_cubit.dart';
import 'package:g_mate/features/speech/presentation/widgets/idle_home_timer.dart';
import 'package:go_router/go_router.dart';

void main() {
  late FakeRobotController robot;
  late VoiceGuideCubit voice;

  setUp(() {
    robot = FakeRobotController();
    voice = VoiceGuideCubit(
      robot: robot,
      settings: InMemorySpeechSettingsRepository(),
    );
  });
  tearDown(() async {
    await voice.close();
    await robot.dispose();
  });

  Future<void> pumpDone(WidgetTester tester, {required bool active}) async {
    final router = GoRouter(
      initialLocation: '/done',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('홈')),
        GoRoute(
          path: '/done',
          builder: (_, _) => BlocProvider.value(
            value: voice,
            child: IdleHomeTimer(
              active: active,
              child: const SizedBox.expand(child: Text('끝')),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  testWidgets('안내를 마치고 10초 동안 아무것도 없으면 홈으로 간다', (tester) async {
    await pumpDone(tester, active: true);
    await tester.pump(const Duration(seconds: 9));
    expect(find.text('끝'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('홈'), findsOneWidget);
  });

  testWidgets('화면을 누르면 처음부터 다시 센다', (tester) async {
    await pumpDone(tester, active: true);
    await tester.pump(const Duration(seconds: 8));
    await tester.tap(find.text('끝'));
    await tester.pump(const Duration(seconds: 8));
    expect(find.text('끝'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('홈'), findsOneWidget);
  });

  testWidgets('안내 중에는 세지 않는다', (tester) async {
    await pumpDone(tester, active: false);
    await tester.pump(const Duration(seconds: 20));
    expect(find.text('끝'), findsOneWidget);
  });
}
