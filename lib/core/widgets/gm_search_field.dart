import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

/// 화면 머리말 오른쪽에 두는 알약 모양 검색 칸 (높이 64dp, 한 줄).
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

  static const defaultWidth = 560.0;
  static const height = AppSize.buttonLarge;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.full),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    );
    final style = text.bodyMedium?.copyWith(color: context.colors.onSurface);
    // 한 줄 글자 높이를 빼고 남는 만큼 위아래 여백을 줘서 높이를 맞춘다.
    final lineHeight = (style?.fontSize ?? 0) * (style?.height ?? 1);
    final verticalPadding = (height - lineHeight) / 2;
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        onChanged: onChanged,
        // 검색어는 한 줄만 받는다 (줄바꿈 없음, 엔터는 검색 완료).
        maxLines: 1,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: style,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: text.bodyMedium?.copyWith(color: semantic.textDisabled),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: verticalPadding,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.sm,
            ),
            child: Icon(
              Icons.search_rounded,
              size: AppSize.iconSm + AppSpacing.xxs,
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
