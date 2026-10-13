import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../domain/place.dart';
import 'bloc/place_select_cubit.dart';
import 'bloc/place_select_state.dart';
import 'place_icons.dart';

/// 길 찾기 - 장소 선택. 분류 칩과 검색으로 장소를 찾는다.
class PlaceSelectPage extends StatelessWidget {
  const PlaceSelectPage({super.key});

  static const _columns = 3;
  static const _cardAspectRatio = 1.5;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlaceSelectCubit>();

    return GmScaffold(
      eyebrow: '길 찾기',
      title: '어디로 갈까요?',
      onBack: () => context.go(AppRoutes.home),
      actions: [GmSearchField(hintText: '장소 이름으로 찾기', onChanged: cubit.search)],
      body: BlocBuilder<PlaceSelectCubit, PlaceSelectState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final places = state.visiblePlaces;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  GmChoiceChip(
                    label: '전체',
                    selected: state.category == null,
                    onSelected: (_) => cubit.selectCategory(null),
                  ),
                  for (final c in PlaceCategory.values)
                    GmChoiceChip(
                      label: c.label,
                      selected: state.category == c,
                      onSelected: (_) => cubit.selectCategory(c),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: places.isEmpty
                    ? const GmEmptyState(
                        icon: Icons.search_off_rounded,
                        title: '찾는 장소가 없어요',
                        message: '다른 이름으로 찾아보거나 분류를 바꿔 보세요',
                      )
                    : GridView.count(
                        crossAxisCount: _columns,
                        mainAxisSpacing: AppSpacing.lg,
                        crossAxisSpacing: AppSpacing.lg,
                        childAspectRatio: _cardAspectRatio,
                        children: [
                          for (final p in places)
                            GmPlaceCard(
                              name: p.name,
                              meta: p.meta,
                              icon: placeIcon(p),
                              fillHeight: true,
                              onTap: () =>
                                  context.push(AppRoutes.placeConfirm(p.key)),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
