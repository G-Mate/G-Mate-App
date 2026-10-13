import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../domain/place.dart';
import 'bloc/place_detail_cubit.dart';
import 'place_icons.dart';
import 'place_not_found.dart';

/// 길 찾기 - 장소 확인. 고른 장소가 맞는지 보고 안내를 시작한다.
class PlaceConfirmPage extends StatelessWidget {
  const PlaceConfirmPage({super.key});

  static const _summaryMaxLines = 4;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceDetailCubit, PlaceDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final place = state.place;
        if (place == null) return const PlaceNotFound();
        return _Content(place: place);
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.place});

  final Place place;

  void _back(BuildContext context) =>
      context.canPop() ? context.pop() : context.go(AppRoutes.placeSelect);

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;

    return GmSplitLayout(
      hero: GmHeroPanel(
        top: GmHeroBackButton(onPressed: () => _back(context)),
        overline: place.meta,
        title: place.name,
        subtitle: '이곳으로 안내할까요?',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 장소 소개. 사진 등록이 생기면 아이콘 자리에 사진을 둔다.
          Expanded(
            child: GmCard(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    placeIcon(place),
                    size: AppSize.iconXl,
                    color: context.colors.primary,
                  ),
                  const Spacer(),
                  Text(
                    place.summary,
                    style: text.bodyLarge,
                    maxLines: PlaceConfirmPage._summaryMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GmButton(
                  label: '다른 곳 고르기',
                  variant: GmButtonVariant.outline,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: () => _back(context),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: GmButton(
                  label: '안내 시작',
                  icon: Icons.arrow_forward_rounded,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: () => context.go(AppRoutes.guiding(place.key)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
