import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../speech/presentation/bloc/voice_guide_cubit.dart';
import '../../speech/presentation/voice_guide_scope.dart';
import '../../speech/presentation/voice_scripts.dart';
import '../domain/tour.dart';
import 'bloc/tour_select_cubit.dart';
import 'tour_widgets.dart';

/// 학교 투어 - 코스 선택. 코스 카드를 옆으로 넘기며 고른다.
///
/// 들어오면 묻는 말과 가운데 코스를 읽고, 카드를 넘기면 가운데 온 코스를
/// 읽는다. 코스 이름을 말하면 그 코스 확인으로 간다.
class TourSelectPage extends StatelessWidget {
  const TourSelectPage({super.key});

  /// 처음 가운데에 오는 코스 (코스가 셋 이상이면 양옆 카드가 보이게 가운데).
  static int initialIndex(int count) => (count - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TourSelectCubit>();
    return VoiceGuideScope(
      onCommand: (context, command) {
        final tours = cubit.state.tours;
        if (command == VoiceScripts.listCommand) {
          context.read<VoiceGuideCubit>().say(VoiceScripts.tourList(tours));
        } else if (command.startsWith(VoiceScripts.tourPrefix)) {
          final key = command.substring(VoiceScripts.tourPrefix.length);
          context.push(AppRoutes.tourConfirm(key));
        }
      },
      child: BlocListener<TourSelectCubit, TourSelectState>(
        listenWhen: (a, b) => a.isLoading && !b.isLoading,
        listener: (context, state) {
          final tours = state.tours;
          context.read<VoiceGuideCubit>().start(
            VoiceScripts.tourSelect(
              tours,
              tours.isEmpty ? null : tours[initialIndex(tours.length)],
            ),
          );
        },
        child: _scaffold(context),
      ),
    );
  }

  Widget _scaffold(BuildContext context) {
    return GmScaffold(
      eyebrow: '학교 투어',
      title: '어떤 코스로 둘러볼까요?',
      onBack: () => context.go(AppRoutes.home),
      body: BlocBuilder<TourSelectCubit, TourSelectState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.tours.isEmpty) {
            return const GmEmptyState(
              icon: Icons.flag_outlined,
              title: '준비된 코스가 없어요',
            );
          }
          return _TourCarousel(
            tours: state.tours,
            onCenterChanged: (tour) => context.read<VoiceGuideCubit>().say(
              VoiceScripts.tourCard(tour),
            ),
          );
        },
      ),
    );
  }
}

/// 옆으로 넘기는 코스 카드. 가운데 카드는 크고 밝게, 양옆 카드는 작고
/// 흐리게 보여 준다. 옆 카드를 누르면 가운데로 옮겨 오고, 가운데 카드를
/// 누르면 코스 확인으로 간다.
class _TourCarousel extends StatefulWidget {
  const _TourCarousel({required this.tours, required this.onCenterChanged});

  final List<Tour> tours;

  /// 방문객이 넘겨 가운데 코스가 바뀌면 그 코스를 알린다.
  final ValueChanged<Tour> onCenterChanged;

  @override
  State<_TourCarousel> createState() => _TourCarouselState();
}

class _TourCarouselState extends State<_TourCarousel> {
  /// 화면 너비 대비 카드 한 장의 너비.
  static const _viewportFraction = 0.42;

  /// 가운데에서 한 칸 떨어진 카드의 크기와 진하기.
  static const _sideScale = 0.88;
  static const _sideOpacity = 0.45;

  static const _dotSize = 8.0;
  static const _activeDotLength = 24.0;
  static const _move = Duration(milliseconds: 420);

  // 코스가 셋 이상이면 가운데 코스에서 시작해 양옆 카드가 보이게 한다.
  late int _current = TourSelectPage.initialIndex(widget.tours.length);
  late final _controller = PageController(
    viewportFraction: _viewportFraction,
    initialPage: _current,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _page {
    if (_controller.hasClients && _controller.position.haveDimensions) {
      return _controller.page ?? _current.toDouble();
    }
    return _current.toDouble();
  }

  void _goTo(int index) => _controller.animateToPage(
    index,
    duration: _move,
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tours = widget.tours;
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: tours.length,
            // 화면 여백 밖으로 넘어가는 옆 카드도 보이게 한다.
            clipBehavior: Clip.none,
            onPageChanged: (i) {
              setState(() => _current = i);
              widget.onCenterChanged(tours[i]);
            },
            itemBuilder: (context, i) {
              final tour = tours[i];
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final d = (_page - i).abs().clamp(0.0, 1.0);
                  return Opacity(
                    opacity: 1 - (1 - _sideOpacity) * d,
                    child: Transform.scale(
                      scale: 1 - (1 - _sideScale) * d,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: _TourCard(
                    tour: tour,
                    onTap: i == _current
                        ? () => context.push(AppRoutes.tourConfirm(tour.key))
                        : () => _goTo(i),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // 몇 번째 코스인지 알려 주는 점.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < tours.length; i++)
              GestureDetector(
                onTap: () => _goTo(i),
                child: AnimatedContainer(
                  duration: AppDuration.slow,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                  ),
                  width: i == _current ? _activeDotLength : _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: i == _current
                        ? colors.primary
                        : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// 코스 카드: 사진 자리 + 코스 이름 + 한 줄 소개 + 걸리는 시간·들를 곳 수.
class _TourCard extends StatelessWidget {
  const _TourCard({required this.tour, required this.onTap});

  final Tour tour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    final meta = text.labelSmall?.copyWith(color: semantic.textSecondary);

    return Semantics(
      button: true,
      label:
          '${tour.name}, ${tour.description}, '
          '${tour.durationLabel}, ${tour.stops.length}곳',
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: tourPhoto(tour)),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tour.name, style: text.headlineLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tour.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: semantic.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: AppSize.iconSm,
                          color: semantic.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(tour.durationLabel, style: meta),
                        const SizedBox(width: AppSpacing.lg),
                        GmIcon(
                          GmIcons.place,
                          size: AppSize.iconSm,
                          color: semantic.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('${tour.stops.length}곳', style: meta),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
