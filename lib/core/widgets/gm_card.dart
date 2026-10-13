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
  static const _iconSize = 64.0;
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

/// 장소 카드: (사진) + 선 아이콘 + 이름 + 층·분류.
///
/// 사진이 있으면 위에 사진을 두고, 없으면 왼쪽 위 선 아이콘과 아래쪽 이름만
/// 남긴 글자 중심 카드로 그린다.
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

  /// 사진이 없을 때 [fillHeight]가 아니면 쓰는 카드 높이.
  static const _textOnlyHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;

    final Widget label = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: text.headlineSmall),
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
        GmIcon(
          GmIcons.arrowForward,
          size: AppSize.iconMd,
          color: colors.primary,
        ),
      ],
    );

    final Widget content;
    if (image != null) {
      final photo = ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(
          width: double.infinity,
          child: Image(image: image!, fit: BoxFit.cover),
        ),
      );
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 그리드 칸처럼 높이가 정해져 있으면 사진이 남은 높이를 채우고,
          // 아니면 16:10 비율로 그린다.
          if (fillHeight)
            Expanded(child: photo)
          else
            AspectRatio(aspectRatio: 16 / 10, child: photo),
          const SizedBox(height: AppSpacing.md),
          label,
        ],
      );
    } else {
      final Widget body = Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GmIcon(icon, size: AppSize.iconXl, color: colors.onSurface),
          ),
          Align(alignment: Alignment.bottomLeft, child: label),
        ],
      );
      content = fillHeight
          ? body
          : SizedBox(height: _textOnlyHeight, child: body);
    }

    return Semantics(
      button: true,
      label: '$name, $meta',
      excludeSemantics: true,
      child: GmCard(onTap: onTap, selected: selected, child: content),
    );
  }
}
