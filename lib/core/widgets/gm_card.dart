import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 회색 배경 위의 흰 면 카드 (테두리·그림자 없음). [onTap]이 있으면 누를 수 있다.
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

/// 홈 화면의 큰 메뉴 카드 ([길 찾기], [학교 투어]).
///
/// 왼쪽 위에 아이콘을 크고 아주 옅게 깔고, 아래쪽에 큰 제목과 작은 설명을
/// 둔다. 장식은 이 배경 아이콘 하나뿐이다.
class GmMenuTile extends StatelessWidget {
  const GmMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.description,
  });

  final IconData icon;
  final String title;
  final String? description;

  /// null이면 아직 쓸 수 없는 메뉴로 보고 화살표를 흐리게 표시한다.
  final VoidCallback? onTap;

  static const _iconSize = 180.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;

    return Semantics(
      button: true,
      label: description == null ? title : '$title, $description',
      enabled: onTap != null,
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                top: AppSpacing.lg,
                left: AppSpacing.lg,
                child: Icon(
                  icon,
                  size: _iconSize,
                  color: colors.primary.withValues(alpha: 0.06),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(title, style: text.headlineLarge),
                          if (description != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              description!,
                              style: text.bodySmall?.copyWith(
                                color: semantic.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: AppSize.iconMd,
                      color: onTap == null
                          ? semantic.textDisabled
                          : colors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
