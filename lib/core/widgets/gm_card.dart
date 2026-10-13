import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';
import 'gm_icon.dart';

/// 바탕의 빛이 비치는 반투명 유리 카드. 1px 밝은 선으로 가장자리를 잡는다.
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
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: selected ? colors.primary : AppColors.glassBorder,
          width: selected ? 2 : 1,
        ),
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
/// 왼쪽 위에 선 아이콘, 오른쪽 위에 번호(또는 [badge]), 아래쪽에 큰 제목과
/// 작은 설명, 오른쪽 아래에 화살표. 장식 없이 글자 크기 대비로만 위계를 만든다.
/// [emphasized]면 파랑 단색 면으로 칠해 주 메뉴임을 보여 준다.
class GmMenuTile extends StatelessWidget {
  const GmMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.description,
    this.index,
    this.emphasized = false,
    this.badge,
  });

  final GmIcons icon;
  final String title;
  final String? description;

  /// 오른쪽 위 작은 번호 (예: '01').
  final String? index;

  /// null이면 아직 쓸 수 없는 메뉴로 보고 화살표를 흐리게 표시한다.
  final VoidCallback? onTap;

  /// true면 파랑 단색 면에 흰 글자로 그린다 (화면의 주 메뉴 하나에만 쓴다).
  final bool emphasized;

  /// 번호 대신 오른쪽 위에 둘 짧은 글자 (예: '준비 중').
  final String? badge;

  /// 흰 면 위 보조 글자의 진하기.
  static const _onPrimaryMutedAlpha = 0.72;
  static const _iconSize = 44.0;
  static const _glowAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    final enabled = onTap != null;

    final Color fg = emphasized ? colors.onPrimary : colors.onSurface;
    final Color muted = emphasized
        ? colors.onPrimary.withValues(alpha: _onPrimaryMutedAlpha)
        : semantic.textSecondary;
    final Color accent = colors.onSurface;
    final corner = badge ?? index;

    return Semantics(
      button: true,
      label: description == null ? title : '$title, $description',
      enabled: enabled,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: emphasized
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                )
              : null,
          // 주 메뉴는 파랑 빛이 아래로 번지며 떠 있는 느낌을 준다.
          boxShadow: emphasized
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: _glowAlpha),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: emphasized ? Colors.transparent : AppColors.glass,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: emphasized
                ? BorderSide.none
                : const BorderSide(color: AppColors.glassBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              // 위 줄은 위에, 제목 줄은 아래에 붙인다. 칸이 작아도 넘치지 않는다.
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GmIcon(
                        icon,
                        size: _iconSize,
                        color: enabled ? accent : semantic.textDisabled,
                        fillOpacity: emphasized
                            ? 0.22
                            : GmIcon.defaultFillOpacity,
                      ),
                      const Spacer(),
                      if (corner != null)
                        Text(
                          corner,
                          style: text.labelSmall?.copyWith(
                            color: muted,
                            letterSpacing: 1,
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
                                style: text.headlineLarge?.copyWith(color: fg),
                              ),
                              if (description != null) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  description!,
                                  style: text.bodySmall?.copyWith(color: muted),
                                ),
                              ],
                            ],
                          ),
                        ),
                        GmIcon(
                          GmIcons.arrowForward,
                          size: AppSize.iconLg,
                          color: enabled ? accent : semantic.textDisabled,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 장소 카드: 위쪽 사진 자리 + 이름 + 층·분류.
///
/// 사진이 들어갈 카드라 유리 면 대신 불투명한 남색 면을 쓴다. 사진이 없으면
/// 사진 자리에 작은 [icon]을 가운데 둔다.
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
  final GmIcons icon;
  final ImageProvider? image;
  final VoidCallback? onTap;
  final bool selected;

  /// true면 부모가 정한 높이를 채운다 (그리드 칸 안에서 쓸 때).
  final bool fillHeight;

  static const _photoIconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;

    final Widget photo = SizedBox(
      width: double.infinity,
      child: image != null
          ? Image(image: image!, fit: BoxFit.cover)
          : ColoredBox(
              color: colors.surfaceContainerHighest,
              child: Center(
                child: GmIcon(
                  icon,
                  size: _photoIconSize,
                  color: context.appColors.textSecondary,
                ),
              ),
            ),
    );

    final Widget label = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: text.titleLarge),
                Text(
                  meta,
                  style: text.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GmIcon(
            GmIcons.arrowForward,
            size: AppSize.iconSm,
            color: colors.onSurface,
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      label: '$name, $meta',
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: selected
              ? BorderSide(color: colors.primary, width: 2)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 그리드 칸처럼 높이가 정해져 있으면 사진이 남은 높이를 채우고,
              // 아니면 16:10 비율로 그린다.
              if (fillHeight)
                Expanded(child: photo)
              else
                AspectRatio(aspectRatio: 16 / 10, child: photo),
              label,
            ],
          ),
        ),
      ),
    );
  }
}
