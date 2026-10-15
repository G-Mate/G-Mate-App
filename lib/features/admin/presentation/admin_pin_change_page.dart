import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import 'bloc/admin_pin_change_cubit.dart';
import 'bloc/admin_pin_change_state.dart';
import 'widgets/pin_pad.dart';

/// 관리 모드 - PIN 변경. 지금 PIN을 확인하고 새 PIN을 두 번 받는다.
class AdminPinChangePage extends StatelessWidget {
  const AdminPinChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminPinChangeCubit, AdminPinChangeState>(
      listenWhen: (prev, next) => !prev.isDone && next.isDone,
      listener: (context, state) {
        // 장소 관리로 돌아가도 알림이 남도록 앱의 메신저에 띄운다.
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('PIN을 바꿨어요')));
        context.pop();
      },
      builder: (context, state) {
        final cubit = context.read<AdminPinChangeCubit>();
        final (title, subtitle) = switch (state.step) {
          PinChangeStep.current => ('지금 PIN을\n입력해 주세요', '바꾸기 전에 한 번 확인해요'),
          PinChangeStep.newPin => (
            '새 PIN을\n입력해 주세요',
            '숫자 ${state.length}자리로 정해 주세요',
          ),
          PinChangeStep.confirm ||
          PinChangeStep.done => ('새 PIN을\n한 번 더 입력해 주세요', '같은 숫자를 다시 눌러 주세요'),
        };
        final message = switch (state.error) {
          PinChangeError.wrongCurrent => 'PIN이 맞지 않아요. 다시 입력해 주세요',
          PinChangeError.mismatch => '두 번 넣은 PIN이 달라요. 다시 정해 주세요',
          null => null,
        };

        return GmSplitLayout(
          heroFlex: 5,
          childFlex: 6,
          hero: GmHeroPanel(
            top: GmHeroBackButton(onPressed: () => context.pop()),
            overline: 'PIN 변경',
            title: title,
            subtitle: subtitle,
          ),
          child: Center(
            child: PinPad(
              length: state.length,
              entered: state.entered.length,
              message: message,
              onDigit: cubit.press,
              onBackspace: cubit.backspace,
            ),
          ),
        );
      },
    );
  }
}
