import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../speech/presentation/bloc/voice_guide_cubit.dart';
import '../../speech/presentation/bloc/voice_guide_state.dart';
import '../../speech/presentation/voice_guide_scope.dart';
import '../../speech/presentation/voice_scripts.dart';
import 'bloc/robot_status_cubit.dart';
import 'widgets/home_clock.dart';
import 'widgets/menu_carousel.dart';

/// 안내 모드 홈(대기) 화면.
///
/// 왼쪽 남색 패널에 인사말·로봇 상태·시계, 오른쪽에 세로로 넘기는 메뉴 카드를
/// 둔다. 남색 패널을 [adminHoldDuration] 동안 누르고 있으면 관리 모드 PIN으로 간다.
///
/// 들어오면 인사를 읽고, 가운데 카드를 한 번 반짝인 뒤 그 카드를 읽는다.
/// 카드를 넘기면 가운데 온 카드를 읽고, 메뉴 이름을 말해도 들어간다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// 방문객이 우연히 들어가지 않도록 길게 누르는 시간.
  static const adminHoldDuration = Duration(seconds: 3);

  /// 메뉴 카드 차례. 음성 명령 id도 함께 둔다.
  static const menus = [
    (
      command: VoiceScripts.guideCommand,
      icon: GmIcons.navigate,
      title: '길 찾기',
      description: '가고 싶은 곳까지 데려다 드려요',
      route: AppRoutes.placeSelect,
    ),
    (
      command: VoiceScripts.tourCommand,
      icon: GmIcons.tour,
      title: '학교 투어',
      description: '코스를 따라 학교를 둘러봐요',
      route: AppRoutes.tourSelect,
    ),
    (
      command: VoiceScripts.overviewCommand,
      icon: GmIcons.school,
      title: '학교 개요',
      description: '우리 학교를 한눈에 알아봐요',
      route: AppRoutes.schoolOverview,
    ),
  ];

  /// 처음 가운데에 오는 카드를 읽는 말.
  static String get firstCardSpeech =>
      VoiceScripts.card(menus.first.title, menus.first.description);

  @override
  Widget build(BuildContext context) {
    return VoiceGuideScope(
      onCommand: (context, command) {
        for (final m in menus) {
          if (m.command == command) context.push(m.route);
        }
      },
      child: GmSplitLayout(
        hero: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: {
            LongPressGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  LongPressGestureRecognizer
                >(
                  () => LongPressGestureRecognizer(duration: adminHoldDuration),
                  (r) => r.onLongPress = () => context.push(AppRoutes.adminPin),
                ),
          },
          child: const GmHeroPanel(
            overline: '광주소프트웨어마이스터고등학교',
            title: '무엇을\n도와드릴까요?',
            subtitle: '원하는 메뉴를 골라 주세요',
            footer: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _RobotStatus(),
                SizedBox(width: AppSpacing.lg),
                // 패널이 좁으면 시계를 줄여서 넘치지 않게 한다.
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                      child: HomeClock(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: BlocBuilder<VoiceGuideCubit, VoiceGuideState>(
          buildWhen: (a, b) => a.cueCount != b.cueCount,
          builder: (context, voice) => MenuCarousel(
            flashCount: voice.cue == VoiceScripts.flashCue ? voice.cueCount : 0,
            onCenterChanged: (item) => context.read<VoiceGuideCubit>().say(
              VoiceScripts.card(item.title, item.description),
            ),
            items: [
              for (final m in menus)
                HomeMenuItem(
                  icon: m.icon,
                  title: m.title,
                  description: m.description,
                  onTap: () => context.push(m.route),
                ),
            ],
          ),
        ),
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
