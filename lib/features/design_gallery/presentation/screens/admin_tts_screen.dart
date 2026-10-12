import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 시안: 관리 모드 - 음성 설정. 로봇이 안내 멘트를 읽는 목소리를 고른다.
///
/// 값은 temi의 TTS 목소리(성별·속도·높낮이)와 로봇 음량에 그대로 넘긴다.
class AdminTtsScreen extends StatefulWidget {
  const AdminTtsScreen({super.key});

  @override
  State<AdminTtsScreen> createState() => _AdminTtsScreenState();
}

class _AdminTtsScreenState extends State<AdminTtsScreen> {
  static const _genders = ['여성', '남성'];

  String _gender = _genders.first;
  double _speed = 1.0;
  double _pitch = 0;
  double _volume = 6;

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    final semantic = context.appColors;
    final text = context.textStyles;

    return GmScaffold(
      eyebrow: '관리 모드',
      title: '음성 설정',
      onBack: () => Navigator.of(context).maybePop(),
      actions: [
        TextButton.icon(
          onPressed: () => setState(() {
            _gender = _genders.first;
            _speed = 1.0;
            _pitch = 0;
            _volume = 6;
          }),
          icon: const Icon(Icons.restore_rounded, size: AppSize.iconSm),
          label: const Text('기본값으로'),
        ),
        GmButton(
          label: '저장',
          icon: Icons.check_rounded,
          size: GmButtonSize.small,
          onPressed: () {},
        ),
      ],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 목소리 값
          Expanded(
            flex: 5,
            child: _Panel(
              title: '목소리',
              child: ListView(
                children: [
                  _Row(
                    label: '목소리',
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        for (final g in _genders)
                          GmChoiceChip(
                            label: g,
                            selected: g == _gender,
                            onSelected: (_) => setState(() => _gender = g),
                          ),
                      ],
                    ),
                  ),
                  _SliderRow(
                    label: '말하기 속도',
                    value: _speed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    display: '${_speed.toStringAsFixed(1)}배',
                    onChanged: (v) => setState(() => _speed = v),
                  ),
                  _SliderRow(
                    label: '높낮이',
                    value: _pitch,
                    min: -10,
                    max: 10,
                    divisions: 20,
                    display: _pitch == 0
                        ? '기본'
                        : '${_pitch > 0 ? '+' : ''}${_pitch.round()}',
                    onChanged: (v) => setState(() => _pitch = v),
                  ),
                  _SliderRow(
                    label: '음량',
                    value: _volume,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    display: '${_volume.round()}',
                    onChanged: (v) => setState(() => _volume = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // 오른쪽: 바꾼 값으로 들어 보기
          Expanded(
            flex: 5,
            child: _Panel(
              title: '미리 듣기',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '저장하기 전에 아래 문장을 지금 설정으로 읽어 봐요.',
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    initialValue: '안녕하세요. 저는 학교 안내 로봇 지메이트예요. 가고 싶은 곳을 알려 주세요.',
                    minLines: 4,
                    maxLines: 4,
                    style: text.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GmButton(
                      label: '이 설정으로 듣기',
                      icon: Icons.volume_up_outlined,
                      size: GmButtonSize.small,
                      variant: GmButtonVariant.secondary,
                      onPressed: () {},
                    ),
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
class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

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
          Text(title, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// 라벨 + 입력.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textStyles.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

/// 라벨과 현재 값 + 슬라이더.
class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return _Row(
      label: label,
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
            width: 72,
            child: Text(
              display,
              textAlign: TextAlign.end,
              style: text.titleSmall?.copyWith(color: context.colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
