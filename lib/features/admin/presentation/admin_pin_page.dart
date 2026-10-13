import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/admin_pin_cubit.dart';
import 'bloc/admin_pin_state.dart';

/// 관리 모드 - PIN 입력. 맞으면 장소 관리로 간다.
class AdminPinPage extends StatelessWidget {
  const AdminPinPage({super.key});

  static const _keyWidth = 104.0;
  static const _keyHeight = 68.0;
  static const _keypadWidth = _keyWidth * 3 + AppSpacing.md * 2;
  static const _cellWidth = 60.0;
  static const _cellHeight = 72.0;
  static const _dotSize = 12.0;
  static const _backspace = '⌫';

  static const _keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    _backspace,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminPinCubit, AdminPinState>(
      listenWhen: (prev, next) => !prev.isVerified && next.isVerified,
      listener: (context, state) => context.go(AppRoutes.adminPlaces),
      builder: (context, state) {
        final colors = context.colors;
        final text = context.textStyles;
        final cubit = context.read<AdminPinCubit>();
        final entered = state.entered.length;

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
            child: SizedBox(
              width: _keypadWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 입력 칸: 입력한 칸은 점, 다음 칸은 파랑 테두리.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < state.length; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          width: _cellWidth,
                          height: _cellHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: i == entered
                                  ? colors.primary
                                  : colors.surface,
                              width: 2,
                            ),
                          ),
                          child: i < entered
                              ? Container(
                                  width: _dotSize,
                                  height: _dotSize,
                                  decoration: BoxDecoration(
                                    color: colors.onSurface,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // 틀렸을 때만 글자가 보이고, 자리는 늘 차지해 키패드가 움직이지 않는다.
                  Text(
                    state.isWrong ? 'PIN이 맞지 않아요. 다시 입력해 주세요' : '',
                    style: text.bodySmall?.copyWith(
                      color: context.appColors.danger,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (var row = 0; row < 4; row++) ...[
                    if (row > 0) const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final k in _keys.sublist(row * 3, row * 3 + 3))
                          SizedBox(
                            width: _keyWidth,
                            height: _keyHeight,
                            child: k.isEmpty
                                ? null
                                : TextButton(
                                    onPressed: k == _backspace
                                        ? cubit.backspace
                                        : () => cubit.press(k),
                                    style: TextButton.styleFrom(
                                      foregroundColor: colors.onSurface,
                                      textStyle: text.headlineMedium,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                      ),
                                    ),
                                    child: k == _backspace
                                        ? const Icon(
                                            Icons.backspace_outlined,
                                            size: AppSize.iconMd,
                                            semanticLabel: '지우기',
                                          )
                                        : Text(k),
                                  ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
