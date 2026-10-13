import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 관리 모드 화면에서 흰 면 위에 제목이 달린 묶음.
class AdminSection extends StatelessWidget {
  const AdminSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: context.textStyles.titleMedium),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// 라벨 + 입력 + (선택) 도움말.
class AdminField extends StatelessWidget {
  const AdminField({
    super.key,
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          child,
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              hint!,
              style: text.bodySmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
