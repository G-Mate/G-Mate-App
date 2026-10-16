import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../place/domain/place.dart';
import '../../place/presentation/place_icons.dart';
import '../../tour/domain/tour.dart';
import '../../tour/presentation/tour_widgets.dart';
import 'bloc/admin_tour_edit_cubit.dart';
import 'bloc/admin_tour_edit_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 코스 편집. 이름·소개·걸리는 시간을 고치고, 들를 곳을 골라
/// 순서를 정한다.
class AdminTourEditPage extends StatelessWidget {
  const AdminTourEditPage({super.key});

  static const _descriptionLines = 2;

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    return BlocConsumer<AdminTourEditCubit, AdminTourEditState>(
      listenWhen: (prev, next) => !prev.isSaved && next.isSaved,
      listener: (context, state) => context.pop(true),
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final tour = state.tour;
        if (tour == null) {
          return GmScaffold(
            eyebrow: '투어 관리',
            title: '코스 편집',
            onBack: () => context.pop(),
            body: const GmEmptyState(
              icon: Icons.flag_outlined,
              title: '코스를 찾을 수 없어요',
            ),
          );
        }
        final cubit = context.read<AdminTourEditCubit>();
        final step = Tour.durationStep.inMinutes;

        return GmScaffold(
          eyebrow: '투어 관리',
          title: state.isNew
              ? '새 코스'
              : '${tour.name.trim().isEmpty ? '코스' : tour.name} 편집',
          onBack: () => context.pop(),
          actions: [
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
              onPressed: state.canSave ? cubit.save : null,
            ),
          ],
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽: 코스 기본 정보
              Expanded(
                flex: 3,
                child: AdminSection(
                  title: '기본 정보',
                  child: ListView(
                    children: [
                      // 코스 사진: 투어 코스 선택 카드에 쓰인다.
                      AdminPhotoField(
                        image: switch (tour.imagePath) {
                          final path? => FileImage(File(path)),
                          null => null,
                        },
                        placeholder: GmPlaceArt(icon: tourIcon(tour)),
                        hint: '없으면 코스 아이콘 그림으로 보여요',
                        onPick: cubit.pickImage,
                        onRemove: cubit.removeImage,
                      ),
                      AdminField(
                        label: '코스 이름',
                        child: TextFormField(
                          initialValue: tour.name,
                          autofocus: state.isNew,
                          decoration: const InputDecoration(
                            hintText: '예: 첫 방문 코스',
                          ),
                          onChanged: cubit.changeName,
                        ),
                      ),
                      AdminField(
                        label: '소개',
                        hint: '코스 카드에 한 줄로 보여요',
                        child: TextFormField(
                          initialValue: tour.description,
                          minLines: _descriptionLines,
                          maxLines: _descriptionLines,
                          onChanged: cubit.changeDescription,
                        ),
                      ),
                      AdminSliderField(
                        label: '걸리는 시간',
                        hint: '코스를 다 도는 어림 시간이에요',
                        value: tour.duration.inMinutes.toDouble(),
                        min: Tour.minDuration.inMinutes.toDouble(),
                        max: Tour.maxDuration.inMinutes.toDouble(),
                        divisions:
                            (Tour.maxDuration.inMinutes -
                                Tour.minDuration.inMinutes) ~/
                            step,
                        display: '${tour.duration.inMinutes}분',
                        onChanged: (v) => cubit.changeDuration(
                          Duration(minutes: (v / step).round() * step),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 가운데: 들르는 순서
              Expanded(
                flex: 4,
                child: AdminSection(
                  title: '들를 곳 ${tour.stops.length}곳',
                  trailing: _Hint('끌어서 순서를 바꿔요'),
                  child: _Stops(state: state, cubit: cubit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 오른쪽: 넣을 수 있는 장소
              Expanded(
                flex: 3,
                child: AdminSection(
                  title: '장소 추가',
                  trailing: _Hint('누르면 끝에 들어가요'),
                  child: _PlacePicker(state: state, cubit: cubit),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    ),
  );
}

/// 들를 곳 목록. 손잡이를 끌어 순서를 바꾸고, ×로 뺀다.
class _Stops extends StatelessWidget {
  const _Stops({required this.state, required this.cubit});

  final AdminTourEditState state;
  final AdminTourEditCubit cubit;

  @override
  Widget build(BuildContext context) {
    final stops = state.tour!.stops;
    if (stops.isEmpty) {
      return Center(child: _Hint('오른쪽에서 들를 장소를 골라 주세요'));
    }
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: stops.length,
      onReorderItem: cubit.moveStop,
      itemBuilder: (context, i) {
        final key = stops[i].placeKey;
        return _StopRow(
          key: ValueKey(key),
          index: i,
          place: state.placeOf(key),
          placeKey: key,
          onRemove: () => cubit.removeStop(i),
        );
      },
    );
  }
}

/// 들를 곳 한 줄: 순번, 아이콘, 이름·층, [빼기], 끄는 손잡이.
class _StopRow extends StatelessWidget {
  const _StopRow({
    super.key,
    required this.index,
    required this.place,
    required this.placeKey,
    required this.onRemove,
  });

  final int index;
  final Place? place;
  final String placeKey;
  final VoidCallback onRemove;

  static const _numberSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final semantic = context.appColors;
    final place = this.place;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Container(
                width: _numberSize,
                height: _numberSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: text.labelSmall?.copyWith(color: colors.onPrimary),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (place != null) ...[
                GmIcon(
                  placeIcon(place),
                  size: AppSize.iconSm,
                  color: colors.onSurface,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place?.name ?? placeKey,
                      style: text.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      place == null ? '장소 관리에 없는 곳이라 건너뛰어요' : place.meta,
                      style: text.bodySmall?.copyWith(
                        color: place == null
                            ? semantic.warning
                            : semantic.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '코스에서 빼기',
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(AppSize.buttonSmall),
                ),
                onPressed: onRemove,
                icon: Icon(
                  Icons.close_rounded,
                  size: AppSize.iconSm,
                  color: semantic.textDisabled,
                ),
              ),
              ReorderableDragStartListener(
                index: index,
                child: SizedBox.square(
                  dimension: AppSize.buttonSmall,
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    size: AppSize.iconSm,
                    color: semantic.textSecondary,
                    semanticLabel: '순서 바꾸기',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 아직 코스에 없는 장소 목록. 누르면 들를 곳 끝에 넣는다.
class _PlacePicker extends StatelessWidget {
  const _PlacePicker({required this.state, required this.cubit});

  final AdminTourEditState state;
  final AdminTourEditCubit cubit;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    final used = {for (final s in state.tour!.stops) s.placeKey};
    final left = [
      for (final p in state.places)
        if (!used.contains(p.key)) p,
    ];
    if (left.isEmpty) {
      return Center(child: _Hint('모든 장소가 코스에 들어 있어요'));
    }
    return ListView.separated(
      itemCount: left.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final place = left[i];
        return InkWell(
          onTap: () => cubit.addStop(place.key),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                GmIcon(
                  placeIcon(place),
                  size: AppSize.iconSm,
                  color: context.colors.onSurface,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name, style: text.titleSmall),
                      Text(
                        place.meta,
                        style: text.bodySmall?.copyWith(
                          color: semantic.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_rounded,
                  size: AppSize.iconSm,
                  color: context.colors.primary,
                  semanticLabel: '추가',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
