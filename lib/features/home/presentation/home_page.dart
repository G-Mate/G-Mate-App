import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/robot_status_cubit.dart';

/// 안내 모드 홈(대기) 화면.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('G-Mate', style: textTheme.displayMedium),
              const SizedBox(height: 8),
              Text('무엇을 도와드릴까요?', style: textTheme.headlineSmall),
              const SizedBox(height: 48),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  FilledButton(onPressed: null, child: const Text('길 찾기')),
                  FilledButton(onPressed: null, child: const Text('학교 투어')),
                ],
              ),
              const SizedBox(height: 48),
              const _RobotStatusLabel(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RobotStatusLabel extends StatelessWidget {
  const _RobotStatusLabel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotStatusCubit, RobotStatusState>(
      builder: (context, state) {
        final label = switch (state) {
          RobotStatusState(isChecking: true) => '로봇 연결 확인 중',
          RobotStatusState(isReady: true) => '로봇 준비 완료',
          _ => '로봇 연결 안 됨',
        };
        return Text(label, style: Theme.of(context).textTheme.bodyLarge);
      },
    );
  }
}
