import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 모든 화면에서 같은 모양으로 쓰는 뒤로 가기 버튼 (유리 알약 + 화살표·글자).
class GmBackButton extends StatelessWidget {
  const GmBackButton({super.key, required this.onPressed, this.label = '뒤로'});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: AppColors.glass,
        side: const BorderSide(color: AppColors.glassBorder),
        shape: const StadiumBorder(),
        minimumSize: const Size(0, AppSize.buttonSmall),
        fixedSize: const Size.fromHeight(AppSize.buttonSmall),
        // 아이콘 쪽 여백을 조금 좁혀 글자와 균형을 맞춘다.
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.lg, 0),
        textStyle: Theme.of(context).textTheme.labelSmall,
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: AppSize.iconSm),
      label: Text(label),
    );
  }
}
