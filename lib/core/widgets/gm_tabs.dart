import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 글자와 짧은 밑줄로 된 탭 (카테고리, 층 전환).
class GmTabs extends StatelessWidget {
  const GmTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i++)
          Semantics(
            button: true,
            selected: i == selectedIndex,
            child: InkWell(
              onTap: () => onSelected(i),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSize.touchTargetMin,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        labels[i],
                        style: text.titleMedium?.copyWith(
                          color: i == selectedIndex
                              ? colors.onSurface
                              : context.appColors.textDisabled,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AnimatedContainer(
                        duration: AppDuration.normal,
                        width: i == selectedIndex ? 28 : 0,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
