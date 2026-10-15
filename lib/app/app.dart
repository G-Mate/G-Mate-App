import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/robot/fake_robot_controller.dart';
import '../core/robot/robot_controller.dart';
import '../core/theme/app_theme.dart';
import '../features/speech/presentation/bloc/dev_voice_cubit.dart';
import '../features/speech/presentation/dev_voice_input.dart';
import 'di.dart';
import 'router.dart';

class GMateApp extends StatelessWidget {
  const GMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final robot = getIt<RobotController>();
    return MaterialApp.router(
      title: 'G-Mate',
      theme: AppTheme.light(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      // 개발용 빌드에서 Fake 로봇을 쓸 때만 음성 명령을 글로 넣는 버튼을 둔다.
      builder: kDebugMode && robot is FakeRobotController
          ? (context, child) => BlocProvider(
              create: (_) => DevVoiceCubit(robot),
              child: Stack(
                children: [
                  child!,
                  DevVoiceInput(
                    navigatorKey: appRouter.routerDelegate.navigatorKey,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
