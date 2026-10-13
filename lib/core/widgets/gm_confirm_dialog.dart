import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';
import 'gm_button.dart';

/// 되돌리기 어려운 행동([안내 중지], [투어 중지]) 전에 한 번 더 묻는 창.
///
/// 방문객이 모르고 눌렀을 때를 위한 것이라 [계속하기]를 왼쪽 큰 버튼으로,
/// 멈추는 버튼은 오른쪽 빨강으로 둔다. 확인하면 true, 닫거나 계속하면 false.
Future<bool> showGmConfirmDialog(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? message,
  String cancelLabel = '계속하기',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => _GmConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
  return result ?? false;
}

class _GmConfirmDialog extends StatelessWidget {
  const _GmConfirmDialog({
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
    this.message,
  });

  final String title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;

  static const _width = 520.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final message = this.message;
    return Dialog(
      child: SizedBox(
        width: _width,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: text.headlineSmall),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: text.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: GmButton(
                      label: cancelLabel,
                      variant: GmButtonVariant.outline,
                      expanded: true,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: GmButton(
                      label: confirmLabel,
                      variant: GmButtonVariant.danger,
                      expanded: true,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
