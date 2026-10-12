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
    // 시안용: 본 설명 4줄 중 2번째 줄을 읽는 중.
    const lines = sampleDescriptionLines;
    const current = 1;

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
                '${current + 1}',
                style: text.titleMedium?.copyWith(color: colors.primary),
              ),
              Text(
                ' / ${lines.length}',
                style: text.titleMedium?.copyWith(color: semantic.textDisabled),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: (current + 1) / lines.length,
                    minHeight: 4,
                    backgroundColor: colors.outlineVariant,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          _KeepAllText(
            lines[current],
            style: text.headlineLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            lines[current + 1],
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

/// 한국어 문장을 단어(띄어쓰기) 단위로만 줄바꿈한다.
///
/// Flutter 기본 줄바꿈은 글자 단위라 '교실입니/다.'처럼 단어 중간이 끊긴다.
class _KeepAllText extends StatelessWidget {
  const _KeepAllText(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (final word in text.split(' ')) Text('$word ', style: style),
      ],
    );
  }
}
