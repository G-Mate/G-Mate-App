import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 회색 배경 위의 흰 면 카드 (테두리 없음). [onTap]이 있으면 누를 수 있다.
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
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: selected ? colors.primary : colors.surface,
          width: 2,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// 홈 화면의 큰 메뉴 타일 ([길 찾기], [학교 투어]).
///
/// [emphasized]면 파랑 면에 흰 글자로 화면의 주 메뉴임을 드러낸다.
class GmMenuTile extends StatelessWidget {
  const GmMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.description,
    this.emphasized = false,
  });

  final IconData icon;
  final String title;
  final String? description;
  final bool emphasized;

  /// null이면 아직 쓸 수 없는 메뉴로 보고 '준비 중'으로 표시한다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    final enabled = onTap != null;

    final bg = emphasized ? colors.primary : colors.surface;
    final fg = emphasized ? colors.onPrimary : colors.onSurface;
    final sub = emphasized
        ? colors.onPrimary.withValues(alpha: 0.75)
        : semantic.textSecondary;
    final accent = emphasized ? colors.onPrimary : colors.primary;

    return Semantics(
      button: true,
      label: description == null ? title : '$title, $description',
      enabled: enabled,
      excludeSemantics: true,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: AppSize.iconLg, color: accent),
                const Spacer(),
                Text(title, style: text.headlineLarge?.copyWith(color: fg)),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description!,
                    style: text.bodyMedium?.copyWith(color: sub),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Container(height: 1, color: sub.withValues(alpha: 0.3)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Text(
                      enabled ? '시작하기' : '준비 중',
                      style: text.labelMedium?.copyWith(color: accent),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: AppSize.iconMd,
                      color: accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
