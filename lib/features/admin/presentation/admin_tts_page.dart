import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../speech/domain/speech_settings.dart';
import 'bloc/admin_tts_cubit.dart';
import 'bloc/admin_tts_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 음성 설정. 로봇이 안내 멘트를 읽는 목소리를 고른다.
class AdminTtsPage extends StatefulWidget {
  const AdminTtsPage({super.key});

  @override
  State<AdminTtsPage> createState() => _AdminTtsPageState();
}

class _AdminTtsPageState extends State<AdminTtsPage> {
  static const _sample = '안녕하세요. 저는 학교 안내 로봇 지메이트예요. 가고 싶은 곳을 알려 주세요.';
  static const _sampleLines = 4;

  /// 슬라이더 칸 수: 속도는 0.1배, 높낮이·음량은 1씩.
  static const _speedDivisions = 15;

  final _sampleText = TextEditingController(text: _sample);

  @override
  void dispose() {
    _sampleText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    final semantic = context.appColors;
    final text = context.textStyles;
    final cubit = context.read<AdminTtsCubit>();

    return BlocConsumer<AdminTtsCubit, AdminTtsState>(
      listenWhen: (prev, next) => prev.saveCount != next.saveCount,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('음성 설정을 저장했어요'))),
      builder: (context, state) {
        final s = state.settings;
        return GmScaffold(
          eyebrow: '관리 모드',
          title: '음성 설정',
          onBack: () => context.pop(),
          actions: [
            TextButton.icon(
              onPressed: cubit.reset,
              icon: const Icon(Icons.restore_rounded, size: AppSize.iconSm),
              label: const Text('기본값으로'),
            ),
            GmButton(
              label: '저장',
              icon: Icons.check_rounded,
              size: GmButtonSize.small,
              onPressed: state.isLoading ? null : cubit.save,
            ),
          ],
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽: 목소리 값
              Expanded(
                flex: 5,
                child: AdminSection(
                  title: '목소리',
                  child: ListView(
                    children: [
                      AdminField(
                        label: '목소리',
                        child: Wrap(
                          spacing: AppSpacing.sm,
                          children: [
                            for (final g in VoiceGender.values)
                              GmChoiceChip(
                                label: g.label,
                                selected: g == s.gender,
                                onSelected: (_) =>
                                    cubit.change(s.copyWith(gender: g)),
                              ),
                          ],
                        ),
                      ),
                      _SliderField(
                        label: '말하기 속도',
                        value: s.speed,
                        min: SpeechSettings.minSpeed,
                        max: SpeechSettings.maxSpeed,
                        divisions: _speedDivisions,
                        display: '${s.speed.toStringAsFixed(1)}배',
                        onChanged: (v) => cubit.change(
                          s.copyWith(speed: double.parse(v.toStringAsFixed(1))),
                        ),
                      ),
                      _SliderField(
                        label: '높낮이',
                        value: s.pitch.toDouble(),
                        min: SpeechSettings.minPitch.toDouble(),
                        max: SpeechSettings.maxPitch.toDouble(),
                        divisions:
                            SpeechSettings.maxPitch - SpeechSettings.minPitch,
                        display: s.pitch == 0
                            ? '기본'
                            : '${s.pitch > 0 ? '+' : ''}${s.pitch}',
                        onChanged: (v) =>
                            cubit.change(s.copyWith(pitch: v.round())),
                      ),
                      _SliderField(
                        label: '음량',
                        value: s.volume.toDouble(),
                        min: SpeechSettings.minVolume.toDouble(),
                        max: SpeechSettings.maxVolume.toDouble(),
                        divisions:
                            SpeechSettings.maxVolume - SpeechSettings.minVolume,
                        display: '${s.volume}',
                        onChanged: (v) =>
                            cubit.change(s.copyWith(volume: v.round())),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 오른쪽: 바꾼 값으로 들어 보기
              Expanded(
                flex: 5,
                child: AdminSection(
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
                      TextField(
                        controller: _sampleText,
                        minLines: _sampleLines,
                        maxLines: _sampleLines,
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
                          onPressed: () => cubit.preview(_sampleText.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 라벨과 현재 값 + 슬라이더.
class _SliderField extends StatelessWidget {
  const _SliderField({
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

  static const _valueWidth = 72.0;

  @override
  Widget build(BuildContext context) {
    return AdminField(
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
