import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/robot_status_cubit.dart';

/// 안내 모드 홈(대기) 화면.
///
/// 왼쪽 남색 패널에 인사말과 로봇 상태, 오른쪽에 메뉴 카드 두 개를 둔다.
/// 남색 패널을 [adminHoldDuration] 동안 누르고 있으면 관리 모드 PIN으로 간다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// 방문객이 우연히 들어가지 않도록 길게 누르는 시간.
  static const adminHoldDuration = Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    return GmSplitLayout(
      hero: RawGestureDetector(
        behavior: HitTestBehavior.opaque,
        gestures: {
          LongPressGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(duration: adminHoldDuration),
                (r) => r.onLongPress = () => context.push(AppRoutes.adminPin),
              ),
        },
        child: const GmHeroPanel(
          overline: '광주소프트웨어마이스터고등학교',
          title: '무엇을\n도와드릴까요?',
          subtitle: '원하는 메뉴를 눌러 주세요',
          footer: _RobotStatus(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GmMenuTile(
              icon: GmIcons.navigate,
              title: '길 찾기',
              description: '가고 싶은 곳까지 데려다 드려요',
              index: '01',
              emphasized: true,
              onTap: () => context.push(AppRoutes.placeSelect),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // 투어 선택 화면이 생기면 onTap을 연결한다.
          const Expanded(
            child: GmMenuTile(
              icon: GmIcons.tour,
              title: '학교 투어',
              description: '코스를 따라 학교를 둘러봐요',
              badge: '준비 중',
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
