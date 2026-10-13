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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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

/// 라벨 + 슬라이더 + 오른쪽 값 글자 (+ 선택 도움말).
class AdminSliderField extends StatelessWidget {
  const AdminSliderField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;

  /// 오른쪽에 보여 줄 값 (예: '1.0배', '5초').
  final String display;
  final ValueChanged<double> onChanged;
  final String? hint;

  static const _valueWidth = 72.0;

  @override
  Widget build(BuildContext context) {
    return AdminField(
      label: label,
      hint: hint,
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: _valueWidth,
            child: Text(
              display,
              textAlign: TextAlign.end,
              style: context.textStyles.titleSmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
