import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/admin_pin_cubit.dart';
import 'bloc/admin_pin_state.dart';
import 'widgets/pin_pad.dart';

/// 관리 모드 - PIN 입력. 맞으면 관리 모드 메인으로 간다.
class AdminPinPage extends StatelessWidget {
  const AdminPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminPinCubit, AdminPinState>(
      listenWhen: (prev, next) => !prev.isVerified && next.isVerified,
      listener: (context, state) => context.go(AppRoutes.adminHome),
      builder: (context, state) {
        final cubit = context.read<AdminPinCubit>();
        return GmSplitLayout(
          heroFlex: 5,
          childFlex: 6,
          hero: GmHeroPanel(
            top: GmHeroBackButton(onPressed: () => context.go(AppRoutes.home)),
            overline: '관리 모드',
            title: 'PIN을\n입력해 주세요',
            subtitle: '선생님과 관리자만 들어갈 수 있어요',
          ),
          child: Center(
            child: PinPad(
              length: state.length,
              entered: state.entered.length,
              message: state.isWrong ? 'PIN이 맞지 않아요. 다시 입력해 주세요' : null,
              onDigit: cubit.press,
              onBackspace: cubit.backspace,
            ),
          ),
        );
      },
    );
  }
}
