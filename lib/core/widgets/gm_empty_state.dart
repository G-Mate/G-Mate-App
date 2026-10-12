import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 목록이 비었거나 결과가 없을 때 가운데에 보여 주는 안내.
class GmEmptyState extends StatelessWidget {
  const GmEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.search_off_rounded,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSize.iconXl,
              color: context.appColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: text.headlineSmall, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                style: text.bodyMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
