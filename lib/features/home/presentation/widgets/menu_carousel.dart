import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 홈 메뉴 하나.
class HomeMenuItem {
  const HomeMenuItem({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.badge,
  });

  final GmIcons icon;
  final String title;
  final String description;

  /// null이면 아직 쓸 수 없는 메뉴.
  final VoidCallback? onTap;
  final String? badge;
}

/// 세로로 넘기는 메뉴 카드. 가운데 카드는 크고 파랗게, 위아래 카드는 작고
/// 흐리게 보여 준다. 옆 카드를 누르면 가운데로 옮겨 오고, 가운데 카드를
/// 누르면 메뉴로 들어간다.
class MenuCarousel extends StatefulWidget {
  const MenuCarousel({
    super.key,
    required this.items,
    this.flashCount = 0,
    this.onCenterChanged,
  });

  final List<HomeMenuItem> items;

  /// 늘어날 때마다 가운데 카드가 한 번 반짝인다 (음성 안내가 그 카드를 읽을 때).
  final int flashCount;

  /// 방문객이 넘겨 가운데 카드가 바뀌면 그 메뉴를 알린다.
  final ValueChanged<HomeMenuItem>? onCenterChanged;

  @override
  State<MenuCarousel> createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<MenuCarousel>
    with SingleTickerProviderStateMixin {
  /// 화면 높이 대비 카드 한 장의 높이.
  static const _viewportFraction = 0.66;

  /// 가운데에서 한 칸 떨어진 카드의 크기와 진하기.
  static const _sideScale = 0.86;
  static const _sideOpacity = 0.4;

  /// 위아래에서 흐려지는 구간 (높이 대비).
  static const _edgeFade = 0.1;

  static const _dotSize = 8.0;
  static const _activeDotLength = 24.0;
  static const _move = Duration(milliseconds: 420);

  /// 반짝임 한 번의 길이와 가장 밝을 때의 흰 빛, 커지는 정도.
  static const _flash = Duration(milliseconds: 900);
  static const _flashAlpha = 0.35;
  static const _flashScale = 0.04;

  /// 끝없이 넘길 수 있도록 아주 큰 페이지 번호의 가운데에서 시작한다.
  static const _loopBase = 10000;

  late int _current = _loopBase * widget.items.length;
  late final _controller = PageController(
    viewportFraction: _viewportFraction,
    initialPage: _current,
  );

  int get _count => widget.items.length;

  late final _flashController = AnimationController(
    vsync: this,
    duration: _flash,
  );

  @override
  void didUpdateWidget(MenuCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashCount != oldWidget.flashCount) {
      _flashController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
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
    return Row(
      children: [
        Expanded(
          // 위아래 끝에서 잘리는 카드는 흐려지며 사라지게 한다.
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0, _edgeFade, 1 - _edgeFade, 1],
            ).createShader(rect),
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              // itemCount가 없으면 끝없이 넘긴다. 메뉴는 차례대로 되풀이된다.
              onPageChanged: (i) {
                setState(() => _current = i);
                widget.onCenterChanged?.call(widget.items[i % _count]);
              },
              itemBuilder: (context, i) {
                final item = widget.items[i % _count];
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
                    // 주 메뉴의 빛 그림자가 잘리지 않을 만큼 위아래를 띄운다.
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: _Flash(
                      animation: _flashController,
                      enabled: i == _current,
                      child: GmMenuTile(
                        icon: item.icon,
                        title: item.title,
                        description: item.description,
                        badge: item.badge,
                        // 가운데(지금 고른) 카드만 파랑으로 강조한다.
                        emphasized: i == _current,
                        // 가운데가 아닌 카드는 누르면 가운데로 옮겨 온다.
                        onTap: i == _current ? item.onTap : () => _goTo(i),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        // 몇 번째 메뉴인지 알려 주는 세로 점.
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _count; i++)
              GestureDetector(
                onTap: () => _goTo(_current - _current % _count + i),
                child: AnimatedContainer(
                  duration: AppDuration.slow,
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  width: _dotSize,
                  height: i == _current % _count ? _activeDotLength : _dotSize,
                  decoration: BoxDecoration(
                    color: i == _current % _count
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

/// 가운데 카드를 한 번 반짝이게 한다. 흰 빛이 차올랐다 빠지며 살짝 커진다.
class _Flash extends StatelessWidget {
  const _Flash({
    required this.animation,
    required this.enabled,
    required this.child,
  });

  final Animation<double> animation;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        // 0 → 1 → 0으로 한 번 오르내린다.
        final t = Curves.easeInOut.transform(
          1 - (animation.value * 2 - 1).abs(),
        );
        return Transform.scale(
          scale: 1 + _MenuCarouselState._flashScale * t,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              child!,
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: _MenuCarouselState._flashAlpha * t,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
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
