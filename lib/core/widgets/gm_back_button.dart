import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 모든 화면에서 같은 모양으로 쓰는 뒤로 가기 버튼 (둥근 유리 아이콘 버튼).
class GmBackButton extends StatelessWidget {
  const GmBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: '뒤로',
      iconSize: AppSize.iconSm,
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: AppColors.glass,
        side: const BorderSide(color: AppColors.glassBorder),
        fixedSize: const Size.square(AppSize.touchTargetMin),
        minimumSize: const Size.square(AppSize.touchTargetMin),
      ),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
