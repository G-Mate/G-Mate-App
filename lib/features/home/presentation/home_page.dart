import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system.dart';
import 'bloc/robot_status_cubit.dart';

/// 안내 모드 홈(대기) 화면.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GmScaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: -AppSpacing.xxl,
            right: -AppSpacing.xl,
            child: GmWatermark('GSM'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GmPageHeading(
                eyebrow: 'G-MATE',
                title: '무엇을 도와드릴까요?',
                subtitle: '원하는 메뉴를 눌러 주세요',
              ),
              const SizedBox(height: AppSpacing.xl),
              const Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 길 찾기·투어 화면이 생기면 onTap을 연결한다.
                    Expanded(
                      child: GmMenuTile(
                        emphasized: true,
                        icon: Icons.near_me_rounded,
                        title: '길 찾기',
                        description: '가고 싶은 곳까지 데려다 드려요',
                      ),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: GmMenuTile(
                        icon: Icons.tour_rounded,
                        title: '학교 투어',
                        description: '코스를 따라 학교를 둘러봐요',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _RobotStatusBanner(),
            ],
          ),
        ],
      ),
    );
  }
}

class _RobotStatusBanner extends StatelessWidget {
  const _RobotStatusBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotStatusCubit, RobotStatusState>(
      builder: (context, state) {
        final (label, type) = switch (state) {
          RobotStatusState(isChecking: true) => (
            '로봇 연결 확인 중',
            GmStatusType.info,
          ),
          RobotStatusState(isReady: true) => ('로봇 준비 완료', GmStatusType.success),
          _ => ('로봇 연결 안 됨', GmStatusType.danger),
        };
        return GmStatusBanner(message: label, type: type);
      },
    );
  }
}
