import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../../core/utils/korean.dart';
import '../../place/domain/place.dart';
import '../../place/presentation/place_icons.dart';
import 'bloc/admin_places_cubit.dart';
import 'bloc/admin_places_state.dart';
import 'widgets/new_place_dialog.dart';

/// 관리 모드 - 장소 관리. 장소 목록과 로봇 저장 상태를 보고, 새 장소를 저장한다.
class AdminPlacesPage extends StatelessWidget {
  const AdminPlacesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    final cubit = context.read<AdminPlacesCubit>();

    return GmScaffold(
      eyebrow: '관리 모드',
      title: '장소 관리',
      onBack: () => context.go(AppRoutes.home),
      actions: [
        TextButton.icon(
          onPressed: () => context.push(AppRoutes.adminTts),
          icon: const Icon(Icons.record_voice_over_outlined),
          label: const Text('음성 설정'),
        ),
        GmButton(
          label: '현재 위치 저장',
          icon: Icons.add_location_alt_outlined,
          size: GmButtonSize.small,
          onPressed: () => _saveCurrentLocation(context, cubit),
        ),
      ],
      body: BlocBuilder<AdminPlacesCubit, AdminPlacesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.places.isEmpty) {
            return const GmEmptyState(
              icon: Icons.add_location_alt_outlined,
              title: '저장된 장소가 없어요',
              message: '로봇을 장소로 데려간 뒤 [현재 위치 저장]을 눌러 주세요',
            );
          }
          return Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              itemCount: state.places.length,
              separatorBuilder: (_, _) => const Divider(
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
              ),
              itemBuilder: (context, i) {
                final place = state.places[i];
                return _PlaceRow(
                  place: place,
                  isOnRobot: state.isOnRobot(place),
                  onTap: () => _edit(context, cubit, place.key),
                  onPreview: () => cubit.preview(place),
                  onTestMove: () => _testMove(context, cubit, place),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    AdminPlacesCubit cubit,
    String key,
  ) async {
    await context.push(AppRoutes.adminPlaceEdit(key));
    await cubit.load();
  }

  Future<void> _testMove(
    BuildContext context,
    AdminPlacesCubit cubit,
    Place place,
  ) async {
    await cubit.testMove(place);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${Korean.withRo(place.name)} 이동을 시작했어요')),
      );
  }

  Future<void> _saveCurrentLocation(
    BuildContext context,
    AdminPlacesCubit cubit,
  ) async {
    final result = await showDialog<NewPlace>(
      context: context,
      builder: (_) => NewPlaceDialog(validateKey: cubit.validateNewKey),
    );
    if (result == null) return;
    await cubit.saveCurrentLocation(key: result.key, name: result.name);
    if (!context.mounted) return;
    // 새 장소는 멘트가 비어 있으니 바로 편집 화면으로 간다.
    await _edit(context, cubit, result.key);
  }
}

/// 목록 한 줄: 아이콘, 이름·키, 로봇 저장 상태, [미리 듣기] [이동 테스트].
class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    required this.isOnRobot,
    required this.onTap,
    required this.onPreview,
    required this.onTestMove,
  });

  final Place place;
  final bool isOnRobot;
  final VoidCallback onTap;
  final VoidCallback onPreview;
  final VoidCallback onTestMove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final semantic = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            GmIcon(
              placeIcon(place),
              size: AppSize.iconMd,
              color: colors.onSurface,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: text.titleMedium),
                  Text(
                    '${place.meta} · ${place.key}',
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GmStatusIndicator(
              label: isOnRobot ? '로봇에 저장됨' : '로봇에 없음',
              type: isOnRobot ? GmStatusType.success : GmStatusType.warning,
            ),
            const SizedBox(width: AppSpacing.xl),
            GmButton(
              label: '미리 듣기',
              size: GmButtonSize.small,
              variant: GmButtonVariant.secondary,
              onPressed: onPreview,
            ),
            const SizedBox(width: AppSpacing.sm),
            // 로봇에 저장된 장소만 이동해 볼 수 있다.
            GmButton(
              label: '이동 테스트',
              size: GmButtonSize.small,
              variant: GmButtonVariant.outline,
              onPressed: isOnRobot ? onTestMove : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSize.iconMd,
              color: semantic.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
