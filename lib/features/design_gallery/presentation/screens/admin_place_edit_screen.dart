import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 관리 모드 - 장소 편집. 장소 정보와 로봇이 읽을 멘트 3종을 고친다.
///
/// 설명 원본은 미리 들어 있고, 필요할 때만 고친다. 고친 뒤에도 [원래 설명으로]로
/// 되돌릴 수 있다.
class AdminPlaceEditScreen extends StatefulWidget {
  const AdminPlaceEditScreen({super.key});

  @override
  State<AdminPlaceEditScreen> createState() => _AdminPlaceEditScreenState();
}

class _AdminPlaceEditScreenState extends State<AdminPlaceEditScreen> {
  static const _categories = ['교실', '행정실', '편의시설'];
  static const _floors = [1, 2, 3, 4];

  final _place = samplePlaces.first;
  late String _category = _place.category;
  late int _floor = _place.floor;

  @override
  Widget build(BuildContext context) {
    final semantic = context.appColors;
    final text = context.textStyles;

    return GmScaffold(
      eyebrow: '장소 관리',
      title: '${_place.name} 편집',
      onBack: () => Navigator.of(context).maybePop(),
      actions: [
        // 기본 설명은 미리 들어 있고, 고친 내용을 언제든 원래대로 돌릴 수 있다.
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.restore_rounded, size: AppSize.iconSm),
          label: const Text('원래 설명으로'),
        ),
        GmButton(
          label: '취소',
          variant: GmButtonVariant.outline,
          onPressed: () {},
        ),
        GmButton(label: '저장', icon: Icons.check_rounded, onPressed: () {}),
      ],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 장소 기본 정보
          Expanded(
            flex: 4,
            child: _Section(
              title: '기본 정보',
              child: ListView(
                children: [
                  _Field(
                    label: '표시 이름',
                    child: TextFormField(initialValue: _place.name),
                  ),
                  _Field(
                    label: '로봇 장소 키',
                    hint: 'temi에 저장된 이름이라 여기서는 바꿀 수 없어요',
                    child: TextFormField(
                      initialValue: _place.key,
                      enabled: false,
                    ),
                  ),
                  _Field(
                    label: '분류',
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        for (final c in _categories)
                          GmChoiceChip(
                            label: c,
                            selected: c == _category,
                            onSelected: (_) => setState(() => _category = c),
                          ),
                      ],
                    ),
                  ),
                  _Field(
                    label: '층',
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        for (final f in _floors)
                          GmChoiceChip(
                            label: '$f층',
                            selected: f == _floor,
                            onSelected: (_) => setState(() => _floor = f),
                          ),
                      ],
                    ),
                  ),
                  _Field(
                    label: '검색 키워드',
                    hint: '쉼표로 나눠 적어요. 음성·검색에서 이 장소를 찾을 때 써요',
                    child: TextFormField(initialValue: '과학실, 실험실, 과학'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // 오른쪽: 로봇이 읽을 멘트
          Expanded(
            flex: 6,
            child: _Section(
              title: '안내 멘트',
              trailing: Text(
                '본 설명은 문장 단위로 나눠 읽어요',
                style: text.bodySmall?.copyWith(color: semantic.textSecondary),
              ),
              child: ListView(
                children: [
                  _SpeechField(
                    label: '출발 멘트',
                    hint: '이동을 시작할 때 짧게',
                    initialValue: '과학실로 안내할게요. 저를 따라와 주세요.',
                  ),
                  _SpeechField(
                    label: '도착 멘트',
                    hint: '도착하자마자',
                    initialValue: '과학실에 도착했어요.',
                  ),
                  _SpeechField(
                    label: '본 설명',
                    hint: '도착 후 자막과 함께 읽어요',
                    initialValue: sampleDescription,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 흰 면 위에 제목이 달린 묶음.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child, this.hint});

  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
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
                fontSize: 16,
                color: context.appColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 멘트 입력: 라벨 + 여러 줄 입력 + [미리 듣기].
class _SpeechField extends StatelessWidget {
  const _SpeechField({
    required this.label,
    required this.hint,
    required this.initialValue,
    this.maxLines = 2,
  });

  final String label;
  final String hint;
  final String initialValue;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: text.labelSmall),
              const SizedBox(width: AppSpacing.sm),
              Text(
                hint,
                style: text.bodySmall?.copyWith(
                  fontSize: 16,
                  color: context.appColors.textSecondary,
                ),
              ),
              const Spacer(),
              GmButton(
                label: '미리 듣기',
                icon: Icons.volume_up_outlined,
                size: GmButtonSize.small,
                variant: GmButtonVariant.secondary,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            initialValue: initialValue,
            minLines: maxLines,
            maxLines: maxLines,
            style: text.bodyMedium,
          ),
        ],
      ),
    );
  }
}
