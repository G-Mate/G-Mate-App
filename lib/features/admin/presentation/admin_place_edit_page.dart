import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../place/domain/place.dart';
import '../../place/presentation/place_not_found.dart';
import 'bloc/admin_place_edit_cubit.dart';
import 'bloc/admin_place_edit_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 장소 편집. 장소 정보와 로봇이 읽을 멘트 3종을 고친다.
///
/// 설명 원본은 미리 들어 있고, 필요할 때만 고친다. 고친 뒤에도 [원래 설명으로]로
/// 되돌릴 수 있다.
class AdminPlaceEditPage extends StatelessWidget {
  const AdminPlaceEditPage({super.key});

  /// 고를 수 있는 층.
  static const floors = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    return BlocConsumer<AdminPlaceEditCubit, AdminPlaceEditState>(
      listenWhen: (prev, next) => !prev.isSaved && next.isSaved,
      listener: (context, state) => context.pop(true),
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final place = state.place;
        if (place == null) return const PlaceNotFound();
        final cubit = context.read<AdminPlaceEditCubit>();
        final semantic = context.appColors;
        final text = context.textStyles;

        return GmScaffold(
          eyebrow: '장소 관리',
          title: '${place.name} 편집',
          onBack: () => context.pop(),
          actions: [
            TextButton.icon(
              onPressed: cubit.restoreOriginalSpeech,
              icon: const Icon(Icons.restore_rounded, size: AppSize.iconSm),
              label: const Text('원래 설명으로'),
            ),
            GmButton(
              label: '취소',
              size: GmButtonSize.small,
              variant: GmButtonVariant.outline,
              onPressed: () => context.pop(),
            ),
            GmButton(
              label: '저장',
              icon: Icons.check_rounded,
              size: GmButtonSize.small,
              onPressed: place.name.trim().isEmpty ? null : cubit.save,
            ),
          ],
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽: 장소 기본 정보
              Expanded(
                flex: 4,
                child: AdminSection(
                  title: '기본 정보',
                  child: _BasicInfo(place: place, cubit: cubit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 오른쪽: 로봇이 읽을 멘트
              Expanded(
                flex: 6,
                child: AdminSection(
                  title: '안내 멘트',
                  trailing: Text(
                    '본 설명은 한 줄이 한 화면이에요',
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                  child: _Speech(state: state, cubit: cubit),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BasicInfo extends StatelessWidget {
  const _BasicInfo({required this.place, required this.cubit});

  final Place place;
  final AdminPlaceEditCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdminField(
          label: '표시 이름',
          child: TextFormField(
            initialValue: place.name,
            onChanged: cubit.changeName,
          ),
        ),
        AdminField(
          label: '로봇 장소 키',
          hint: 'temi에 저장된 이름이라 여기서는 바꿀 수 없어요',
          child: TextFormField(initialValue: place.key, enabled: false),
        ),
        AdminField(
          label: '분류',
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final c in PlaceCategory.values)
                GmChoiceChip(
                  label: c.label,
                  selected: c == place.category,
                  onSelected: (_) => cubit.changeCategory(c),
                ),
            ],
          ),
        ),
        AdminField(
          label: '층',
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final f in AdminPlaceEditPage.floors)
                GmChoiceChip(
                  label: '$f층',
                  selected: f == place.floor,
                  onSelected: (_) => cubit.changeFloor(f),
                ),
            ],
          ),
        ),
        AdminField(
          label: '검색 키워드',
          hint: '쉼표로 나눠 적어요. 검색에서 이 장소를 찾을 때 써요',
          child: TextFormField(
            initialValue: place.keywords.join(', '),
            onChanged: cubit.changeKeywords,
          ),
        ),
        AdminSliderField(
          label: '자동 넘김',
          hint: '한 줄을 읽고 다음 줄로 넘어가기까지 기다려요',
          value: place.lineInterval.inSeconds.toDouble(),
          min: Place.minLineInterval.inSeconds.toDouble(),
          max: Place.maxLineInterval.inSeconds.toDouble(),
          divisions:
              Place.maxLineInterval.inSeconds - Place.minLineInterval.inSeconds,
          display: '${place.lineInterval.inSeconds}초',
          onChanged: (v) =>
              cubit.changeLineInterval(Duration(seconds: v.round())),
        ),
      ],
    );
  }
}

