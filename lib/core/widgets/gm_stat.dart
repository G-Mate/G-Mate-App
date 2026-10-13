import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 큰 숫자 + 작은 설명으로 된 숫자 하나 (예: 2015 / 개교, 4곳 / 둘러볼 곳).
///
/// 남색 패널 아래쪽에 여러 개를 나란히 둘 때 쓴다. [onDark]면 남색 면 위
/// 글자색을 쓴다.
class GmStat extends StatelessWidget {
  const GmStat({
    super.key,
    required this.value,
    required this.label,
    this.onDark = true,
  });

  final String value;
  final String label;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Semantics(
      label: '$label $value',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: text.headlineLarge?.copyWith(
              color: onDark ? Colors.white : null,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: text.bodySmall?.copyWith(
              color: onDark
                  ? AppColors.onNavyMuted
                  : context.appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// [GmStat] 여러 개를 일정한 간격으로 나란히 둔다.
class GmStatRow extends StatelessWidget {
  const GmStatRow({super.key, required this.stats});

  final List<GmStat> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xxl,
      runSpacing: AppSpacing.md,
      children: stats,
    );
  }
}
