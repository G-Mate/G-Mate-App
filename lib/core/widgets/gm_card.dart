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

/// 장소 카드: 사진 영역 + 이름 + 층·분류.
///
/// 사진이 없으면 [icon]을 옅게 그린 회색 면을 대신 보여 준다.
class GmPlaceCard extends StatelessWidget {
  const GmPlaceCard({
    super.key,
    required this.name,
    required this.meta,
    required this.icon,
    this.image,
    this.onTap,
    this.selected = false,
    this.fillHeight = false,
  });

  final String name;

  /// 이름 아래 작은 글자 (예: '3층 · 교실').
  final String meta;
  final IconData icon;
  final ImageProvider? image;
  final VoidCallback? onTap;
  final bool selected;

  /// true면 부모가 정한 높이를 채운다 (그리드 칸 안에서 쓸 때).
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final Widget photo = SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: image != null
            ? Image(image: image!, fit: BoxFit.cover)
            : ColoredBox(
                color: colors.surfaceContainer,
                child: Icon(
                  icon,
                  size: AppSize.iconXl,
                  color: colors.primary.withValues(alpha: 0.18),
                ),
              ),
      ),
    );
    return Semantics(
      button: true,
      label: '$name, $meta',
      excludeSemantics: true,
      child: GmCard(
        onTap: onTap,
        selected: selected,
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 그리드 칸처럼 높이가 정해져 있으면 사진이 남은 높이를 채우고,
            // 아니면 16:10 비율로 그린다.
            if (fillHeight)
              Expanded(child: photo)
            else
              AspectRatio(aspectRatio: 16 / 10, child: photo),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: text.titleLarge),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    meta,
                    style: text.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