class _Speech extends StatelessWidget {
  const _Speech({required this.state, required this.cubit});

  final AdminPlaceEditState state;
  final AdminPlaceEditCubit cubit;

  @override
  Widget build(BuildContext context) {
    final speech = state.place!.speech;
    final text = context.textStyles;
    final semantic = context.appColors;
    // [원래 설명으로]를 누르면 입력 칸을 새 값으로 다시 만든다.
    final revision = state.speechRevision;

    return ListView(
      children: [
        _SpeechField(
          key: ValueKey('start-$revision'),
          label: '출발 멘트',
          hint: '이동을 시작할 때 짧게',
          initialValue: speech.start,
          onChanged: cubit.changeStart,
          onPreview: () => cubit.preview(speech.start),
        ),
        _SpeechField(
          key: ValueKey('arrival-$revision'),
          label: '도착 멘트',
          hint: '도착하자마자',
          initialValue: speech.arrival,
          onChanged: cubit.changeArrival,
          onPreview: () => cubit.preview(speech.arrival),
        ),
        // 본 설명: 줄마다 번호를 붙여 몇 화면으로 나뉘는지 바로 보이게 한다.
        _SpeechHeader(
          label: '본 설명',
          hint:
              '도착 후 한 줄씩 넘기며 읽어요 · '
              '${speech.descriptionLines.length}화면',
          onPreview: speech.descriptionLines.isEmpty
              ? null
              : () => cubit.preview(speech.descriptionLines.join(' ')),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (var i = 0; i < speech.descriptionLines.length; i++)
          Padding(
            key: ValueKey('line-${state.lineIds[i]}'),
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                SizedBox(
                  width: AppSpacing.xl,
                  child: Text(
                    '${i + 1}',
                    style: text.labelSmall?.copyWith(
                      color: semantic.textDisabled,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: speech.descriptionLines[i],
                    style: text.bodyMedium,
                    onChanged: (v) => cubit.changeLine(i, v),
                  ),
                ),
                IconButton(
                  tooltip: '이 줄 지우기',
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(AppSize.buttonSmall),
                  ),
                  onPressed: () => cubit.removeLine(i),
                  icon: Icon(
                    Icons.close_rounded,
                    size: AppSize.iconSm,
                    color: semantic.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: cubit.addLine,
              icon: const Icon(Icons.add_rounded, size: AppSize.iconSm),
              label: const Text('줄 추가'),
            ),
          ),
        ),
      ],
    );
  }
}

/// 멘트 라벨 + 도움말 + [미리 듣기].
class _SpeechHeader extends StatelessWidget {
  const _SpeechHeader({
    required this.label,
    required this.hint,
    required this.onPreview,
  });

  final String label;
  final String hint;
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Row(
      children: [
        Text(label, style: text.labelSmall),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            hint,
            style: text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ),
        GmButton(
          label: '미리 듣기',
          icon: Icons.volume_up_outlined,
          size: GmButtonSize.small,
          variant: GmButtonVariant.secondary,
          onPressed: onPreview,
        ),
      ],
    );
  }
}

/// 멘트 입력: 머리줄 + 두 줄 입력.
class _SpeechField extends StatelessWidget {
  const _SpeechField({
    super.key,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
    required this.onPreview,
  });

  final String label;
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onPreview;

  static const _lines = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SpeechHeader(label: label, hint: hint, onPreview: onPreview),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            initialValue: initialValue,
            minLines: _lines,
            maxLines: _lines,
            style: context.textStyles.bodyMedium,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
