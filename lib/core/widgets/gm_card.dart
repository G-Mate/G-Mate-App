import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 흰 바탕 + 옅은 그림자 카드. [onTap]이 있으면 누를 수 있다.
class GmCard extends StatelessWidget {
  const GmCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.selected = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: AppDuration.normal,
      decoration: BoxDecoration(
        color: selected ? colors.primaryContainer : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: selected ? colors.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: AppShadow.soft,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// 홈 화면의 큰 메뉴 타일 ([길 찾기], [학교 투어]).
class GmMenuTile extends StatelessWidget {
  const GmMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.description,
    this.accent,
  });

  final IconData icon;
  final String title;
  final String? description;

  /// null이면 아직 쓸 수 없는 메뉴로 보고 흐리게 표시한다.
  final VoidCallback? onTap;

  /// 아이콘 배경색. 기본은 primary.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final enabled = onTap != null;
    final color = enabled
        ? (accent ?? colors.primary)
        : context.appColors.textDisabled;

    return Semantics(
      button: true,
      label: description == null ? title : '$title, $description',
      enabled: enabled,
      excludeSemantics: true,
      child: GmCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.xl),
        // 타일이 늘어나도 내용은 세로 가운데에 둔다.
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSize.iconXl + AppSpacing.lg,
                height: AppSize.iconXl + AppSpacing.lg,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: AppSize.iconXl * 0.7, color: color),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: text.headlineMedium),
              if (description != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description!,
                  style: text.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
