import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 회색 배경 위의 흰 면 카드 (테두리 없이 아주 옅은 그림자로 띄움).
/// [onTap]이 있으면 누를 수 있다.
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: selected ? colors.primary : colors.surface,
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

/// 홈 화면의 큰 메뉴 카드 ([길 찾기], [학교 투어]).
///
/// 왼쪽 위에 아이콘 배지, 아래쪽에 큰 제목과 작은 설명, 오른쪽 아래에 둥근
/// 화살표 버튼을 둔다. [emphasized]면 파랑 면으로 칠해 주 메뉴임을 보여 준다.
/// [emphasized] 카드의 오른쪽 위 모서리에 아주 옅게 걸친 큰 아이콘이 유일한 장식이다.
class GmMenuTile extends StatelessWidget {
  const GmMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.description,
    this.emphasized = false,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String? description;

  /// null이면 아직 쓸 수 없는 메뉴로 보고 화살표를 흐리게 표시한다.
  final VoidCallback? onTap;

  /// true면 파랑 면에 흰 글자로 그린다 (화면의 주 메뉴 하나에만 쓴다).
  final bool emphasized;

  /// 오른쪽 위 작은 알약 글자 (예: '준비 중').
  final String? badge;

  static const _decorIconSize = 240.0;
  static const _badgeSize = 72.0;
  static const _arrowSize = 64.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    final enabled = onTap != null;

    final Color titleColor = emphasized ? Colors.white : colors.onSurface;
    final Color descColor = emphasized
        ? Colors.white.withValues(alpha: 0.75)
        : semantic.textSecondary;
    final Color iconBg = emphasized
        ? Colors.white.withValues(alpha: 0.16)
        : colors.primaryContainer;
    final Color iconFg = emphasized ? Colors.white : colors.primary;
    final (Color arrowBg, Color arrowFg) = switch ((emphasized, enabled)) {
      (true, _) => (Colors.white, colors.primary),
      (false, true) => (colors.primary, colors.onPrimary),
      (false, false) => (colors.surfaceContainer, semantic.textDisabled),
    };

    return Semantics(
      button: true,
      label: description == null ? title : '$title, $description',
      enabled: enabled,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: emphasized ? null : colors.surface,
          gradient: emphasized
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                )
              : null,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: emphasized
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ]
              : AppShadow.soft,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                if (emphasized)
                  Positioned(
                    right: -AppSpacing.xxxl,
                    top: -AppSpacing.xxxl,
                    child: Icon(
                      icon,
                      size: _decorIconSize,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  // 배지 줄은 위에, 제목 줄은 아래에 붙인다. 칸이 작아도 넘치지 않는다.
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: _badgeSize,
                            height: _badgeSize,
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Icon(
                              icon,
                              size: AppSize.iconLg - AppSpacing.xs,
                              color: iconFg,
                            ),
                          ),
                          const Spacer(),
                          if (badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainer,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              child: Text(
                                badge!,
                                style: text.labelSmall?.copyWith(
                                  color: semantic.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: text.headlineLarge?.copyWith(
                                      color: titleColor,
                                    ),
                                  ),
                                  if (description != null) ...[
                                    const SizedBox(height: AppSpacing.xxs),
                                    Text(
                                      description!,
                                      style: text.bodySmall?.copyWith(
                                        color: descColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              width: _arrowSize,
                              height: _arrowSize,
                              decoration: BoxDecoration(
                                color: arrowBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: AppSize.iconMd,
                                color: arrowFg,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: image != null
            ? Image(image: image!, fit: BoxFit.cover)
            : GmPhotoPlaceholder(icon: icon),
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
                  Row(
                    children: [
                      Expanded(
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
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: AppSize.iconMd,
                        color: colors.primary,
                      ),
                    ],
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

/// 사진이 없을 때 쓰는 자리: 연한 파랑 그라데이션 위에 흰 원 배지와 아이콘.
class GmPhotoPlaceholder extends StatelessWidget {
  const GmPhotoPlaceholder({
    super.key,
    required this.icon,
    this.badgeSize = 112,
  });

  final IconData icon;
  final double badgeSize;

  static const _iconRatio = 0.45;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer, colors.surfaceContainer],
        ),
      ),
      child: Center(
        child: Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: colors.surface,
            shape: BoxShape.circle,
            boxShadow: AppShadow.soft,
          ),
          child: Icon(
            icon,
            size: badgeSize * _iconRatio,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}
