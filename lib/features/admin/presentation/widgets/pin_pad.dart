import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// PIN 입력 칸 + 안내 글 + 숫자 키패드. PIN 입력과 PIN 변경 화면이 같이 쓴다.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.length,
    required this.entered,
    required this.onDigit,
    required this.onBackspace,
    this.message,
  });

  /// PIN 자릿수.
  final int length;

  /// 지금까지 넣은 자릿수.
  final int entered;

  /// 칸 아래 빨간 안내 글. 없어도 자리는 차지해 키패드가 움직이지 않는다.
  final String? message;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

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
    final colors = context.colors;
    final text = context.textStyles;

    return SizedBox(
      width: _keypadWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 입력 칸: 입력한 칸은 점, 다음 칸은 파랑 테두리.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  width: _cellWidth,
                  height: _cellHeight,
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
          Text(
            message ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: context.appColors.danger),
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
                                ? onBackspace
                                : () => onDigit(k),
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
    );
  }
}
