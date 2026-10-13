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
///
/// 왼쪽 패널 오른쪽 아래에 가장자리가 흐려지는 평면도 미리보기를 두고,
/// 오른쪽에는 사진(없으면 아이콘 그림)과 설명을 담은 카드를 둔다. 설명이
/// 길어 스크롤하면 사진 칸이 줄어든다.
class PlaceConfirmPage extends StatelessWidget {
  const PlaceConfirmPage({super.key});

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

class _Content extends StatefulWidget {
  const _Content({required this.place});

  final Place place;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  static const _previewWidth = 320.0;
  static const _previewHeight = 232.0;

  /// 버튼 줄의 [다른 곳 고르기] : [안내 시작] 너비 비율.
  static const _backFlex = 3;
  static const _startFlex = 7;

  final _tourKey = GlobalKey<GmFloorPlanTourState>();
  bool _starting = false;

  Place get place => widget.place;

  void _back() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.placeSelect);

  /// 미리보기를 전체 보기로 물린 뒤, 같은 평면도가 이동 중 화면 지도로
  /// 날아가도록(Hero) push로 넘어간다.
  Future<void> _start() async {
    if (_starting) return;
    setState(() => _starting = true);
    await _tourKey.currentState?.settle();
    if (!mounted) return;
    await context.push(AppRoutes.guiding(place.key), extra: place);
  }

  @override
  Widget build(BuildContext context) {
    return GmSplitLayout(
      hero: GmHeroPanel(
        top: GmHeroBackButton(onPressed: _back),
        overline: place.meta,
        title: place.name,
        subtitle: '이곳으로 안내할까요?',
        footer: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            width: _previewWidth,
            height: _previewHeight,
            child: Hero(
              tag: GmFloorPlan.heroTag,
              flightShuttleBuilder: GmFloorPlanFade.flightShuttle,
              child: GmFloorPlanFade(
                child: GmFloorPlanTour(key: _tourKey, destination: place.name),
              ),
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _PlaceIntro(place: place)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                flex: _backFlex,
                child: GmButton(
                  label: '다른 곳 고르기',
                  variant: GmButtonVariant.outline,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: _back,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: _startFlex,
                child: GmButton(
                  label: '안내 시작',
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: _start,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 사진(없으면 아이콘 그림) + 설명 카드. 설명을 스크롤하면 사진 칸이
/// [_minImageExtent]까지 줄어든다.
class _PlaceIntro extends StatelessWidget {
  const _PlaceIntro({required this.place});

  final Place place;

  static const _imageShare = 0.62;
  static const _minImageExtent = 120.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: ColoredBox(
        color: colors.surface,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxImage = constraints.maxHeight * _imageShare;
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ImageHeader(
                    maxExtent: maxImage,
                    minExtent: _minImageExtent,
                    child: GmPlaceArt(icon: placeIcon(place)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  sliver: SliverToBoxAdapter(
                    child: Text(place.summary, style: text.bodyLarge),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ImageHeader extends SliverPersistentHeaderDelegate {
  _ImageHeader({
    required this.maxExtent,
    required this.minExtent,
    required this.child,
  });

  @override
  final double maxExtent;
  @override
  final double minExtent;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) =>
      SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_ImageHeader old) =>
      old.maxExtent != maxExtent ||
      old.minExtent != minExtent ||
      old.child != child;
}
