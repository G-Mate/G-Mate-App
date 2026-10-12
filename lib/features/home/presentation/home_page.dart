import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system.dart';
import 'bloc/robot_status_cubit.dart';

/// 안내 모드 홈(대기) 화면.
///
/// 왼쪽 남색 패널에 인사말과 로봇 상태, 오른쪽에 메뉴 카드 두 개를 둔다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GmScaffold(
      padded: false,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: GmHeroPanel(
              overline: '광주소프트웨어마이스터고등학교',
              title: '무엇을\n도와드릴까요?',
              subtitle: '원하는 메뉴를 눌러 주세요',
              footer: _RobotStatus(),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 길 찾기·투어 화면이 생기면 onTap을 연결한다.
                  Expanded(
                    child: GmMenuTile(
                      icon: Icons.near_me_outlined,
                      title: '길 찾기',
                      description: '가고 싶은 곳까지 데려다 드려요',
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: GmMenuTile(
                      icon: Icons.flag_outlined,
                      title: '학교 투어',
                      description: '코스를 따라 학교를 둘러봐요',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RobotStatus extends StatelessWidget {
  const _RobotStatus();

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
        return GmStatusIndicator(label: label, type: type, onDark: true);
      },
    );
  }
}
