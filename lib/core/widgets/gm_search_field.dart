import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 화면 머리말 오른쪽에 두는 알약 모양 검색 칸 (높이 56dp).
class GmSearchField extends StatelessWidget {
  const GmSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.width = defaultWidth,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final double width;

  static const defaultWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.full),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    );
    return SizedBox(
      width: width,
      height: AppSize.touchTargetMin,
      child: TextField(
        onChanged: onChanged,
        // 높이 56dp를 꽉 채우고 글자를 세로 가운데에 둔다.
        expands: true,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        style: text.bodySmall?.copyWith(color: context.colors.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: text.bodySmall?.copyWith(color: semantic.textDisabled),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.sm,
            ),
            child: Icon(
              Icons.search_rounded,
              size: AppSize.iconSm,
              color: semantic.textSecondary,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: context.colors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
