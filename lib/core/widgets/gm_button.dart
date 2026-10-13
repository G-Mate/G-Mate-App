import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

enum GmButtonVariant {
  /// 화면의 주 행동 ([안내 시작], [다음]).
  primary,

  /// 보조 행동 ([다시 듣기]). 연한 파랑 면.
  secondary,

  /// 테두리만 있는 버튼 ([처음으로]).
  outline,

  /// 멈춤·삭제 ([안내 중지]).
  danger,
}

enum GmButtonSize {
  /// 안내 모드 주 버튼 (72dp).
  large,

  /// 기본 (64dp).
  medium,

  /// 관리 모드 전용 (48dp). 방문객 화면에는 쓰지 않는다.
  small,
}

/// G-Mate 공통 버튼.
class GmButton extends StatelessWidget {
  const GmButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = GmButtonVariant.primary,
    this.size = GmButtonSize.medium,
    this.expanded = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final GmButtonVariant variant;
  final GmButtonSize size;

  /// true면 부모 너비를 가득 채운다.
  final bool expanded;

  /// true면 라벨 대신 진행 표시를 보여 주고 누를 수 없다.
  final bool loading;

  double get _height => switch (size) {
    GmButtonSize.large => AppSize.buttonLarge,
    GmButtonSize.medium => AppSize.buttonMedium,
    GmButtonSize.small => AppSize.buttonSmall,
  };

  double get _iconSize => switch (size) {
    GmButtonSize.large => AppSize.iconSm + 4,
    GmButtonSize.medium => AppSize.iconSm,
    GmButtonSize.small => AppSize.iconSm,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;

    final labelStyle = switch (size) {
      GmButtonSize.large => text.labelMedium,
      GmButtonSize.medium => text.labelMedium,
      GmButtonSize.small => text.labelSmall,
    };

    final (Color bg, Color fg, BorderSide side) = switch (variant) {
      GmButtonVariant.primary => (
        colors.primary,
        colors.onPrimary,
        BorderSide.none,
      ),
      GmButtonVariant.secondary => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        BorderSide.none,
      ),
      GmButtonVariant.outline => (
        AppColors.glass,
        colors.onSurface,
        const BorderSide(color: AppColors.glassBorder, width: 1.5),
      ),
      GmButtonVariant.danger => (
        semantic.danger,
        Colors.white,
        BorderSide.none,
      ),
    };

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(_height * 1.5, _height)),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(_height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: size == GmButtonSize.small
              ? AppSpacing.md
              : AppSpacing.lg,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      side: WidgetStatePropertyAll(side),
      textStyle: WidgetStatePropertyAll(labelStyle),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? colors.surfaceContainer
            : bg,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? semantic.textDisabled : fg,
      ),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: 0.12)),
    );

    final Widget child = loading
        ? SizedBox.square(
            dimension: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: semantic.textSecondary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _iconSize),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final button = FilledButton(
      onPressed: loading ? null : onPressed,
      style: style,
      child: child,
    );

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      enabled: onPressed != null && !loading,
      child: expanded
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}
