import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 시안: 관리 모드 - PIN 입력.
class AdminPinScreen extends StatelessWidget {
  const AdminPinScreen({super.key});

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < entered ? colors.primary : colors.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.9,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final k in _keys)
                  k.isEmpty
                      ? const SizedBox.shrink()
                      : Material(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Center(
                              child: Text(k, style: text.headlineMedium),
                            ),
                          ),
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
