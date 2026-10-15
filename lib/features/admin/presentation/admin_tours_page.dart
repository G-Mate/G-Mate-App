import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../place/domain/place.dart';
import '../../tour/domain/tour.dart';
import 'bloc/admin_tours_cubit.dart';
import 'bloc/admin_tours_state.dart';

/// 관리 모드 - 투어 관리. 코스 목록을 보고, 코스를 추가·편집·삭제한다.
class AdminToursPage extends StatelessWidget {
  const AdminToursPage({super.key});

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    final cubit = context.read<AdminToursCubit>();

    return GmScaffold(
      eyebrow: '관리 모드',
      title: '투어 관리',
      onBack: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.adminHome),
      actions: [
        GmButton(
          label: '코스 추가',
          icon: Icons.add_rounded,
          size: GmButtonSize.small,
          onPressed: () => _edit(context, cubit, AppRoutes.adminTourNew),
        ),
      ],
      body: BlocBuilder<AdminToursCubit, AdminToursState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.tours.isEmpty) {
            return const GmEmptyState(
              icon: Icons.flag_outlined,
              title: '코스가 없어요',
              message: '[코스 추가]를 눌러 들를 곳을 골라 주세요',
            );
          }
          // 장소 관리 목록과 같은 모양: 줄 수만큼만 높이를 갖고, 많으면 스크롤.
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: state.tours.length,
                separatorBuilder: (_, _) => const Divider(
                  indent: AppSpacing.lg,
                  endIndent: AppSpacing.lg,
                ),
                itemBuilder: (context, i) {
                  final tour = state.tours[i];
                  return _TourRow(
                    tour: tour,
                    places: state.places,
                    onTap: () => _edit(
                      context,
                      cubit,
                      AppRoutes.adminTourEdit(tour.key),
                    ),
                    onDelete: () => _delete(context, cubit, tour),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    AdminToursCubit cubit,
    String route,
  ) async {
    await context.push(route);
    await cubit.load();
  }

  Future<void> _delete(
    BuildContext context,
    AdminToursCubit cubit,
    Tour tour,
  ) async {
    final ok = await showGmConfirmDialog(
      context,
      title: '코스를 지울까요?',
      message: '‘${tour.name}’ 코스가 투어 목록에서 사라져요. 장소는 그대로 남아요.',
      confirmLabel: '지우기',
      cancelLabel: '취소',
    );
    if (!ok) return;
    await cubit.delete(tour.key);
  }
}

/// 목록 한 줄: 이름, 걸리는 시간·들를 곳 수, 들를 곳 순서, [삭제].
class _TourRow extends StatelessWidget {
  const _TourRow({
    required this.tour,
    required this.places,
    required this.onTap,
    required this.onDelete,
  });

  final Tour tour;
  final Map<String, Place> places;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final semantic = context.appColors;
    final route = [
      for (final s in tour.stops) places[s.placeKey]?.name ?? '(없는 장소)',
    ].join(' → ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              Icons.flag_outlined,
              size: AppSize.iconMd,
              color: colors.onSurface,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour.name, style: text.titleMedium),
                  Text(
                    '${tour.durationLabel} · 들를 곳 ${tour.stops.length}곳'
                    '${route.isEmpty ? '' : ' · $route'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            GmButton(
              label: '삭제',
              size: GmButtonSize.small,
              variant: GmButtonVariant.outline,
              onPressed: onDelete,
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
