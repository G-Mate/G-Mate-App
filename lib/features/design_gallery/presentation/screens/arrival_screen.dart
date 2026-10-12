import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 도착·설명. 오른쪽에 지금 읽고 있는 문장을 자막처럼 크게 보여 준다.
class ArrivalScreen extends StatelessWidget {
  const ArrivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final place = samplePlaces.first;
    final text = context.textStyles;
    final colors = context.colors;
    final semantic = context.appColors;

    return GmSplitLayout(
      hero: GmHeroPanel(
        overline: '도착했어요',
        title: place.name,
        subtitle: place.meta,
        footer: const GmStatusIndicator(
          label: '설명을 들려 드리는 중',
          type: GmStatusType.info,
          onDark: true,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '2',
                style: text.titleMedium?.copyWith(color: colors.primary),
              ),
              Text(
                ' / 4',
                style: text.titleMedium?.copyWith(color: semantic.textDisabled),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: 2 / 4,
                    minHeight: 4,
                    backgroundColor: colors.outlineVariant,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '실험 도구와 안전 장비가\n갖춰진 교실입니다.',
            style: text.headlineLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '물리, 화학, 생명과학 수업이 이곳에서 열려요.',
            style: text.bodyMedium?.copyWith(color: semantic.textDisabled),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GmButton(
                  label: '다시 듣기',
                  icon: Icons.replay_rounded,
                  variant: GmButtonVariant.secondary,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GmButton(
                  label: '처음으로',
                  icon: Icons.home_outlined,
                  variant: GmButtonVariant.outline,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
