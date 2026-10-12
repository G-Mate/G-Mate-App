import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 화면 머리 제목: 작은 파랑 머리말 + 큰 제목 + 작은 부제.
///
/// 크기 차이를 크게 두어 화면마다 같은 리듬의 대비를 만든다.
class GmPageHeading extends StatelessWidget {
  const GmPageHeading({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
  });

  final String title;

  /// 제목 위 작은 글자 (예: 'G-MATE', 'STEP 2').
  final String? eyebrow;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          GmEyebrow(eyebrow!),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          title,
          style: text.displaySmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// 섹션 머리: 번호(또는 짧은 표시) + 제목 + 오른쪽으로 이어지는 가는 선.
class GmSectionHeader extends StatelessWidget {
  const GmSectionHeader({super.key, required this.title, this.index});

  final String title;

  /// 앞에 붙는 작은 번호 (예: '01').
  final String? index;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (index != null) ...[
          Text(
            index!,
            style: text.labelSmall?.copyWith(
              color: context.colors.primary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(title, style: text.titleLarge),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Container(height: 1, color: context.colors.outlineVariant),
        ),
      ],
    );
  }
}

/// 짧은 파랑 막대 + 자간을 넓힌 작은 글자. 제목 위 머리말에 쓴다.
class GmEyebrow extends StatelessWidget {
  const GmEyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 3, color: color),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: context.textStyles.labelSmall?.copyWith(
            color: color,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
