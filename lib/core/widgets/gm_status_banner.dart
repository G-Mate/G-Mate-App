import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

enum GmStatusType { info, success, warning, danger }

/// 로봇 상태나 안내 메시지를 보여 주는 띠
/// (예: "과학실로 안내 중입니다", "위치를 확인하고 있어요", "길을 비켜 주세요").
class GmStatusBanner extends StatelessWidget {
  const GmStatusBanner({
    super.key,
    required this.message,
    this.type = GmStatusType.info,
    this.icon,
    this.action,
  });

  final String message;
  final GmStatusType type;
  final IconData? icon;

  /// 오른쪽 끝에 놓을 버튼 (예: GmButton).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = context.appColors;
    final (Color fg, IconData defaultIcon) = switch (type) {
      GmStatusType.info => (s.info, Icons.info_outline_rounded),
      GmStatusType.success => (s.success, Icons.check_circle_outline_rounded),
      GmStatusType.warning => (s.warning, Icons.warning_amber_rounded),
      GmStatusType.danger => (s.danger, Icons.error_outline_rounded),
    };

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadow.soft,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: fg.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon ?? defaultIcon, color: fg, size: AppSize.iconMd),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: context.textStyles.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: AppSpacing.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// 점 하나와 짧은 글자로 된 알약 모양 상태 표시 (예: 로봇 준비 완료).
///
/// 바탕은 상태 색을 옅게 깐다. [onDark]가 true면 남색 패널 위에 놓도록
/// 반투명 흰 바탕과 흰 글자를 쓴다.
class GmStatusIndicator extends StatelessWidget {
  const GmStatusIndicator({
    super.key,
    required this.label,
    this.type = GmStatusType.info,
    this.onDark = false,
  });

  final String label;
  final GmStatusType type;
  final bool onDark;

  static const _dotSize = 10.0;
  static const _glowAlpha = 0.35;

  @override
  Widget build(BuildContext context) {
    final s = context.appColors;
    final (Color dot, Color container) = switch (type) {
      GmStatusType.info => (s.info, s.infoContainer),
      GmStatusType.success => (s.success, s.successContainer),
      GmStatusType.warning => (s.warning, s.warningContainer),
      GmStatusType.danger => (s.danger, s.dangerContainer),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: onDark ? AppColors.onNavySurface : container,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: dot,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dot.withValues(alpha: _glowAlpha),
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: context.textStyles.labelSmall?.copyWith(
                color: onDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
