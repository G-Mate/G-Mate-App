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

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.touchTargetMin),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
