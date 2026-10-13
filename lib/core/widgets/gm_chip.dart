import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 카테고리 탭, 층 필터에 쓰는 선택 칩 (높이 64dp).
class GmChoiceChip extends StatelessWidget {
  const GmChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fg = selected ? colors.onPrimary : colors.onSurface;

    // 촘촘한 테마(관리 모드)에서는 48dp, 그 밖에는 64dp를 최소 높이로 둔다.
    final dense = Theme.of(context).visualDensity == VisualDensity.compact;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: dense ? AppSize.buttonSmall : AppSize.touchTargetMin,
      ),
      child: ChoiceChip(
        selected: selected,
        onSelected: onSelected,
        avatar: icon == null
            ? null
            : Icon(icon, color: fg, size: AppSize.iconSm),
        label: Text(label),
        labelStyle: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: fg),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
        backgroundColor: colors.surface,
        selectedColor: colors.primary,
        padding: dense
            ? const EdgeInsets.symmetric(horizontal: AppSpacing.xs)
            : const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
