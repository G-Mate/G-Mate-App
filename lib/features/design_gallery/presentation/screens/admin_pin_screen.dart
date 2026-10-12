import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 시안: 관리 모드 - PIN 입력.
class AdminPinScreen extends StatelessWidget {
  const AdminPinScreen({super.key});

  static const _pinLength = 4;
  static const _keyWidth = 128.0;
  static const _keypadWidth = _keyWidth * 3 + AppSpacing.md * 2;

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
    '⌫',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    const entered = 2;

    return GmSplitLayout(
      heroFlex: 5,
      childFlex: 6,
      hero: GmHeroPanel(
        top: GmHeroBackButton(
          onPressed: () => Navigator.of(context).maybePop(),
        ),
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
              // 입력 칸: 카드 4개. 입력한 칸은 점, 다음 칸은 파랑 테두리.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < _pinLength; i++)
                    Container(
                      width: 88,
                      height: 104,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: i == entered ? colors.primary : colors.surface,
                          width: 2,
                        ),
                      ),
                      child: i < entered
                          ? Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.navy,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              for (var row = 0; row < 4; row++) ...[
                if (row > 0) const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final k in _keys.sublist(row * 3, row * 3 + 3))
                      SizedBox(
                        width: _keyWidth,
                        height: 76,
                        child: k.isEmpty
                            ? null
                            : TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: colors.onSurface,
                                  textStyle: text.headlineMedium,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                  ),
                                ),
                                child: k == '⌫'
                                    ? const Icon(
                                        Icons.backspace_outlined,
                                        size: AppSize.iconMd,
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
  }
}
