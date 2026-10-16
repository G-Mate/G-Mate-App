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

/// 사진 칸: 16:10 미리보기 + [사진 고르기/바꾸기] [사진 지우기].
class AdminPhotoField extends StatelessWidget {
  const AdminPhotoField({
    super.key,
    required this.image,
    required this.placeholder,
    required this.hint,
    required this.onPick,
    required this.onRemove,
  });

  /// 등록한 사진. 없으면 [placeholder]를 보여 준다.
  final ImageProvider? image;
  final Widget placeholder;
  final String hint;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  static const _photoWidth = 200.0;

  /// 사진 옆에 버튼을 둘 만큼 넓지 않으면 버튼을 사진 아래로 내린다.
  static const _sideBySideWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    final photo = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AspectRatio(
        aspectRatio: GmPlaceCard.photoAspectRatio,
        child: image != null
            ? Image(image: image, fit: BoxFit.cover)
            : placeholder,
      ),
    );
    final buttons = [
      GmButton(
        label: image == null ? '사진 고르기' : '사진 바꾸기',
        icon: Icons.photo_library_outlined,
        size: GmButtonSize.small,
        variant: GmButtonVariant.secondary,
        onPressed: onPick,
      ),
      if (image != null)
        GmButton(
          label: '사진 지우기',
          size: GmButtonSize.small,
          variant: GmButtonVariant.outline,
          onPressed: onRemove,
        ),
    ];
    return AdminField(
      label: '사진',
      hint: hint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < _sideBySideWidth) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                photo,
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: buttons,
                ),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: _photoWidth, child: photo),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, b) in buttons.indexed) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.xs),
                    b,
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
