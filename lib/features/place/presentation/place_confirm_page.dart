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

  static const _photoBadgeSize = 200.0;

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
          // 장소 사진 자리. 사진 등록이 생기기 전까지 흐린 아이콘을 둔다.
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: GmPhotoPlaceholder(
                icon: placeIcon(place),
                badgeSize: PlaceConfirmPage._photoBadgeSize,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            place.summary,
            style: text.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xl),
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
